//
//  PTH264Capture.m
//  GPUImageDemo
//
//  Created by Fei Yuan on 2021/4/8.
//

#import "PTH264Capture.h"
#include <pthread.h>
#import "PTHh264Encoder.h"
#import <VideoToolbox/VideoToolbox.h>
#import "AVAssetWriteManager.h"
#import "XCFileManager.h"
#import "PTHaacEncoder.h"


@interface PTH264Capture()<H264HWEncoderDelegate,AVAssetWriteManagerDelegate,PTAACEncoderDelegate>{
    pthread_mutex_t _releaseLock;
    CGSize _tempOutputSize;

}
@property (nonatomic, strong) dispatch_queue_t encodeQueue;
@property (nonatomic, strong) dispatch_queue_t videoQueue;
@property (nonatomic, strong) dispatch_queue_t audioQueue;

// 负责从 AVCaptureDevice 获得输入数据
@property (nonatomic, strong) AVCaptureDeviceInput *captureDeviceInput;
@property (nonatomic, strong) AVCaptureVideoDataOutput *videoOutput;

@property (nonatomic, strong) AVCaptureConnection *videoConnection;
@property (nonatomic, strong) AVCaptureConnection *audioConnection;

@property (nonatomic, strong) AVCaptureSession *videoCaptureSession;

@property (nonatomic, strong) PTHh264Encoder *h264Encoder;
@property (nonatomic, strong) PTHaacEncoder *aacEncoder;


@property (nonatomic, strong) AVAssetWriteManager *writeManager;
@property (nonatomic, strong) NSURL* videoUrl;
@property (nonatomic, assign) FMRecordState recordState;
@end

@implementation PTH264Capture

- (instancetype)initCameraWithOutputSize:(CGSize)size resolution:(AVCaptureSessionPreset)resolution {
    if (self = [super init]) {
        self.outputSize = size;
        
        pthread_mutex_init(&_releaseLock, 0);
        
        self.encodeQueue = dispatch_queue_create("ptEncodeQueue", NULL);
        
        self.running = true;
        [self setupEncoder];
        self.videoCaptureSession = [AVCaptureSession new];
        [self setupAudioCapture];
        [self setupVideoCapture:resolution];
    }
    return self;
}

-(void)setupEncoder {
    
    // 初始化硬编码
    self.h264Encoder = [[PTHh264Encoder alloc] initEncoderWidth:self.outputSize.width height:self.outputSize.height];
    self.h264Encoder.delegate = self;
    
    self.aacEncoder = [PTHaacEncoder new];
    self.aacEncoder.delegate = self;
}

- (void) setOutputSize:(CGSize)outputSize {
    _outputSize = outputSize;
    
    if (_outputSize.width > 0) {
        _tempOutputSize = CGSizeMake(_outputSize.width, _outputSize.height);
    }
}

- (void)startCapture {
    [self.videoCaptureSession startRunning];
    [self setUpWriter];
}

- (void) setOrientation:(AVCaptureVideoOrientation)orientation {
    _orientation = orientation;
    
    if (self.videoConnection) {
        self.videoConnection.videoOrientation = self.orientation;
    }
}

- (void)startRecord {
    if (self.recordState != FMRecordStateRecording) {
        [self.writeManager startWrite];
        self.recordState = FMRecordStateRecording;
    }
}

- (void)stopRecord {
    [self.writeManager stopWrite];
    self.recordState = FMRecordStateFinish;
    [self setUpWriter];
}

#pragma mark - 设置采集的 Video 和 Audio 格式，这两个是分开设置的，也就是说，你可以只采集视频

// 音频采集配置
- (void)setupAudioCapture {
    AVCaptureDevice *audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    
    NSError *error = nil;
    AVCaptureDeviceInput *audioInput = [[AVCaptureDeviceInput alloc] initWithDevice:audioDevice error:&error];
    if (error) {
        NSLog(@"Error getting audio input device:%@", error.description);
    }
    
    if ([self.videoCaptureSession canAddInput:audioInput]) {
        [self.videoCaptureSession addInput:audioInput];
    }
    
    self.audioQueue = dispatch_queue_create("Audio Capture Queue", DISPATCH_QUEUE_SERIAL);
    AVCaptureAudioDataOutput *audioOutput = [AVCaptureAudioDataOutput new];
    
    [audioOutput setSampleBufferDelegate:self queue:self.audioQueue];
    
    if ([self.videoCaptureSession canAddOutput:audioOutput]) {
        [self.videoCaptureSession addOutput:audioOutput];
    }
    self.audioConnection = [audioOutput connectionWithMediaType:AVMediaTypeAudio];
}

