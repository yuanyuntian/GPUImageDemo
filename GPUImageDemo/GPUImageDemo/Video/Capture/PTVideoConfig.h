//
//  PTVideoConfig.h
//  GPUImageDemo
//
//  Created by Fei Yuan on 2021/3/31.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#include "aw_all.h"

NS_ASSUME_NONNULL_BEGIN

@interface PTVideoConfig : NSObject

@property (nonatomic, assign) NSInteger width;//可选，系统支持的分辨率，采集分辨率的宽
@property (nonatomic, assign) NSInteger height;//可选，系统支持的分辨率，采集分辨率的高
@property (nonatomic, assign) NSInteger bitrate;//自由设置
@property (nonatomic, assign) NSInteger fps;//自由设置
@property (nonatomic, assign) NSInteger dataFormat;//目前软编码只能是X264_CSP_NV12，硬编码无需设置

//推流方向
@property (nonatomic, assign) UIInterfaceOrientation orientation;


// 推流分辨率宽高，目前不支持自由设置，只支持旋转。
// UIInterfaceOrientationLandscapeLeft 和 UIInterfaceOrientationLandscapeRight 为横屏，其他值均为竖屏。
@property (nonatomic, readonly, assign) NSInteger pushStreamWidth;
@property (nonatomic, readonly, assign) NSInteger pushStreamHeight;

@property (nonatomic, readonly, assign) aw_x264_config x264Config;

-(BOOL) shouldRotate;

@end

NS_ASSUME_NONNULL_END
