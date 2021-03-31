//
//  PTVideoEncoder.h
//  GPUImageDemo
//
//  Created by Fei Yuan on 2021/3/31.
//

#import "PTEncoder.h"
#import "PTVideoConfig.h"

NS_ASSUME_NONNULL_BEGIN

///视频编码类
@interface PTVideoEncoder : PTEncoder
@property (nonatomic, copy) PTVideoConfig *videoConfig;

//旋转
-(NSData *)rotateNV12Data:(NSData *)nv12Data;

//编码
-(aw_flv_video_tag *) encodeYUVDataToFlvTag:(NSData *)yuvData;

-(aw_flv_video_tag *) encodeVideoSampleBufToFlvTag:(CMSampleBufferRef)videoSample;

//根据flv，h264，aac协议，提供首帧需要发送的tag
//创建sps pps
-(aw_flv_video_tag *) createSpsPpsFlvTag;


//转换
-(NSData *) convertVideoSmapleBufferToYuvData:(CMSampleBufferRef) videoSample;

@end

NS_ASSUME_NONNULL_END