// 视频采集配置
- (void)setupVideoCapture:(AVCaptureSessionPreset)resolution {
    if ([self.videoCaptureSession canSetSessionPreset:resolution]) {
        self.videoCaptureSession.sessionPreset = resolution;
    }
    
    // 配置采集输入源(摄像头)
    NSError *error = nil;
    // 获得一个采集设备, 例如前置/后置摄像头
    AVCaptureDevice *videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // 用设备初始化一个采集的输入对象
    AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
    if (error) {
        NSLog(@"Error getting video input device:%@", error.description);
    }
    
    if ([self.videoCaptureSession canAddInput:videoInput]) {
        [self.videoCaptureSession addInput:videoInput];
    }
    
    // 配置采集输出,即我们取得视频图像的接口
    self.videoQueue = dispatch_queue_create("Video Capture Queue", DISPATCH_QUEUE_SERIAL);
    self.videoOutput = [AVCaptureVideoDataOutput new];
    [self.videoOutput setSampleBufferDelegate:self queue:_videoQueue];
    
    // 配置输出视频图像格式
    [self.videoOutput setVideoSettings:@{(__bridge NSString *)kCVPixelBufferPixelFormatTypeKey:@(kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange)}];
    self.videoOutput.alwaysDiscardsLateVideoFrames = NO;
//    self.videoOutput.alwaysDiscardsLateVideoFrames = YES;//立即丢弃旧帧，节省内存，默认YES
    if ([self.videoCaptureSession canAddOutput:self.videoOutput]) {
        [self.videoCaptureSession addOutput:self.videoOutput];
    }
    // 设置采集图像的方向,如果不设置，采集回来的图形会是旋转90度的
    self.videoConnection = [self.videoOutput connectionWithMediaType:AVMediaTypeVideo];
    self.videoConnection.videoOrientation = self.orientation;
    // 保存Connection,用于SampleBufferDelegate中判断数据来源(video or audio?)
    self.videoConnection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeAuto;
    self.videoConnection = [self.videoOutput connectionWithMediaType:AVMediaTypeVideo];
    
    // 将当前硬件采集视频图像显示到屏幕
    // 添加预览
    self.previewLayer = [AVCaptureVideoPreviewLayer  layerWithSession:self.videoCaptureSession];
    [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
}

// 切换分辨率
- (void) swapResolution:(AVCaptureSessionPreset)resolution {
    [self.videoCaptureSession beginConfiguration];
    
    if ([self.videoCaptureSession canSetSessionPreset:resolution]) {
        self.videoCaptureSession.sessionPreset = resolution;
    }
    [self.videoCaptureSession commitConfiguration];
}

// 切换前后摄像头
- (void)swapFrontAndBackCameras {
    // Assume the session is already _running
    NSArray *inputs = self.videoCaptureSession.inputs;
    for (AVCaptureDeviceInput *input in inputs) {
        AVCaptureDevice *device = input.device;
        if ([device hasMediaType:AVMediaTypeVideo]) {
            CATransition *animation = [CATransition animation];
            animation.duration = .5f;
            animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            animation.type = @"oglFlip";
            
            AVCaptureDevice *newCamera = nil;
            if (device.position == AVCaptureDevicePositionFront) {
                newCamera = [self cameraWithPostion:AVCaptureDevicePositionBack];
                animation.subtype = kCATransitionFromLeft;  // 动画翻转方向
            } else {
                newCamera = [self cameraWithPostion:AVCaptureDevicePositionFront];
                animation.subtype = kCATransitionFromRight; // 动画翻转方向
            }
            
            [self.previewLayer addAnimation:animation forKey:nil];
            
            // beginConfiguration ensures that pending changes are not applied immediately
            [self.videoCaptureSession beginConfiguration];
            [self.videoCaptureSession removeInput:input];
            AVCaptureDeviceInput *newInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:nil];
            
            if ([self.videoCaptureSession canAddInput:newInput]) {
                [self.videoCaptureSession addInput:newInput];
            } else {
                [self.videoCaptureSession addInput:input];
            }
            
            [self.videoCaptureSession removeOutput:self.videoOutput];
            AVCaptureVideoDataOutput *new_videoOutput = [AVCaptureVideoDataOutput new];
            self.videoOutput = new_videoOutput;
            [new_videoOutput setSampleBufferDelegate:self queue:_videoQueue];
            // 配置输出视频图像格式
            NSDictionary *captureSettings = @{(NSString*)kCVPixelBufferPixelFormatTypeKey: @(kCVPixelFormatType_32BGRA)};
            new_videoOutput.videoSettings = captureSettings;
            new_videoOutput.alwaysDiscardsLateVideoFrames = YES;//立即丢弃旧帧，节省内存，默认YES
            if ([self.videoCaptureSession canAddOutput:new_videoOutput]) {
                [self.videoCaptureSession addOutput:new_videoOutput];
            }
            // 设置采集图像的方向,如果不设置，采集回来的图形会是旋转90度的
            _videoConnection = [new_videoOutput connectionWithMediaType:AVMediaTypeVideo];
            _videoConnection.videoOrientation = self.orientation;
            // 保存Connection,用于SampleBufferDelegate中判断数据来源(video or audio?)
            _videoConnection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeAuto;
            _videoConnection = [new_videoOutput connectionWithMediaType:AVMediaTypeVideo];
            
            // Changes take effect once the outermost commitConfiguration is invoked.
            [self.videoCaptureSession commitConfiguration];
            
            break;
        }
    }
}

