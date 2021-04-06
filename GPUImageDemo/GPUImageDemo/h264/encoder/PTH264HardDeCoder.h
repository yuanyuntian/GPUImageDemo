//
//  PTH264HardDeCoder.h
//  GPUImageDemo
//
//  Created by Fei Yuan on 2021/4/6.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <VideoToolbox/VideoToolbox.h>

NS_ASSUME_NONNULL_BEGIN

@protocol  PTH264DecodeFrameCallbackDelegate <NSObject>

//回调sps和pps数据
- (void)gotDecodedFrame:(CVImageBufferRef )imageBuffer;

@end


@interface PTH264HardDeCoder : NSObject



//解码nalu
-(void)decodeNalu:(uint8_t *)frame size:(uint32_t)frameSize;

- (void)endDecode;

@property (weak, nonatomic) id<PTH264DecodeFrameCallbackDelegate> delegate;


@end

NS_ASSUME_NONNULL_END
