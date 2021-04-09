//
//  PTx264Encoder.h
//  GPUImageDemo
//
//  Created by Fei Yuan on 2021/4/9.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>


 

NS_ASSUME_NONNULL_BEGIN

@interface PTx264Encoder : NSObject

- (instancetype)initEncoderWidth:(int)width  height:(int)height;

/*
 * 设置X264
 */
- (void)setX264Config;

/*
 * 将CMSampleBufferRef格式的数据编码成h264并写入文件
 */
- (void)encoder:(CMSampleBufferRef)sampleBuffer;

/*
 * 释放资源
 */
- (void)free;
@end

NS_ASSUME_NONNULL_END
