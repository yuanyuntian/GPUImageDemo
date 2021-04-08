//
//  PTH264EncoderController.m
//  GPUImageDemo
//
//  Created by Fei Yuan on 2021/4/6.
//

#import "PTH264EncoderController.h"

#import <AVFoundation/AVFoundation.h>
#import <VideoToolbox/VideoToolbox.h>
#import "PTH264HardEncoder.h"
#import "PTH264HardDeCoder.h"
#import "AAPLEAGLLayer.h"

static NSString *const H264FilePath = @"test.h264";

@interface PTH264EncoderController ()<AVCaptureVideoDataOutputSampleBufferDelegate,PTH264EncodeCallBackDelegate,PTH264DecodeFrameCallbackDelegate>
{
    int frameNO;//帧号
    //录制队列
    dispatch_queue_t _captureQueue;
    
}

@property (nonatomic,strong)AVCaptureSession *captureSession; //输入和输出数据传输session
@property (nonatomic,strong)AVCaptureDeviceInput *captureDeviceInput; //从AVdevice获得输入数据
@property (nonatomic,strong)AVCaptureVideoDataOutput *captureDeviceOutput; //获取输出数据
@property (nonatomic,strong)AVCaptureVideoPreviewLayer *previewLayer; //预览layer
@property (nonatomic,strong)PTH264HardEncoder *h264Encoder; //预览layer
@property (nonatomic,strong)PTH264HardDeCoder *h264Decoder; //预览layer

@property (nonatomic,weak)IBOutlet UIButton *startBtn;

@property (nonatomic,strong)AAPLEAGLLayer *playLayer;  //解码后播放layer


@end

@implementation PTH264EncoderController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUIAndParameter];
    [self configH264Encoder];
    [self configH264Decoder];

}

- (void)initUIAndParameter{
    //初始化队列
    _captureQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
}

//config 摄像头预览layer
- (void)initPreviewLayer{
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
    CGFloat height = (self.view.frame.size.height - 100)/2.0 - 20;
    CGFloat width = self.view.frame.size.width - 100;
    [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspect];
    [self.previewLayer setFrame:CGRectMake(100, 100,width,height)];
    [self.view.layer addSublayer:self.previewLayer];
}

- (void)initPlayLayer{
    CGFloat height = (self.view.frame.size.height - 100)/2.0 - 20;
    CGFloat width = self.view.frame.size.width - 100;
    self.playLayer = [[AAPLEAGLLayer alloc] initWithFrame:CGRectMake(100, (self.view.frame.size.height - 100)/2.0 + 100,width,height)];
    self.playLayer.backgroundColor = [UIColor whiteColor].CGColor;
    [self.view.layer addSublayer:self.playLayer];
}


- (void)configH264Encoder{
    if (!self.h264Encoder) {
        self.h264Encoder = [[PTH264HardEncoder alloc] initWidth:480 height:640 isSave:true];
        self.h264Encoder.delegate = self;
    }
}

- (void)configH264Decoder{
    if (!self.h264Decoder) {
        self.h264Decoder = [PTH264HardDeCoder new];
        self.h264Decoder.delegate = self;
    }
}


- (IBAction)startBtnAction:(id)sender{
    BOOL isRunning = self.captureSession && self.captureSession.running;
    
    if (isRunning) {
        //停止采集编码
        [self.startBtn setTitle:@"Start" forState:UIControlStateNormal];
        [self endCaputureSession];
    }
    else{
        //开始采集编码
        [self.startBtn setTitle:@"End" forState:UIControlStateNormal];
        [self startCaputureSession];
    }
}

- (void)startCaputureSession{
    
    //填充预览
    [self initCapture];
    [self initPreviewLayer];
    [self initPlayLayer];
    
    //开始采集
    [self.captureSession startRunning];
}

