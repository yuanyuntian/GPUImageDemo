//
//  PTLiveAudioEncoding.h
//  GPUImageDemo
//
//  Created by Fei Yuan on 2021/4/28.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "PTLiveAudioFrame.h"
#import "PTLiveAudioConfiguaration.h"


NS_ASSUME_NONNULL_BEGIN

@protocol PTLiveAudioEncoding;
/// 编码器编码后回调
@protocol PTLiveAudioEncodingDelegate <NSObject>
@required
- (void)audioEncoder:(nullable id<PTLiveAudioEncoding>)encoder audioFrame:(nullable PTLiveAudioFrame *)frame;
@end

/// 编码器抽象的接口
@protocol PTLiveAudioEncoding <NSObject>
@required
- (void)encodeAudioData:(nullable NSData*)audioData timeStamp:(uint64_t)timeStamp;
- (void)stopEncoder;

@optional
- (nullable instancetype)initWithAudioStreamConfiguration:(nullable PTLiveAudioConfiguaration *)configuration;
- (void)setDelegate:(nullable id<PTLiveAudioEncodingDelegate>)delegate;
- (nullable NSData *)adtsData:(NSInteger)channel rawDataLength:(NSInteger)rawDataLength;

@end

NS_ASSUME_NONNULL_END
