//
//  PTH264Capture.h
//  GPUImageDemo
//
//  Created by Fei Yuan on 2021/4/8.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PTH264Capture : NSObject<AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate>

@property (strong, nonatomic) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, assign) AVCaptureVideoOrientation orientation;
@property (nonatomic, assign) CGSize outputSize;

@property (nonatomic, assign) BOOL running;
@property (nonatomic, assign) BOOL onlyAudio;


// 初始化
- (instancetype)initCameraWithOutputSize:(CGSize)size resolution:(AVCaptureSessionPreset)resolution;

- (void) startCapture;

- (void) swapResolution:(AVCaptureSessionPreset)resolution;
- (void) swapFrontAndBackCameras;

- (void)startRecord;
- (void)stopRecord;


@end

NS_ASSUME_NONNULL_END
