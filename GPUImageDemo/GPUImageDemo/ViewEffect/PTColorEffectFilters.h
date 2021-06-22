//
//  PTColorEffectFilters.h
//  GPUImageDemo
//
//  Created by Fei Yuan on 2021/6/22.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


/// 颜色增强
@interface PTColorEffectFilters : NSObject


/// 亮度
/// @param image <#image description#>
/// @param brightness Brightness ranges from -1.0 to 1.0, with 0.0 as the normal level
/// @param isAuto <#isAuto description#>
+ (UIImage *)brightnessFilter:(UIImage *)image value1:(CGFloat)brightness isAuto:(BOOL)isAuto;


/// 曝光
/// @param image <#image description#>
/// @param exposure Exposure ranges from -10.0 to 10.0, with 0.0 as the normal level
/// @param isAuto <#isAuto description#>
+ (UIImage *)exposureFilter:(UIImage *)image value1:(CGFloat)exposure  isAuto:(BOOL)isAuto;


/// 对比度
/// @param image <#image description#>
/// @param contrast Contrast ranges from 0.0 to 4.0 (max contrast), with 1.0 as the normal level
/// @param isAuto <#isAuto description#>
+ (UIImage *)contrastFilter:(UIImage *)image value1:(CGFloat)contrast  isAuto:(BOOL)isAuto;


/// 饱和度
/// @param image <#image description#>
/// @param saturation Saturation ranges from 0.0 (fully desaturated) to 2.0 (max saturation), with 1.0 as the normal level
/// @param isAuto <#isAuto description#>
+ (UIImage *)saturationFilter:(UIImage *)image value1:(CGFloat)saturation  isAuto:(BOOL)isAuto;


/// 伽马线
/// @param image <#image description#>
/// @param gamma Gamma ranges from 0.0 to 3.0, with 1.0 as the normal level
/// @param isAuto <#isAuto description#>
+ (UIImage *)gammaFilter:(UIImage *)image value1:(CGFloat)gamma  isAuto:(BOOL)isAuto;


/// 怀旧
/// @param image <#image description#>
/// @param intensity default 1.0
/// @param isAuto <#isAuto description#>
+ (UIImage *)sepiaFilter:(UIImage *)image value1:(CGFloat)intensity  isAuto:(BOOL)isAuto;



/// 灰度
/// @param image <#image description#>
+ (UIImage *)grayscaleFilter:(UIImage *)image;



/// RGB
/// @param image <#image description#>
/// @param red Normalized values by which each color channel is multiplied. The range is from 0.0 up, with 1.0 as the default.
/// @param green Normalized values by which each color channel is multiplied. The range is from 0.0 up, with 1.0 as the default.
/// @param blue Normalized values by which each color channel is multiplied. The range is from 0.0 up, with 1.0 as the default.
/// @param isAuto <#isAuto description#>
+ (UIImage *)rgbFilter:(UIImage *)image value1:(CGFloat)red value2:(CGFloat)green value3:(CGFloat)blue isAuto:(BOOL)isAuto;


/// 不透明度
/// @param image <#image description#>
/// @param opacity Opacity ranges from 0.0 to 1.0, with 1.0 as the normal setting
/// @param isAuto <#isAuto description#>
+ (UIImage *)opacityFilter:(UIImage *)image value1:(CGFloat)opacity isAuto:(BOOL)isAuto;


/// 提亮阴影
/// @param image <#image description#>
/// @param shadows  0 - 1, increase to lighten shadows.
/// @param highlights 0 - 1, decrease to darken highlights.
/// @param isAuto <#isAuto description#>
+ (UIImage *)highlightShadowFilter:(UIImage *)image value1:(CGFloat)shadows value2:(CGFloat)highlights isAuto:(BOOL)isAuto;


/// 白平横
/// @param image <#image description#>
/// @param temperature 0~5000,default 5000
/// @param tint 0~100,default 100
/// @param isAuto <#isAuto description#>
+ (UIImage *)whiteBalanceFilter:(UIImage *)image value1:(CGFloat)temperature value2:(CGFloat)tint isAuto:(BOOL)isAuto;


/// 优雅
/// @param image <#image description#>
+ (UIImage *)amatorkaFilter:(UIImage *)image;


/// HDR
/// @param image <#image description#>
+ (UIImage *)missEtikateFilter:(UIImage *)image;


/// 流年
/// @param image <#image description#>
+ (UIImage *)softEleganceFilter:(UIImage *)image;


/// 人物
/// @param image <#image description#>
+ (UIImage *)nashvilleFilter:(UIImage *)image;


@end

NS_ASSUME_NONNULL_END
