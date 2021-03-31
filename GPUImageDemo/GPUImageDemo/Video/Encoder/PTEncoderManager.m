//
//  PTEncoderManager.m
//  GPUImageDemo
//
//  Created by Fei Yuan on 2021/3/31.
//

#import "PTEncoderManager.h"
#import "PTVideoConfig.h"
#import "PTVideoEncoder.h"
#import "PTAudioConfig.h"
#import "PTAudioEncoder.h"

@interface PTEncoderManager ()

//编码器
@property (nonatomic, strong) PTVideoEncoder *videoEncoder;
@property (nonatomic, strong) PTAudioEncoder *audioEncoder;

@end

@implementation PTEncoderManager

-(void) openWithAudioConfig:(PTAudioConfig *) audioConfig videoConfig:(PTVideoConfig *) videoConfig{
//    switch (self.audioEncoderType) {
//        case PTAudioEncoderTypeHWAACLC:
//            self.audioEncoder = [[AWHWAACEncoder alloc] init];
//            break;
//        case AWAudioEncoderTypeSWFAAC:
//            self.audioEncoder = [[AWSWFaacEncoder alloc] init];
//            break;
//        default:
//            NSLog(@"[E] AWEncoderManager.open please assin for audioEncoderType");
//            return;
//    }
//    switch (self.videoEncoderType) {
//        case AWVideoEncoderTypeHWH264:
//            self.videoEncoder = [[AWHWH264Encoder alloc] init];
//            break;
//        case AWVideoEncoderTypeSWX264:
//            self.videoEncoder = [[AWSWX264Encoder alloc] init];
//            break;
//        default:
//            NSLog(@"[E] AWEncoderManager.open please assin for videoEncoderType");
//            return;
//    }
    
    self.audioEncoder.audioConfig = audioConfig;
    self.videoEncoder.videoConfig = videoConfig;
    
    self.audioEncoder.manager = self;
    self.videoEncoder.manager = self;
    
    [self.audioEncoder open];
    [self.videoEncoder open];
}


@end
