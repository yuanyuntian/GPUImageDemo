//
//  PTGPUImageAVCapture.m
//  GPUImageDemo
//
//  Created by Fei Yuan on 2021/3/31.
//

#import "PTGPUImageAVCapture.h"
#import "PTGPUImageVideoCamera.h"
#import "GPUImageBeautifyFilter.h"

@interface PTGPUImageAVCapture ()

@property (nonatomic, strong) PTGPUImageVideoCamera *videoCamera;
@property (nonatomic, strong) GPUImageBeautifyFilter *beautifyFilter;
//@property (nonatomic, strong) AWGPUImageAVCaptureDataHandler *dataHandler;

@end

@implementation PTGPUImageAVCapture

-(instancetype)init {
    if (self = [super init]) {
        //摄像头
        _videoCamera = [[PTGPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionBack];
        //声音
        [_videoCamera addAudioInputsAndOutputs];
        //屏幕方向
        _videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
        //镜像策略
        _videoCamera.horizontallyMirrorRearFacingCamera = NO;
        _videoCamera.horizontallyMirrorFrontFacingCamera = YES;
        
        //预览 view
        _gpuImageView = [[GPUImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        
        //美颜滤镜
        _beautifyFilter = [[GPUImageBeautifyFilter alloc] init];
        [_videoCamera addTarget:_beautifyFilter];
        
        //美颜滤镜
        [_beautifyFilter addTarget:_gpuImageView];
//        [_videoCamera addTarget:_gpuImageView];
        //数据处理
//        _dataHandler = [[AWGPUImageAVCaptureDataHandler alloc] initWithImageSize:CGSizeMake(self.videoConfig.width, self.videoConfig.height) resultsInBGRAFormat:YES capture:self];
//        [_beautifyFilter addTarget:_dataHandler];
//        _videoCamera.awAudioDelegate = _dataHandler;
        
        [self.videoCamera startCameraCapture];
    }
    return self;
}

@end
