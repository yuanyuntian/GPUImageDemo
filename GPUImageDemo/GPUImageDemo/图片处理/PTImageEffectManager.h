//
//  PTImageEffectManager.h
//  GPUImageDemo
//
//  Created by yuanf on 2021/3/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PTImageEffectManager : NSObject

+(instancetype)shareInstance;

/// 视觉特效
/// @param image 原始图片
/// @param type 类型
-(UIImage*)visualEffectImage:(UIImage*)image withType:(NSInteger)type;

-(UIImage*)visualProcessImage:(UIImage*)image withType:(NSInteger)type;


-(UIImage*)colorProcessImage:(UIImage*)image withType:(NSInteger)type value1:(CGFloat)v1 value2:(CGFloat)v2 value3:(CGFloat)v3;


-(UIImage*)Process3DImage:(UIImage*)image withType:(NSInteger)type value1:(CGFloat)v1 value2:(CGFloat)v2 value3:(CGFloat)v3;

@end

NS_ASSUME_NONNULL_END
