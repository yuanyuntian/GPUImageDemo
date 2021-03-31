//
//  PTEncoder.h
//  GPUImageDemo
//
//  Created by Fei Yuan on 2021/3/31.
//

//#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

typedef NS_ENUM(NSInteger, PTEncoderErrorCode) {
    PTEncoderErrorCodeVTSessionCreateFailed,
    PTEncoderErrorCodeVTSessionPrepareFailed,
    PTEncoderErrorCodeLockSampleBaseAddressFailed,
    PTEncoderErrorCodeEncodeVideoFrameFailed,
    PTEncoderErrorCodeEncodeCreateBlockBufFailed,
    PTEncoderErrorCodeEncodeCreateSampleBufFailed,
    PTEncoderErrorCodeEncodeGetSpsPpsFailed,
    PTEncoderErrorCodeEncodeGetH264DataFailed,
    
    PTEncoderErrorCodeCreateAudioConverterFailed,
    PTEncoderErrorCodeAudioConverterGetMaxFrameSizeFailed,
    PTEncoderErrorCodeAudioEncoderFailed,
};

NS_ASSUME_NONNULL_BEGIN

@class PTEncoderManager;
///编码器基类
@interface PTEncoder : NSObject

@property (nonatomic, weak) PTEncoderManager *manager;
//开始
-(void) open;
//结束
-(void) close;
//错误
-(void) onErrorWithCode:(PTEncoderErrorCode) code des:(NSString *) des;

@end

NS_ASSUME_NONNULL_END
