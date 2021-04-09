//
//  PTx264Encoder.m
//  GPUImageDemo
//
//  Created by Fei Yuan on 2021/4/9.
//

#import "PTx264Encoder.h"
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

// 使用x264 必须要include的头文件
#include <stdint.h>
#include <inttypes.h>

#include "x264.h"

@interface PTx264Encoder(){
    x264_param_t            *_pX264Param;
    x264_picture_t          *_pPicIn;
    x264_picture_t          *_pPicOut;
        
    x264_nal_t              *_pNals;
    int                      _iNal;
    
    x264_t                  *_pX264Handle;

    
    int _w;//要编码的图像宽度
    int _h;// 要编码的图像高度
}

@end


@implementation PTx264Encoder

- (instancetype)initEncoderWidth:(int)width  height:(int)height {
    if (self = [super init]) {
        _w = width;
        _h = height;
        [self setX264Config];
    }
    return self;
}
- (void)setX264Config {
    _pX264Param = (x264_param_t *)malloc(sizeof(x264_param_t));
    assert(_pX264Param);
    
    /* 配置参数
     * 使用默认参数，在这里因为我的是实时网络传输，所以我使用了zerolatency的选项，使用这个选项之后就不会有delayed_frames，如果你使用的不是这样的话，还需要在编码完成之后得到缓存的编码帧
     * 在使用中，开始总是会有编码延迟，导致我本地编码立即解码回放后也存在巨大的视频延迟，主要是zerolatency该参数。
     * 后来发现设置x264_param_default_preset(&param, "fast" , "zerolatency" );后就能即时编码了
     */
    x264_param_default_preset(_pX264Param, "fast", "zerolatency");
    
    // 设置Profile.使用Baseline profile
    x264_param_apply_profile(_pX264Param, "baseline");
    
    // cpuFlags
    _pX264Param->i_threads = X264_SYNC_LOOKAHEAD_AUTO; // 取空缓冲区继续使用不死锁的保证
    
    // 视频选项
    _pX264Param->i_width   = _w; // 要编码的图像宽度.
    _pX264Param->i_height  = _h; // 要编码的图像高度
    
    // 流参数
    _pX264Param->b_cabac =0;
    _pX264Param->i_bframe = 0;
    _pX264Param->b_interlaced = 0;
    _pX264Param->rc.i_rc_method = X264_RC_ABR; // 码率控制，CQP(恒定质量)，CRF(恒定码率)，ABR(平均码率)
    _pX264Param->i_level_idc = 30; // 编码复杂度
    
    // 图像质量
    _pX264Param->rc.f_rf_constant = 15; // rc.f_rf_constant是实际质量，越大图像越花，越小越清晰
    _pX264Param->rc.f_rf_constant_max = 45; // param.rc.f_rf_constant_max ，图像质量的最大值。
    
    // 速率控制参数
    int m_bitRate = 400000;
    _pX264Param->rc.i_bitrate = m_bitRate / 1000; // 码率(比特率), x264使用的bitrate需要/1000。
    _pX264Param->rc.i_vbv_max_bitrate=(int)((m_bitRate * 1.2) / 1000) ; // 平均码率模式下，最大瞬时码率，默认0(与-B设置相同)
    
    // 使用实时视频传输时，需要实时发送sps,pps数据
    _pX264Param->b_repeat_headers = 1;  // 重复SPS/PPS 放到关键帧前面。该参数设置是让每个I帧都附带sps/pps。
    
    // 帧率
    int m_frameRate = 15;
    _pX264Param->i_fps_num  = m_frameRate; // 帧率分子
    _pX264Param->i_fps_den  = 1; // 帧率分母
    _pX264Param->i_timebase_den = _pX264Param->i_fps_num;
    _pX264Param->i_timebase_num = _pX264Param->i_fps_den;
    
    /* I帧间隔
     * 我是将I帧间隔与帧率挂钩的，以控制I帧始终在指定时间内刷新。
     * 以下是2秒刷新一个I帧
     */
    _pX264Param->b_intra_refresh = 1;
    _pX264Param->b_annexb = 1;
    _pX264Param->i_keyint_max = m_frameRate * 2;
    
    // Log参数，不需要打印编码信息时直接注释掉就行
    _pX264Param->i_log_level  = X264_LOG_DEBUG;
    
    // 编码需要的辅助变量
    _iNal = 0;
    _pNals = NULL;
    
    _pPicIn = (x264_picture_t *)malloc(sizeof(x264_picture_t));
    memset(_pPicIn, 0, sizeof(x264_picture_t));
    x264_picture_alloc(_pPicIn, X264_CSP_I420, _pX264Param->i_width, _pX264Param->i_height);
    _pPicIn->i_type = X264_TYPE_AUTO;
    
    _pPicOut = (x264_picture_t *)malloc(sizeof(x264_picture_t));
    memset(_pPicOut, 0, sizeof(x264_picture_t));
    x264_picture_init(_pPicOut);
    
    /* ---------------------------------------------------------------------- */
        // 打开编码器句柄,通过x264_encoder_parameters得到设置给X264
        // 的参数.通过x264_encoder_reconfig更新X264的参数
    _pX264Handle = x264_encoder_open(_pX264Param);
    assert(_pX264Handle);
}

