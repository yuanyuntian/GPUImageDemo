//
//  PTLiveVideoEncoding.h
//  GPUImageDemo
//
//  Created by Fei Yuan on 2021/4/28.
//

#import <Foundation/Foundation.h>
#import "PTLiveVideoConfiguration.h"
#import "PTLiveVideoFrame.h"

NS_ASSUME_NONNULL_BEGIN

@protocol PTLiveVideoEncoding;
/// 编码器编码后回调
@protocol PTLiveVideoEncodingDelegate <NSObject>
@required
- (void)videoEncoder:(nullable id<PTLiveVideoEncoding>)encoder videoFrame:(nullable PTLiveVideoFrame *)frame;
@end

/// 编码器抽象的接口
@protocol PTLiveVideoEncoding <NSObject>
@required
- (void)encodeVideoData:(nullable CVPixelBufferRef)pixelBuffer timeStamp:(uint64_t)timeStamp;

@property (nonatomic, assign) NSInteger videoBitRate;

@optional
- (nullable instancetype)initWithVideoStreamConfiguration:(nullable PTLiveVideoConfiguration *)configuration;
- (void)setDelegate:(nullable id<PTLiveVideoEncodingDelegate>)delegate;
- (void)stopEncoder;

@end

NS_ASSUME_NONNULL_END
