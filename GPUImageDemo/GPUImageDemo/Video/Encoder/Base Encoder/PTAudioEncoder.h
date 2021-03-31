//
//  PTAudioEncoder.h
//  GPUImageDemo
//
//  Created by Fei Yuan on 2021/3/31.
//

#import "PTEncoder.h"
#import "PTAudioConfig.h"

NS_ASSUME_NONNULL_BEGIN
///音频编码
@interface PTAudioEncoder : PTEncoder

@property (nonatomic, copy) PTAudioConfig *audioConfig;

//编码
-(aw_flv_audio_tag *) encodePCMDataToFlvTag:(NSData *)pcmData;

-(aw_flv_audio_tag *) encodeAudioSampleBufToFlvTag:(CMSampleBufferRef)audioSample;

//创建 audio specific config
-(aw_flv_audio_tag *) createAudioSpecificConfigFlvTag;

//转换
-(NSData *) convertAudioSmapleBufferToPcmData:(CMSampleBufferRef) audioSample;


@end

NS_ASSUME_NONNULL_END
