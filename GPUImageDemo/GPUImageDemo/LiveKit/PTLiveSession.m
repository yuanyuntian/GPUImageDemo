//
//  PTLiveSession.m
//  GPUImageDemo
//
//  Created by Fei Yuan on 2021/4/28.
//

#import "PTLiveSession.h"
#import "PTLiveAudioCapture.h"
#import "PTLiveVideoCapture.h"

#import "PTLiveAudioEncoding.h"
#import "PTLiveVideoEncoding.h"


@interface PTLiveSession ()

/// 音频配置
@property (nonatomic, strong) PTLiveAudioConfiguaration *audioConfiguration;
/// 视频配置
@property (nonatomic, strong) PTLiveVideoConfiguration *videoConfiguration;
/// 声音采集
@property (nonatomic, strong) PTLiveAudioCapture *audioCaptureSource;
/// 视频采集
@property (nonatomic, strong) PTLiveVideoCapture *videoCaptureSource;
/// 音频编码
@property (nonatomic, strong) id<PTLiveAudioEncoding> audioEncoder;
/// 视频编码
@property (nonatomic, strong) id<PTLiveVideoEncoding> videoEncoder;

#pragma mark -- 内部标识
///// 调试信息
//@property (nonatomic, strong) LFLiveDebug *debugInfo;
///// 流信息
//@property (nonatomic, strong) LFLiveStreamInfo *streamInfo;
/// 是否开始上传
@property (nonatomic, assign) BOOL uploading;
/// 当前状态
//@property (nonatomic, assign, readwrite) LFLiveState state;
/// 当前直播type
@property (nonatomic, assign, readwrite) PTLiveCaptureTypeMask captureType;
/// 时间戳锁
@property (nonatomic, strong) dispatch_semaphore_t lock;

/// 上传相对时间戳
@property (nonatomic, assign) uint64_t relativeTimestamps;
/// 音视频是否对齐
@property (nonatomic, assign) BOOL AVAlignment;
/// 当前是否采集到了音频
@property (nonatomic, assign) BOOL hasCaptureAudio;
/// 当前是否采集到了关键帧
@property (nonatomic, assign) BOOL hasKeyFrameVideo;


@end

/**  时间戳 */
#define NOW (CACurrentMediaTime()*1000)


@implementation PTLiveSession

- (nullable instancetype)initWithAudioConfiguration:(nullable PTLiveAudioConfiguaration *)audioConfiguration videoConfiguration:(nullable PTLiveVideoConfiguration *)videoConfiguration {
    return [self initWithAudioConfiguration:audioConfiguration videoConfiguration:videoConfiguration captureType:PTCaptureDefaultMask];
}

- (nullable instancetype)initWithAudioConfiguration:(nullable PTLiveAudioConfiguaration *)audioConfiguration videoConfiguration:(nullable PTLiveVideoConfiguration *)videoConfiguration captureType:(PTLiveCaptureTypeMask)captureType  {
    if((captureType & PTCaptureMaskAudio || captureType & PTInputMaskAudio) && !audioConfiguration) @throw [NSException exceptionWithName:@"LFLiveSession init error" reason:@"audioConfiguration is nil " userInfo:nil];
    if((captureType & PTCaptureMaskVideo || captureType & PTInputMaskVideo) && !videoConfiguration) @throw [NSException exceptionWithName:@"LFLiveSession init error" reason:@"videoConfiguration is nil " userInfo:nil];
    if (self = [super init]) {
        _audioConfiguration = audioConfiguration;
        _videoConfiguration = videoConfiguration;
        _adaptiveBitrate = NO;
        _captureType = captureType;
    }
    return self;
}

#pragma mark -- CaptureDelegate
- (void)captureOutput:(nullable PTLiveAudioCapture *)capture audioData:(nullable NSData*)audioData {
    if (self.uploading) [self.audioEncoder encodeAudioData:audioData timeStamp:NOW];
}

- (void)captureOutput:(nullable PTLiveVideoCapture *)capture pixelBuffer:(nullable CVPixelBufferRef)pixelBuffer {
    if (self.uploading) [self.videoEncoder encodeVideoData:pixelBuffer timeStamp:NOW];
}

#pragma mark -- EncoderDelegate
- (void)audioEncoder:(nullable id<PTLiveAudioEncoding>)encoder audioFrame:(nullable PTLiveAudioFrame *)frame {
    //<上传  时间戳对齐
    if (self.uploading){
        self.hasCaptureAudio = YES;
//        if(self.AVAlignment) [self pushSendBuffer:frame];
    }
}

- (void)videoEncoder:(nullable id<PTLiveVideoEncoding>)encoder videoFrame:(nullable PTLiveVideoFrame *)frame {
    //<上传 时间戳对齐
    if (self.uploading){
        if(frame.isKeyFrame && self.hasCaptureAudio) self.hasKeyFrameVideo = YES;
//        if(self.AVAlignment) [self pushSendBuffer:frame];
    }
}

- (dispatch_semaphore_t)lock{
    if(!_lock){
        _lock = dispatch_semaphore_create(1);
    }
    return _lock;
}

- (uint64_t)uploadTimestamp:(uint64_t)captureTimestamp{
    dispatch_semaphore_wait(self.lock, DISPATCH_TIME_FOREVER);
    uint64_t currentts = 0;
    currentts = captureTimestamp - self.relativeTimestamps;
    dispatch_semaphore_signal(self.lock);
    return currentts;
}

- (BOOL)AVAlignment{
    if((self.captureType & PTCaptureMaskAudio || self.captureType & PTInputMaskAudio) &&
       (self.captureType & PTCaptureMaskVideo || self.captureType & PTInputMaskVideo)
       ){
        if(self.hasCaptureAudio && self.hasKeyFrameVideo) return YES;
        else  return NO;
    }else{
        return YES;
    }
}


- (void)dealloc {
    _videoCaptureSource.running = NO;
    _audioCaptureSource.running = NO;
}
@end
