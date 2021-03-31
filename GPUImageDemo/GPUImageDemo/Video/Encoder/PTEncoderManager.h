//
//  PTEncoderManager.h
//  GPUImageDemo
//
//  Created by Fei Yuan on 2021/3/31.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, PTVideoEncoderType) {
    PTVideoEncoderTypeNone,
    PTVideoEncoderTypeHWH264,//硬编码
    PTVideoEncoderTypeSWX264,//软编吗
};

typedef NS_ENUM(NSInteger, PTAudioEncoderType) {
    PTAudioEncoderTypeNone,
    PTAudioEncoderTypeHWH264,//硬编码
    PTAudioEncoderTypeSWX264,//软编吗
};

@class PTVideoEncoder;
@class PTAudioEncoder;
@class PTAudioConfig;
@class PTVideoConfig;

NS_ASSUME_NONNULL_BEGIN

@interface PTEncoderManager : NSObject

//编码器类型
@property (nonatomic, assign) PTAudioEncoderType audioEncoderType;
@property (nonatomic, assign) PTVideoEncoderType videoEncoderType;

//编码器
@property (nonatomic, readonly, strong) PTVideoEncoder *videoEncoder;
@property (nonatomic, readonly, strong) PTAudioEncoder *audioEncoder;

//时间戳
@property (nonatomic, assign) uint32_t timestamp;

//开启关闭
-(void) openWithAudioConfig:(PTAudioConfig *) audioConfig videoConfig:(PTVideoConfig *) videoConfig;
-(void) close;


@end

NS_ASSUME_NONNULL_END
