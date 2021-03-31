//
//  PTGPUImageVideoCamera.h
//  GPUImageDemo
//
//  Created by Fei Yuan on 2021/3/31.
//

#import <Foundation/Foundation.h>
#import <GPUImage/GPUImage.h>

@protocol PTGPUImageVideoCameraDelegate <NSObject>

-(void) processAudioSample:(CMSampleBufferRef)sampleBuffer;

@end

NS_ASSUME_NONNULL_BEGIN

@interface PTGPUImageVideoCamera : GPUImageVideoCamera

@property (nonatomic, weak) id<PTGPUImageVideoCameraDelegate> audioDelegate;

-(void)setCaptureSessionPreset:(NSString *)captureSessionPreset;

@end

NS_ASSUME_NONNULL_END
