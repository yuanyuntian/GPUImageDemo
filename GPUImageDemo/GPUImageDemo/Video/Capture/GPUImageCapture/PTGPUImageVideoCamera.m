//
//  PTGPUImageVideoCamera.m
//  GPUImageDemo
//
//  Created by Fei Yuan on 2021/3/31.
//

#import "PTGPUImageVideoCamera.h"

@implementation PTGPUImageVideoCamera

-(void)processAudioSampleBuffer:(CMSampleBufferRef)sampleBuffer{
    [super processAudioSampleBuffer:sampleBuffer];
    [self.audioDelegate processAudioSample:sampleBuffer];
}

-(void)setCaptureSessionPreset:(NSString *)captureSessionPreset{
    if (!_captureSession || ![_captureSession canSetSessionPreset:captureSessionPreset]) {
        @throw [NSException exceptionWithName:@"Not supported captureSessionPreset" reason:[NSString stringWithFormat:@"captureSessionPreset is [%@]", captureSessionPreset] userInfo:nil];
        return;
    }
    [super setCaptureSessionPreset:captureSessionPreset];
}

@end
