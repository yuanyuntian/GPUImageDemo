//
//  PTH264HardEncoder.m
//  GPUImageDemo
//
//  Created by Fei Yuan on 2021/4/6.
//

#import "PTH264HardEncoder.h"
#import <VideoToolbox/VideoToolbox.h>

static NSString *const H264FilePath = @"test.h264";


@interface PTH264HardEncoder()
{
    //帧号
    int _frameNO;
    
    //编码队列
    dispatch_queue_t _encodeQueue;
    
    //编码session
    VTCompressionSessionRef _encodingSession;
    
    //sps和pps
    NSData *_sps;
    NSData *_pps;
}
@property (nonatomic,assign)int width;
@property (nonatomic,assign)int height;
@property (nonatomic,assign)BOOL isSave;

@property (nonatomic,strong)NSFileHandle *h264FileHandle; //句柄
@end

@implementation PTH264HardEncoder


- (instancetype)initWidth:(int)width  height:(int)height isSave:(BOOL)save{
    if (self = [super init]) {
        _frameNO = 0;
        _encodeQueue = dispatch_queue_create("com.test.queue", DISPATCH_QUEUE_SERIAL);
        _sps = nil;
        _pps = nil;
        _width = width;
        _height = height;
        _isSave = save;
        [self setVideoToolBox];
        if (save) {
            [self configFileHandle];
        }
    }
    return self;
}

- (void)setVideoToolBox {
    _frameNO = 0;
    int width = self.width, height = self.height;
    OSStatus status = VTCompressionSessionCreate(NULL, width, height, kCMVideoCodecType_H264, NULL, NULL, NULL, finishCompressH264, (__bridge void *)(self),  &_encodingSession);
    NSLog(@"H264: VTCompressionSessionCreate %d", (int)status);
    if (status != 0)
    {
        NSLog(@"H264: Unable to create a H264 session");
        return ;
    }
    
    // 设置实时编码输出（避免延迟）
    VTSessionSetProperty(_encodingSession, kVTCompressionPropertyKey_RealTime, kCFBooleanTrue);
    VTSessionSetProperty(_encodingSession, kVTCompressionPropertyKey_ProfileLevel, kVTProfileLevel_H264_Baseline_AutoLevel);
    
    // 设置关键帧（GOPsize)间隔
    int frameInterval = 24;
    CFNumberRef  frameIntervalRef = CFNumberCreate(kCFAllocatorDefault, kCFNumberIntType, &frameInterval);
    VTSessionSetProperty(_encodingSession, kVTCompressionPropertyKey_MaxKeyFrameInterval, frameIntervalRef);
    
    //设置期望帧率
    int fps = 24;
    CFNumberRef  fpsRef = CFNumberCreate(kCFAllocatorDefault, kCFNumberIntType, &fps);
    VTSessionSetProperty(_encodingSession, kVTCompressionPropertyKey_ExpectedFrameRate, fpsRef);
    
    
    //设置码率，均值，单位是byte
    int bitRate = width * height * 3 * 4 * 8;
    CFNumberRef bitRateRef = CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt32Type, &bitRate);
    VTSessionSetProperty(_encodingSession, kVTCompressionPropertyKey_AverageBitRate, bitRateRef);
    
    //设置码率，上限，单位是bps
    int bitRateLimit = width * height * 3 * 4;
    CFNumberRef bitRateLimitRef = CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt32Type, &bitRateLimit);
    VTSessionSetProperty(_encodingSession, kVTCompressionPropertyKey_DataRateLimits, bitRateLimitRef);
    
    //开始编码
    VTCompressionSessionPrepareToEncodeFrames(_encodingSession);
}


