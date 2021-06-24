//
//  PTViewEffectFilters.h
//  GPUImageDemo
//
//  Created by Fei Yuan on 2021/6/22.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

///视觉效果滤镜
@interface PTViewEffectFilters : NSObject

/// 素描
/// @param image <#image description#>
/// @param texelWidth  0~0.01
/// @param texelHeight 0~0.01
/// @param edgeStrength 0~10
+ (UIImage *)sketchFilter:(UIImage *)image value1:(CGFloat)texelWidth value2:(CGFloat)texelHeight value3:(CGFloat)edgeStrength isAuto:(BOOL)isAuto;


/// 阀值素描，形成有噪点的素描
/// @param image <#image description#>
/// @param threshold Any edge above this threshold will be black, and anything below white. Ranges from 0.0 to 1.0, with 0.8 as the default
+ (UIImage *)thresholdSketchFilter:(UIImage *)image value1:(CGFloat)threshold isAuto:(BOOL)isAuto;



/// 卡通效果（黑色粗线描边）
/// @param image <#image description#>
/// @param threshold The threshold at which to apply the edges, default of 0.2
/// @param quantizationLevels The levels of quantization for the posterization of colors within the scene, with a default of 10.0
+ (UIImage *)cartoonFilter:(UIImage *)image value1:(CGFloat)threshold value2:(CGFloat)quantizationLevels isAuto:(BOOL)isAuto;



/// 卡通平滑
/// @param image <#image description#>
/// @param blurRadiusInPixels The radius of the underlying Gaussian blur. The default is 2.0.
/// @param threshold The threshold at which to apply the edges, default of 0.2
/// @param quantizationLevels The levels of quantization for the posterization of colors within the scene, with a default of 10.0
+ (UIImage *)smoothCartoonFilter:(UIImage *)image value1:(CGFloat)blurRadiusInPixels value2:(CGFloat)threshold value3:(CGFloat)quantizationLevels isAuto:(BOOL)isAuto;


/// 桑原(Kuwahara)滤波,水粉画
/// @param image image description
/// @param radius The radius to sample from when creating the brush-stroke effect, with a default of 3. The larger the radius, the slower the filter.
+ (UIImage *)kuwaharaFilter:(UIImage *)image value1:(CGFloat)radius isAuto:(BOOL)isAuto;


/// 漩涡
/// @param image <#image description#>
/// @param radius The radius of the distortion, ranging from 0.0 to 1.0, with a default of 0.5
/// @param angle The amount of distortion to apply, with a minimum of 0.0 and a default of 1.0
+ (UIImage *)swirlFilter:(UIImage *)image value1:(CGFloat)radius value2:(CGFloat)angle isAuto:(BOOL)isAuto;


///鱼眼效果
/// @param image <#image description#>
/// @param radius The radius of the distortion, ranging from 0.0 to 1.0, with a default of 0.25
/// @param scale The amount of distortion to apply, from -1.0 to 1.0, with a default of 0.5
/// @param isAuto <#isAuto description#>
+ (UIImage *)bulgeDistortionFilter:(UIImage *)image value1:(CGFloat)radius value2:(CGFloat)scale isAuto:(BOOL)isAuto;


/// 凹面镜
/// @param image <#image description#>
/// @param radius The radius of the distortion, ranging from 0.0 to 2.0, with a default of 1.0
/// @param scale The amount of distortion to apply, from -2.0 to 2.0, with a default of 0.5
/// @param isAuto <#isAuto description#>
+ (UIImage *)pinchDistortionFilter:(UIImage *)image value1:(CGFloat)radius value2:(CGFloat)scale isAuto:(BOOL)isAuto;


/// 水晶球效果
/// @param image <#image description#>
/// @param radius The radius of the distortion, ranging from 0.0 to 1.0, with a default of 0.25
/// @param refractiveIndex The index of refraction for the sphere, with a default of 0.71
/// @param isAuto <#isAuto description#>
+ (UIImage *)glassSphereFilter:(UIImage *)image value1:(CGFloat)radius value2:(CGFloat)refractiveIndex isAuto:(BOOL)isAuto;


/// 浮雕效果，带有点3d的感觉
/// @param image <#image description#>
/// @param intensity The strength of the embossing, from  0.0 to 4.0, with 1.0 as the normal level
/// @param isAuto <#isAuto description#>
+ (UIImage *)embossFilter:(UIImage *)image value1:(CGFloat)intensity  isAuto:(BOOL)isAuto;


/// 锐化
/// @param image <#image description#>
/// @param sharpness Sharpness ranges from -4.0 to 4.0, with 0.0 as the normal level
/// @param isAuto <#isAuto description#>
+ (UIImage *)sharpenFilter:(UIImage *)image value1:(CGFloat)sharpness  isAuto:(BOOL)isAuto;


/// 双边模糊
/// @param image <#image description#>
/// @param distanceNormalizationFactor <#distanceNormalizationFactor description#>
/// @param isAuto <#isAuto description#>
+ (UIImage *)bilateralFilter:(UIImage *)image value1:(CGFloat)distanceNormalizationFactor  isAuto:(BOOL)isAuto;


/// 漫画的反色效果
/// @param image <#image description#>
/// @param edgeStrength 0~10
/// @param isAuto <#isAuto description#>
+ (UIImage *)sobelEdgeDetectionFilter:(UIImage *)image value1:(CGFloat)edgeStrength  isAuto:(BOOL)isAuto;


/// 边缘检测+颜色自反
/// @param image <#image description#>
/// @param edgeStrength edgeStrength 0~10
/// @param isAuto <#isAuto description#>
+ (UIImage *)sobelEdgeDetectionAndcolorInvertFilter:(UIImage *)image value1:(CGFloat)edgeStrength  isAuto:(BOOL)isAuto;



/// <#Description#>
/// @param image <#image description#>
/// @param blurRadiusInPixels The blur radius of the underlying Gaussian blur. The default is 4.0.
/// @param intensity The strength of the sharpening, from 0.0 on up, with a default of 1.0
/// @param saturation <#saturation description#>
/// @param isAuto <#isAuto description#>
+ (UIImage *)cartoonCustomFilter:(UIImage *)image value1:(CGFloat)blurRadiusInPixels value2:(CGFloat)intensity value3:(CGFloat)saturation  isAuto:(BOOL)isAuto;

@end

NS_ASSUME_NONNULL_END
