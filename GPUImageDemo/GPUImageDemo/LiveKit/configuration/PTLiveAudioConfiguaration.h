//
//  PTLiveAudioConfiguaration.h
//  GPUImageDemo
//
//  Created by Fei Yuan on 2021/4/27.
//

#import <Foundation/Foundation.h>

///音频码率 (默认96Kbps)
typedef NS_ENUM(NSInteger, PTLiveAudioBitRate) {
    /// 32Kbps 音频码率
    PTAudioBitRate_32Kbps = 32000,
    /// 64Kbps 音频码率
    PTAudioBitRate_64Kbps = 64000,
    /// 96Kbps 音频码率
    PTAudioBitRate_96Kbps = 96000,
    /// 128Kbps 音频码率
    PTAudioBitRate_128Kbps = 128000,
    /// 默认音频码率，默认为 96Kbps
    PTAudioBitRate_Default = PTAudioBitRate_96Kbps
};

/// 音频采样率 (默认44.1KHz)
typedef NS_ENUM (NSUInteger, PTLiveAudioSampleRate){
    /// 16KHz 采样率
    PTAudioSampleRate_16000Hz = 16000,
    /// 44.1KHz 采样率
    PTAudioSampleRate_44100Hz = 44100,
    /// 48KHz 采样率
    PTAudioSampleRate_48000Hz = 48000,
    /// 默认音频采样率，默认为 44.1KHz
    PTAudioSampleRate_Default = PTAudioSampleRate_44100Hz
};

///  Audio Live quality（音频质量）
typedef NS_ENUM (NSUInteger, PTLiveAudioQuality){
    /// 低音频质量 audio sample rate: 16KHz audio bitrate: numberOfChannels 1 : 32Kbps  2 : 64Kbps
    PTAudioQuality_Low = 0,
    /// 中音频质量 audio sample rate: 44.1KHz audio bitrate: 96Kbps
    PTAudioQuality_Medium = 1,
    /// 高音频质量 audio sample rate: 44.1MHz audio bitrate: 128Kbps
    PTAudioQuality_High = 2,
    /// 超高音频质量 audio sample rate: 48KHz, audio bitrate: 128Kbps
    PTAudioQuality_VeryHigh = 3,
    /// 默认音频质量 audio sample rate: 44.1KHz, audio bitrate: 96Kbps
    PTAudioQuality_Default = PTAudioQuality_High
};



NS_ASSUME_NONNULL_BEGIN

@interface PTLiveAudioConfiguaration : NSObject

/// 默认音频配置
+ (instancetype)defaultConfiguration;
/// 音频配置
+ (instancetype)defaultConfigurationForQuality:(PTLiveAudioQuality)audioQuality;

#pragma mark - Attribute
///=============================================================================
/// @name Attribute
///=============================================================================
/// 声道数目(default 2)
@property (nonatomic, assign) NSUInteger numberOfChannels;
/// 采样率
@property (nonatomic, assign) PTLiveAudioSampleRate audioSampleRate;
/// 码率
@property (nonatomic, assign) PTLiveAudioBitRate audioBitrate;
/// flv编码音频头 44100 为0x12 0x10
@property (nonatomic, assign, readonly) char *asc;
/// 缓存区长度
@property (nonatomic, assign,readonly) NSUInteger bufferLength;

@end

NS_ASSUME_NONNULL_END
