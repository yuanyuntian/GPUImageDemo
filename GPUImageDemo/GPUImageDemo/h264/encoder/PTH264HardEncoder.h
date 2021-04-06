//
//  PTH264HardEncoder.h
//  GPUImageDemo
//
//  Created by Fei Yuan on 2021/4/6.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PTH264EncodeCallBackDelegate <NSObject>

//回调sps和pps数据
- (void)gotSpsPps:(NSData*)sps pps:(NSData*)pps;

//回调H264数据和是否是关键帧
- (void)gotEncodedData:(NSData*)data isKeyFrame:(BOOL)isKeyFrame;

@end

@interface PTH264HardEncoder : NSObject

//初始化视频宽高
- (instancetype)initWidth:(int)width  height:(int)height isSave:(BOOL)save;

//编码CMSampleBufferRef
- (void) encode:(CMSampleBufferRef )sampleBuffer;


//停止编码
- (void) stopEncode;

@property (weak, nonatomic) id<PTH264EncodeCallBackDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
