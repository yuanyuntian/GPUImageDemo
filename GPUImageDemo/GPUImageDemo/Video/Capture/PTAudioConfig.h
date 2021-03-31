//
//  PTAudioConfig.h
//  GPUImageDemo
//
//  Created by Fei Yuan on 2021/3/31.
//

#import <Foundation/Foundation.h>
#import "aw_all.h"

NS_ASSUME_NONNULL_BEGIN


/// 音频配置文件
@interface PTAudioConfig : NSObject

@property (nonatomic, assign) NSInteger bitrate;//比特率 可自由设置
@property (nonatomic, assign) NSInteger channelCount;//通道
@property (nonatomic, assign) NSInteger sampleRate;//采样率 44100 22050 11025 5500
@property (nonatomic, assign) NSInteger sampleSize;//采样位数 16 8

@property (nonatomic, readonly, assign) aw_faac_config faacConfig;

@end

NS_ASSUME_NONNULL_END