- (void)endCaputureSession{
    //停止采集
    [self.captureSession stopRunning];
    [self.previewLayer removeFromSuperlayer];
    //停止编码
    [self.h264Encoder stopEncode];
    
    //停止解码
    [self.h264Decoder endDecode];
    
    self.h264Decoder = nil;
    self.h264Encoder = nil;
    
}




#pragma mark - 摄像头采集端

//初始化摄像头采集端
- (void)initCapture{
    
    self.captureSession = [[AVCaptureSession alloc]init];
    
    //设置录制720p
    self.captureSession.sessionPreset = AVCaptureSessionPreset640x480;
    
    AVCaptureDevice *inputCamera = [self cameraWithPostion:AVCaptureDevicePositionBack];
  
    self.captureDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:inputCamera error:nil];
    
    if ([self.captureSession canAddInput:self.captureDeviceInput]) {
        [self.captureSession addInput:self.captureDeviceInput];
    }
    
    self.captureDeviceOutput = [[AVCaptureVideoDataOutput alloc] init];
    [self.captureDeviceOutput setAlwaysDiscardsLateVideoFrames:NO];
    
    //设置YUV420p输出
    [self.captureDeviceOutput setVideoSettings:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarFullRange] forKey:(id)kCVPixelBufferPixelFormatTypeKey]];
    
    [self.captureDeviceOutput setSampleBufferDelegate:self queue:_captureQueue];
    
    if ([self.captureSession canAddOutput:self.captureDeviceOutput]) {
        [self.captureSession addOutput:self.captureDeviceOutput];
    }
    
    //建立连接
    AVCaptureConnection *connection = [self.captureDeviceOutput connectionWithMediaType:AVMediaTypeVideo];
    [connection setVideoOrientation:AVCaptureVideoOrientationPortrait];
}

//兼容iOS10以上获取AVCaptureDevice
- (AVCaptureDevice *)cameraWithPostion:(AVCaptureDevicePosition)position{
    NSString *version = [UIDevice currentDevice].systemVersion;
    if (version.doubleValue >= 10.0) {
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

- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    [self.h264Encoder encode:sampleBuffer];
}

#pragma mark - 编码回调
- (void)gotSpsPps:(NSData *)sps pps:(NSData *)pps{
    const char bytes[] = "\x00\x00\x00\x01";
    size_t length = (sizeof bytes) - 1;
    NSData *ByteHeader = [NSData dataWithBytes:bytes length:length];
    //sps
    NSMutableData *h264Data = [[NSMutableData alloc] init];
    [h264Data appendData:ByteHeader];
    [h264Data appendData:sps];
    [self.h264Decoder decodeNalu:(uint8_t *)[h264Data bytes] size:(uint32_t)h264Data.length];
    
    
    //pps
    [h264Data resetBytesInRange:NSMakeRange(0, [h264Data length])];
    [h264Data setLength:0];
    [h264Data appendData:ByteHeader];
    [h264Data appendData:pps];
    [self.h264Decoder decodeNalu:(uint8_t *)[h264Data bytes] size:(uint32_t)h264Data.length];
}

- (void)gotEncodedData:(NSData *)data isKeyFrame:(BOOL)isKeyFrame{
    const char bytes[] = "\x00\x00\x00\x01";
    size_t length = (sizeof bytes) - 1;
    NSData *ByteHeader = [NSData dataWithBytes:bytes length:length];
    NSMutableData *h264Data = [[NSMutableData alloc] init];
    [h264Data appendData:ByteHeader];
    [h264Data appendData:data];
    [self.h264Decoder decodeNalu:(uint8_t *)[h264Data bytes] size:(uint32_t)h264Data.length];
}



- (void)gotDecodedFrame:(CVImageBufferRef )imageBuffer {
    if(imageBuffer)
    {
        //解码回来的数据绘制播放
        self.playLayer.pixelBuffer = imageBuffer;
        CVPixelBufferRelease(imageBuffer);
    }
}


@end
