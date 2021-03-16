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

@end

NS_ASSUME_NONNULL_END