- (void)encoder:(CMSampleBufferRef)sampleBuffer {
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    
    UInt8 *bufferbasePtr = (UInt8 *)CVPixelBufferGetBaseAddress(imageBuffer);
    UInt8 *bufferPtr = (UInt8 *)CVPixelBufferGetBaseAddressOfPlane(imageBuffer,0);
    UInt8 *bufferPtr1 = (UInt8 *)CVPixelBufferGetBaseAddressOfPlane(imageBuffer,1);
    
    size_t buffeSize = CVPixelBufferGetDataSize(imageBuffer);
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    size_t bytesrow0 = CVPixelBufferGetBytesPerRowOfPlane(imageBuffer,0);
    size_t bytesrow1  = CVPixelBufferGetBytesPerRowOfPlane(imageBuffer,1);
    size_t bytesrow2 = CVPixelBufferGetBytesPerRowOfPlane(imageBuffer,2);
    
    UInt8 *yuv420_data = (UInt8 *)malloc(width * height *3/ 2);//buffer to store YUV with layout YYYYYYYYUUVV
    /* convert NV12 data to YUV420*/
    UInt8 *pY = bufferPtr ;
    UInt8 *pUV = bufferPtr1;
    UInt8 *pU = yuv420_data + width * height;
    UInt8 *pV = pU + width * height / 4;
    
    for(int i = 0; i < height; i++){
        memcpy(yuv420_data + i * width, pY + i * bytesrow0, width);
    }
    
    for(int j = 0;j < height/2; j++){
        for(int i = 0; i < width/2; i++){
            *(pU++) = pUV[i<<1];
            *(pV++) = pUV[(i<<1) + 1];
        }
        pUV += bytesrow1;
    }
    
    _pPicIn->img.i_plane = 3;
    _pPicIn->img.plane[0] = yuv420_data; // yuv420_data <==> pInFrame
    _pPicIn->img.plane[1] = _pPicIn->img.plane[0] + _w * _h;
    _pPicIn->img.plane[2] = _pPicIn->img.plane[1] + (_w * _h / 4);
    _pPicIn->img.i_stride[0] = _w;
    _pPicIn->img.i_stride[1] = _w / 2;
    _pPicIn->img.i_stride[2] = _w / 2;
    
    // 编码
    int frame_size = x264_encoder_encode(_pX264Handle, &_pNals, &_iNal, _pPicIn, _pPicOut);
    
    // 将编码数据写入文件
    if(frame_size > 0) {
        for (int i = 0; i < _iNal; ++i)
        {
//            fwrite(pNals[i].p_payload, 1, pNals[i].i_payload, pFile);
        }
    }
    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
}

- (void)free {
    // 清除图像区域
    x264_picture_clean(_pPicIn);
    // 关闭编码器句柄
    x264_encoder_close(_pX264Handle);
    _pX264Handle = NULL;
    free(_pPicIn);
    _pPicIn = NULL;
    free(_pPicOut);
    _pPicOut = NULL;
    free(_pX264Param);
    _pX264Param = NULL;
//    fclose(pFile);
//    pFile = NULL;
}
@end
