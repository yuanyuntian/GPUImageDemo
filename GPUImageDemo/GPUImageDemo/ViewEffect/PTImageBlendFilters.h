//
//  PTImageBlendFilters.h
//  GPUImageDemo
//
//  Created by Fei Yuan on 2021/6/25.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PTImageBlendFilters : NSObject


/** The threshold sensitivity controls how similar pixels need to be colored to be replaced
 
 The default value is 0.3
 */
@property(readwrite, nonatomic) CGFloat thresholdSensitivity;

/** The degree of smoothing controls how gradually similar colors are replaced in the image
 
 The default value is 0.1
 */
@property(readwrite, nonatomic) CGFloat smoothing;


/// 选择性地将第一张图片中的颜色替换为第二张图片
/// @param image <#image description#>
/// @param thresholdSensitivity The threshold sensitivity controls how similar pixels need to be colored to be replaced The default value is 0.3
/// @param smoothing The degree of smoothing controls how gradually similar colors are replaced in the image The default value is 0.1
/// @param isAuto <#isAuto description#>
+ (UIImage *)chromaKeyBlendFilter:(UIImage *)sourceImage backgroundImage:(UIImage *)backgroundImage value1:(CGFloat)thresholdSensitivity value2:(CGFloat)smoothing  isAuto:(BOOL)isAuto;


@end

NS_ASSUME_NONNULL_END
