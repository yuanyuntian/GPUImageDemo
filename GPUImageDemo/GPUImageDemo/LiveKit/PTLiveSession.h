//
//  PTLiveSession.h
//  GPUImageDemo
//
//  Created by Fei Yuan on 2021/4/28.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import "PTLiveVideoConfiguration.h"
#import "PTLiveAudioConfiguaration.h"

typedef NS_ENUM(NSInteger,PTLiveCaptureType) {
    PTCaptureAudio,         //< capture only audio
    PTCaptureVideo,         //< capture onlt video
    PTInputAudio,           //< only audio (External input audio)
    PTInputVideo,           //< only video (External input video)
};


///< 用来控制采集类型（可以内部采集也可以外部传入等各种组合，支持单音频与单视频,外部输入适用于录屏，无人机等外设介入）
typedef NS_ENUM(NSInteger,PTLiveCaptureTypeMask) {
    PTCaptureMaskAudio = (1 << PTCaptureAudio),                                 ///< only inner capture audio (no video)
    PTCaptureMaskVideo = (1 << PTCaptureVideo),                                 ///< only inner capture video (no audio)
    PTInputMaskAudio = (1 << PTInputAudio),                                     ///< only outer input audio (no video)
    PTInputMaskVideo = (1 << PTInputVideo),                                     ///< only outer input video (no audio)
    PTCaptureMaskAll = (PTCaptureMaskAudio | PTCaptureMaskVideo),           ///< inner capture audio and video
    PTInputMaskAll = (PTInputMaskAudio | PTInputMaskVideo),                 ///< outer input audio and video(method see pushVideo and pushAudio)
    PTCaptureMaskAudioInputVideo = (PTCaptureMaskAudio | PTInputMaskVideo), ///< inner capture audio and outer input video(method pushVideo and setRunning)
    PTCaptureMaskVideoInputAudio = (PTCaptureMaskVideo | PTInputMaskAudio), ///< inner capture video and outer input audio(method pushAudio and setRunning)
    PTCaptureDefaultMask = PTInputMaskAll                                     ///< default is inner capture audio and video
};


NS_ASSUME_NONNULL_BEGIN

@interface PTLiveSession : NSObject

#pragma mark - Attribute
///=============================================================================
/// @name Attribute
///=============================================================================
/** The delegate of the capture. captureData callback */
//@property (nullable, nonatomic, weak) id<LFLiveSessionDelegate> delegate;

/** The running control start capture or stop capture*/
@property (nonatomic, assign) BOOL running;

/** The preView will show OpenGL ES view*/
@property (nonatomic, strong, null_resettable) UIView *preView;

/** The captureDevicePosition control camraPosition ,default front*/
@property (nonatomic, assign) AVCaptureDevicePosition captureDevicePosition;

/** The beautyFace control capture shader filter empty or beautiy */
@property (nonatomic, assign) BOOL beautyFace;

/** The beautyLevel control beautyFace Level. Default is 0.5, between 0.0 ~ 1.0 */
@property (nonatomic, assign) CGFloat beautyLevel;

/** The brightLevel control brightness Level, Default is 0.5, between 0.0 ~ 1.0 */
@property (nonatomic, assign) CGFloat brightLevel;

/** The torch control camera zoom scale default 1.0, between 1.0 ~ 3.0 */
@property (nonatomic, assign) CGFloat zoomScale;

/** The torch control capture flash is on or off */
@property (nonatomic, assign) BOOL torch;

/** The mirror control mirror of front camera is on or off */
@property (nonatomic, assign) BOOL mirror;

/** The muted control callbackAudioData,muted will memset 0.*/
@property (nonatomic, assign) BOOL muted;

/*  The adaptiveBitrate control auto adjust bitrate. Default is NO */
@property (nonatomic, assign) BOOL adaptiveBitrate;

/** The stream control upload and package*/
//@property (nullable, nonatomic, strong, readonly) LFLiveStreamInfo *streamInfo;

/** The status of the stream .*/
//@property (nonatomic, assign, readonly) LFLiveState state;

/** The captureType control inner or outer audio and video .*/
@property (nonatomic, assign, readonly) PTLiveCaptureTypeMask captureType;

/** The showDebugInfo control streamInfo and uploadInfo(1s) *.*/
@property (nonatomic, assign) BOOL showDebugInfo;

/** The reconnectInterval control reconnect timeInterval(重连间隔) *.*/
@property (nonatomic, assign) NSUInteger reconnectInterval;

/** The reconnectCount control reconnect count (重连次数) *.*/
@property (nonatomic, assign) NSUInteger reconnectCount;

/*** The warterMarkView control whether the watermark is displayed or not ,if set ni,will remove watermark,otherwise add.
 set alpha represent mix.Position relative to outVideoSize.
 *.*/
@property (nonatomic, strong, nullable) UIView *warterMarkView;

/* The currentImage is videoCapture shot */
@property (nonatomic, strong,readonly ,nullable) UIImage *currentImage;

/* The saveLocalVideo is save the local video */
@property (nonatomic, assign) BOOL saveLocalVideo;

/* The saveLocalVideoPath is save the local video  path */
@property (nonatomic, strong, nullable) NSURL *saveLocalVideoPath;


- (nullable instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (nullable instancetype)new UNAVAILABLE_ATTRIBUTE;

/**
   The designated initializer. Multiple instances with the same configuration will make the
   capture unstable.
 */
- (nullable instancetype)initWithAudioConfiguration:(nullable PTLiveAudioConfiguaration *)audioConfiguration videoConfiguration:(nullable PTLiveVideoConfiguration *)videoConfiguration;

/**
 The designated initializer. Multiple instances with the same configuration will make the
 capture unstable.
 */
- (nullable instancetype)initWithAudioConfiguration:(nullable PTLiveAudioConfiguaration *)audioConfiguration videoConfiguration:(nullable PTLiveVideoConfiguration *)videoConfiguration captureType:(PTLiveCaptureTypeMask)captureType NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