//兼容iOS10以上获取AVCaptureDevice
- (AVCaptureDevice *)cameraWithPostion:(AVCaptureDevicePosition)position{

    if (@available(iOS 10.0, *)) {
        // iOS10以上
        AVCaptureDeviceDiscoverySession *devicesIOS10 = [AVCaptureDeviceDiscoverySession  discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInWideAngleCamera] mediaType:AVMediaTypeVideo position:position];
        NSArray *devicesIOS  = devicesIOS10.devices;
        for (AVCaptureDevice *device in devicesIOS) {
            if ([device position] == position) {
                return device;
            }
        }
        return nil;
    } else {
        // iOS10以下
        NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
        for (AVCaptureDevice *device in devices)
        {
            if ([device position] == position)
            {
                return device;
            }
        }
        return nil;
    }
}

#pragma -mark AVCaptureAudioDataOutputSampleBufferDelegate && AVCaptureVideoDataOutputSampleBufferDelegate
- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    
    [self recordCaptureOutput:output didOutputSampleBuffer:sampleBuffer fromConnection:connection];
    
    CFRetain(sampleBuffer);
    if(connection == self.videoConnection) {
        dispatch_async(self.encodeQueue, ^{
            if (!self.onlyAudio) {
                
//                    if ([URLTool gainX264Enxoder]) {
//                        [self.x264Encoder encoding:sampleBuffer];
//                    } else {
//                        [self.h264Encoder encode:sampleBuffer size:self.outputSize];
//                    }
            }
            [self.h264Encoder encode:sampleBuffer];
//            self.outputSize = CGSizeMake(0, 0);// 输出尺寸置空，则不需要再初始化VTCompressionSessionRef
            CFRelease(sampleBuffer);
        });
    } else if(connection == self.audioConnection) {
        dispatch_async(self.encodeQueue, ^{
                [self.aacEncoder encode:sampleBuffer];
            CFRelease(sampleBuffer);
        });
    }
}

- (void)gotH264EncodedData:(NSData *)packet keyFrame:(BOOL)keyFrame timestamp:(CMTime)timestamp error:(NSError*)error {
}

- (void)gotAACEncodedData:(NSData *)data timestamp:(CMTime)timestamp error:(NSError*)error {
    NSLog(@"---%d",timestamp.value);
}

-(void)dealloc {
    if (self.videoCaptureSession) {
        [self.videoCaptureSession stopRunning];
    }
    
    if (self.h264Encoder) {
        [self.h264Encoder invalidate];
    }
}

- (void)setUpWriter {
    self.videoUrl = [[NSURL alloc] initFileURLWithPath:[self createVideoFilePath]];
    self.writeManager = [[AVAssetWriteManager alloc] initWithURL:self.videoUrl viewType:TypeFullScreen];
    self.writeManager.delegate = self;
}

- (void) recordCaptureOutput:(AVCaptureOutput*)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection*)connection {
    if (self.recordState != FMRecordStateRecording) {
        return;
    }
    
    @autoreleasepool {
        if(connection == self.videoConnection) {// 视频
            if (!self.writeManager.outputVideoFormatDescription) {
                @synchronized(self) {
                    CMFormatDescriptionRef formatDescription = CMSampleBufferGetFormatDescription(sampleBuffer);
                    self.writeManager.outputVideoFormatDescription = formatDescription;
                }
            } else {
                @synchronized(self) {
                    if (self.writeManager.writeState == FMRecordStateRecording) {
                        [self.writeManager appendSampleBuffer:sampleBuffer ofMediaType:AVMediaTypeVideo];
                    }
                }
            }
        } else if(connection == self.audioConnection) {// 音频
            if (!self.writeManager.outputAudioFormatDescription) {
                @synchronized(self) {
                    CMFormatDescriptionRef formatDescription = CMSampleBufferGetFormatDescription(sampleBuffer);
                    self.writeManager.outputAudioFormatDescription = formatDescription;
                }
            }
            @synchronized(self) {
                if (self.writeManager.writeState == FMRecordStateRecording) {
                    [self.writeManager appendSampleBuffer:sampleBuffer ofMediaType:AVMediaTypeAudio];
                }
            }
        }
    }
}



// 写入的视频路径
- (NSString *)createVideoFilePath {
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];// 创建一个时间格式化对象
    [dateFormatter setDateFormat:@"YYYYMMdd_hhmmss"];//设定时间格式,这里可以设置成自己需要的格式
    NSString *dateString = [dateFormatter stringFromDate:currentDate];//将时间转化成字符串
    
//    NSString *videoName = [NSString stringWithFormat:@"%@.mp4", [NSUUID UUID].UUIDString];
    NSString *videoName = [NSString stringWithFormat:@"%@.mp4", dateString];
    NSString *path = [[self videoFolder] stringByAppendingPathComponent:videoName];
    return path;
}

// 存放视频的文件夹
- (NSString *)videoFolder {
    NSString *cacheDir = [XCFileManager cachesDir];
    NSString *direc = [cacheDir stringByAppendingPathComponent:@"videos"];
    if (![XCFileManager isExistsAtPath:direc]) {
        [XCFileManager createDirectoryAtPath:direc];
    }
    
    return direc;
}


@end
