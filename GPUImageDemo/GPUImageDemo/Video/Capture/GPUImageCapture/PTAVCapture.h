//
//  PTAVCapture.h
//  GPUImageDemo
//
//  Created by Fei Yuan on 2021/3/31.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 视频捕获基类。将捕获的音/视频数据送入 encodeSampleQueue串行队列进行编码，然后送入sendSampleQueue队列发送至rtmp接口
 */
@interface PTAVCapture : NSObject

@end

NS_ASSUME_NONNULL_END
