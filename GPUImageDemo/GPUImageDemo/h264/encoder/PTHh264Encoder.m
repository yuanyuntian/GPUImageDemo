//
//  PTHh264Encoder.m
//  GPUImageDemo
//
//  Created by Fei Yuan on 2021/4/8.
//

#import "PTHh264Encoder.h"
#import "PTH264Packet.h"

@interface PTHh264Encoder()
{
    VTCompressionSessionRef _session;
    int _w;
    int _h;
}
@end

@implementation PTHh264Encoder

- (instancetype)initEncoderWidth:(int)width  height:(int)height {
    if (self = [super init]) {
        _w = width;
        _h = height;
    }
    return self;
}

void didPTCompressH264(void *outputCallbackRefCon, void *sourceFrameRefCon, OSStatus status, VTEncodeInfoFlags infoFlags, CMSampleBufferRef sampleBuffer) {
    if (status != 0) {
        return;
    }
    if (!CMSampleBufferDataIsReady(sampleBuffer)) {
        NSLog(@"didCompressH264 data is not ready ");
        return;
    }
    
    PTHh264Encoder* encoder = (__bridge PTHh264Encoder*)outputCallbackRefCon;
    if (status == noErr) {
        return [encoder didReceiveSampleBuffer:sampleBuffer];
    }
    
    NSLog(@"Error %d : %@", (unsigned int)infoFlags, [NSError errorWithDomain:NSOSStatusErrorDomain code:status userInfo:nil]);
}


- (void)didReceiveSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    if (!sampleBuffer) {
        return;
    }
    CMTime timestamp = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
    PTH264Packet *packet = [[PTH264Packet alloc] initWithCMSampleBuffer:sampleBuffer];
    
    if (self.delegate != nil) {
        [self.delegate gotH264EncodedData:packet.packet keyFrame:packet.keyFrame timestamp:timestamp error:nil];
    }
}


- (void)setVideoToolBox {
    OSStatus status = VTCompressionSessionCreate(kCFAllocatorDefault,
                                                 _w,
                                                 _h,
                                                 kCMVideoCodecType_H264,
                                                 NULL,
                                                 NULL,
                                                 NULL,
                                                 didPTCompressH264,
                                                 (__bridge void *)(self),
                                                 &_session);
    if (status == noErr) {
        int fps = 20;
        
        // 设置码率
        int bt = (int)(_w * _h * 20 * 2 * 0.04f);
        if (_w >= 1920 || _h >= 1920) {
            bt *= 0.3;
        } else if (_w >= 1280 || _h >= 1280) {
            bt *= 0.4;
        } else if (_w >= 720 || _h >= 720) {
            bt *= 0.6;
        }
        
        // 设置编码码率(比特率)，如果不设置，默认将会以很低的码率编码，导致编码出来的视频很模糊
        status  = VTSessionSetProperty(_session,
                                       kVTCompressionPropertyKey_AverageBitRate,
                                       (__bridge CFTypeRef)@(bt)); // bps
        status += VTSessionSetProperty(_session,
                                       kVTCompressionPropertyKey_DataRateLimits,
                                       (__bridge CFArrayRef)@[@(bt * 2 / 8), @1]); // Bps
        NSLog(@"set bitrate return: %d", (int)status);
        
        const int32_t v = fps * 2; // 2-second kfi
        CFNumberRef ref = CFNumberCreate(NULL, kCFNumberSInt32Type, &v);
        VTSessionSetProperty(_session,
                             kVTCompressionPropertyKey_MaxKeyFrameInterval,
                             ref);
        CFRelease(ref);
        
        ref = CFNumberCreate(NULL, kCFNumberSInt32Type, &fps);
        VTSessionSetProperty(_session,
                             kVTCompressionPropertyKey_ExpectedFrameRate,
                             ref);
        CFRelease(ref);
        VTSessionSetProperty(_session,
                             kVTCompressionPropertyKey_RealTime,
                             kCFBooleanTrue);
        VTSessionSetProperty(_session,
                             kVTCompressionPropertyKey_ProfileLevel,
                             kVTProfileLevel_H264_Baseline_AutoLevel);
        // 开始编码
        status = VTCompressionSessionPrepareToEncodeFrames(_session);
        NSLog(@"start encode  return: %d", (int)status);
    }
}

- (void)encode:(CMSampleBufferRef)sampleBuffer {
    if (_session == NULL) {
        [self setVideoToolBox];
    }
    CVImageBufferRef imageBuffer  = CMSampleBufferGetImageBuffer(sampleBuffer);
    CMTime presentationTime       = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
    
    OSStatus status = VTCompressionSessionEncodeFrame(_session, imageBuffer, presentationTime, kCMTimeInvalid, NULL, NULL, NULL);
    if (status != noErr) {
        VTCompressionSessionInvalidate(_session);
        VTCompressionSessionCompleteFrames(_session, kCMTimeInvalid);
        CFRelease(_session);
        _session = NULL;
        NSLog(@"AppHWH264Encoder, encoder failed");
        return;
    }
}

- (void) invalidate {
    if(_session) {
        VTCompressionSessionCompleteFrames(_session, kCMTimeInvalid);
        VTCompressionSessionInvalidate(_session);
        CFRelease(_session);
        _session = NULL;
    }
}

-(void)dealloc {
    [self invalidate];
}




@end
