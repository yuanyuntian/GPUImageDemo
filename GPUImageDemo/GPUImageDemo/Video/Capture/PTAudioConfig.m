//
//  PTAudioConfig.m
//  GPUImageDemo
//
//  Created by Fei Yuan on 2021/3/31.
//

#import "PTAudioConfig.h"

@implementation PTAudioConfig

-(instancetype)init {
    if (self = [super init]) {
        self.bitrate = 100000;
        self.channelCount = 1;
        self.sampleSize = 16;
        self.sampleRate = 44100;
    }
    return self;
}

-(aw_faac_config)faacConfig {
    aw_faac_config faac_config;
    faac_config.bitrate = (int32_t)self.bitrate;
    faac_config.channel_count = (int32_t)self.channelCount;
    faac_config.sample_rate = (int32_t)self.sampleRate;
    faac_config.sample_size = (int32_t)self.sampleSize;
    return faac_config;
}

@end