// 编码完成回调
void finishCompressH264(void *outputCallbackRefCon, void *sourceFrameRefCon, OSStatus status, VTEncodeInfoFlags infoFlags, CMSampleBufferRef sampleBuffer) {
    NSLog(@"didCompressH264 called with status %d infoFlags %d", (int)status, (int)infoFlags);
    if (status != 0) {
        return;
    }
    if (!CMSampleBufferDataIsReady(sampleBuffer)) {
        NSLog(@"didCompressH264 data is not ready ");
        return;
    }
    PTH264HardEncoder* encoder = (__bridge PTH264HardEncoder*)outputCallbackRefCon;
    bool keyframe = !CFDictionaryContainsKey( (CFArrayGetValueAtIndex(CMSampleBufferGetSampleAttachmentsArray(sampleBuffer, true), 0)), kCMSampleAttachmentKey_NotSync);
    
    // 判断当前帧是否为关键帧
    // 获取sps & pps数据
    if (keyframe)
    {
        CMFormatDescriptionRef format = CMSampleBufferGetFormatDescription(sampleBuffer);
        size_t sparameterSetSize, sparameterSetCount;
        const uint8_t *sparameterSet;
        OSStatus statusCode = CMVideoFormatDescriptionGetH264ParameterSetAtIndex(format, 0, &sparameterSet, &sparameterSetSize, &sparameterSetCount, 0 );
        if (statusCode == noErr)
        {
            // 获得了sps，再获取pps
            size_t pparameterSetSize, pparameterSetCount;
            const uint8_t *pparameterSet;
            OSStatus statusCode = CMVideoFormatDescriptionGetH264ParameterSetAtIndex(format, 1, &pparameterSet, &pparameterSetSize, &pparameterSetCount, 0 );
            if (statusCode == noErr)
            {
                // 获取SPS和PPS data
                NSData *sps = [NSData dataWithBytes:sparameterSet length:sparameterSetSize];
                NSData *pps = [NSData dataWithBytes:pparameterSet length:pparameterSetSize];
                //回调解码完成的sps和pps数据
                if (encoder.isSave) {
                    [encoder saveSpsPps:sps pps:pps];
                }
                if (encoder.delegate)
                {
                    [encoder.delegate gotSpsPps:sps pps:pps];
                }
            }
        }
    }
    
    CMBlockBufferRef dataBuffer = CMSampleBufferGetDataBuffer(sampleBuffer);
    size_t length, totalLength;
    char *dataPointer;
    
    //这里获取了数据指针，和NALU的帧总长度，前四个字节里面保存的
    OSStatus statusCodeRet = CMBlockBufferGetDataPointer(dataBuffer, 0, &length, &totalLength, &dataPointer);
    if (statusCodeRet == noErr) {
        size_t bufferOffset = 0;
        static const int AVCCHeaderLength = 4; // 返回的nalu数据前四个字节不是0001的startcode，而是大端模式的帧长度length
        
        // 循环获取nalu数据
        while (bufferOffset < totalLength - AVCCHeaderLength) {
            uint32_t NALUnitLength = 0;
            // 读取NALU长度的数据
            memcpy(&NALUnitLength, dataPointer + bufferOffset, AVCCHeaderLength);
            
            // 从大端转系统端
            NALUnitLength = CFSwapInt32BigToHost(NALUnitLength);
            
            NSData* data = [[NSData alloc] initWithBytes:(dataPointer + bufferOffset + AVCCHeaderLength) length:NALUnitLength];
            if (encoder.isSave) {
                [encoder saveEncodedData:data];
            }
            if (encoder.delegate) {
                [encoder.delegate gotEncodedData:data isKeyFrame:keyframe];
            }
            // 移动到下一个NALU单元
            bufferOffset += AVCCHeaderLength + NALUnitLength;
        }
    }
}

//填充SPS和PPS数据
- (void)saveSpsPps:(NSData*)sps pps:(NSData*)pps
{
    NSLog(@"gotSpsPps %d %d", (int)[sps length], (int)[pps length]);
    const char bytes[] = "\x00\x00\x00\x01";
    size_t length = (sizeof bytes) - 1; //string literals have implicit trailing '\0'
    NSData *ByteHeader = [NSData dataWithBytes:bytes length:length];
    [self.h264FileHandle writeData:ByteHeader];
    [self.h264FileHandle writeData:sps];
    [self.h264FileHandle writeData:ByteHeader];
    [self.h264FileHandle writeData:pps];
    
}


//填充NALU数据
- (void)saveEncodedData:(NSData*)data
{
    NSLog(@"gotEncodedData %d", (int)[data length]);
    if (self.h264FileHandle != NULL)
    {
        const char bytes[] = "\x00\x00\x00\x01";
        size_t length = (sizeof bytes) - 1; //string literals have implicit trailing '\0'
        NSData *ByteHeader = [NSData dataWithBytes:bytes length:length];
        [self.h264FileHandle writeData:ByteHeader];
        [self.h264FileHandle writeData:data];
    }
}

//编码sampleBuffer
- (void) encode:(CMSampleBufferRef )sampleBuffer
{
        CVImageBufferRef imageBuffer = (CVImageBufferRef)CMSampleBufferGetImageBuffer(sampleBuffer);
        // 帧时间，如果不设置会导致时间轴过长。
        CMTime presentationTimeStamp = CMTimeMake(_frameNO++, 1000);
        VTEncodeInfoFlags flags;
        OSStatus statusCode = VTCompressionSessionEncodeFrame(_encodingSession,
                                                              imageBuffer,
                                                              presentationTimeStamp,
                                                              kCMTimeInvalid,
                                                              NULL, NULL, &flags);
        if (statusCode != noErr) {
            NSLog(@"H264: VTCompressionSessionEncodeFrame failed with %d", (int)statusCode);
            
            if (_encodingSession) {
                VTCompressionSessionInvalidate(_encodingSession);
                CFRelease(_encodingSession);
                _encodingSession = NULL;
            }
            return;
        }
        NSLog(@"H264: VTCompressionSessionEncodeFrame Success");
}

#pragma mark - private Methods
- (void)configFileHandle{
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:H264FilePath];
    NSLog(@"获取资源:%@", filePath);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //文件存在的话先删除文件
    if ([fileManager fileExistsAtPath:filePath]) {
        [fileManager removeItemAtPath:filePath error:nil];
    }
    [fileManager createFileAtPath:filePath contents:nil attributes:nil];
    self.h264FileHandle = [NSFileHandle fileHandleForWritingAtPath:filePath];
    
    if (!self.h264FileHandle) {
        NSLog(@"创建H264文件句柄失败");
    }
}


-(void)closeFileHandle {
    if (self.h264FileHandle) {
        [self.h264FileHandle closeFile];
        self.h264FileHandle = nil;
    }
}



- (void)stopEncode
{
    if (_encodingSession) {
        VTCompressionSessionCompleteFrames(_encodingSession, kCMTimeInvalid);
        VTCompressionSessionInvalidate(_encodingSession);
        CFRelease(_encodingSession);
        _encodingSession = NULL;
        _frameNO = 0;
    }
    if (self.isSave) {
        [self closeFileHandle];
    }
}

@end