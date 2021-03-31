//
//  PTVideoConfig.m
//  GPUImageDemo
//
//  Created by Fei Yuan on 2021/3/31.
//

#import "PTVideoConfig.h"

@interface PTVideoConfig ()
//推流宽高
@property (nonatomic, assign) NSInteger pushStreamWidth;
@property (nonatomic, assign) NSInteger pushStreamHeight;
@end

@implementation PTVideoConfig

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.width = 540;
        self.height = 960;
        self.bitrate = 1000000;
        self.fps = 20;
        self.dataFormat = X264_CSP_NV12;
    }
    return self;
}

-(NSInteger)pushStreamWidth{
    if (self.shouldRotate) {
        return self.height;
    }
    return self.width;
}

-(NSInteger)pushStreamHeight{
    if (self.shouldRotate) {
        return self.width;
    }
    return self.height;
}

-(BOOL)shouldRotate{
    return UIInterfaceOrientationIsLandscape(self.orientation);
}

-(aw_x264_config) x264Config{
    aw_x264_config x264_config;
    x264_config.width = (int32_t)self.pushStreamWidth;
    x264_config.height = (int32_t)self.pushStreamHeight;
    x264_config.bitrate = (int32_t)self.bitrate;
    x264_config.fps = (int32_t)self.fps;
    x264_config.input_data_format = (int32_t)self.dataFormat;
    return x264_config;
}

@end
