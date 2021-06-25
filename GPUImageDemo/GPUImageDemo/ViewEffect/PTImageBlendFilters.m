//
//  PTImageBlendFilters.m
//  GPUImageDemo
//
//  Created by Fei Yuan on 2021/6/25.
//

#import "PTImageBlendFilters.h"
#import <GPUImage/GPUImage.h>


@implementation PTImageBlendFilters


+ (UIImage *)chromaKeyBlendFilter:(UIImage *)sourceImage backgroundImage:(UIImage *)backgroundImage value1:(CGFloat)thresholdSensitivity value2:(CGFloat)smoothing  isAuto:(BOOL)isAuto {
    GPUImageChromaKeyBlendFilter * filter = [GPUImageChromaKeyBlendFilter new];
    if (!isAuto) {
        filter.thresholdSensitivity = thresholdSensitivity;
        filter.smoothing = smoothing;
    }
    GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:sourceImage];
    [stillImageSource addTarget:filter];
    [stillImageSource processImage];
    return [filter imageByFilteringImage:backgroundImage];
}
@end
