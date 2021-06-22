//
//  PTViewEffectFilters.m
//  GPUImageDemo
//
//  Created by Fei Yuan on 2021/6/22.
//

#import "PTViewEffectFilters.h"
#import <GPUImage/GPUImage.h>

@implementation PTViewEffectFilters

+ (UIImage *)sketchFilter:(UIImage *)image value1:(CGFloat)texelWidth value2:(CGFloat)texelHeight value3:(CGFloat)edgeStrength  isAuto:(BOOL)isAuto{
    GPUImageSketchFilter *filter = [GPUImageSketchFilter new];
    if (!isAuto) {
        filter.texelWidth = texelWidth;
        filter.texelHeight = texelHeight;
        filter.edgeStrength = edgeStrength;
    }

    [filter forceProcessingAtSize:image.size];
    [filter useNextFrameForImageCapture];
    
    GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
    [stillImageSource addTarget:filter];
    
    [stillImageSource processImage];
    return [filter imageFromCurrentFramebuffer];
}

+ (UIImage *)thresholdSketchFilter:(UIImage *)image value1:(CGFloat)threshold isAuto:(BOOL)isAuto{
    
    GPUImageThresholdSketchFilter *filter = [GPUImageThresholdSketchFilter new];
    if (!isAuto) {
        filter.threshold = threshold;
    }
    [filter forceProcessingAtSize:image.size];
    [filter useNextFrameForImageCapture];
    
    GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
    [stillImageSource addTarget:filter];
    
    [stillImageSource processImage];
    return [filter imageFromCurrentFramebuffer];
}

+ (UIImage *)cartoonFilter:(UIImage *)image value1:(CGFloat)threshold value2:(CGFloat)quantizationLevels isAuto:(BOOL)isAuto{
    GPUImageToonFilter *filter = [GPUImageToonFilter new];
    if (!isAuto) {
        filter.threshold = threshold;
        filter.quantizationLevels = quantizationLevels;
    }

    [filter forceProcessingAtSize:image.size];
    [filter useNextFrameForImageCapture];
    
    GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
    [stillImageSource addTarget:filter];
    
    [stillImageSource processImage];
    return [filter imageFromCurrentFramebuffer];
}

+ (UIImage *)smoothCartoonFilter:(UIImage *)image value1:(CGFloat)blurRadiusInPixels value2:(CGFloat)threshold value3:(CGFloat)quantizationLevels isAuto:(BOOL)isAuto{
    
    GPUImageSmoothToonFilter *filter = [GPUImageSmoothToonFilter new];
    if (!isAuto) {
        filter.blurRadiusInPixels = blurRadiusInPixels;
        filter.quantizationLevels = quantizationLevels;
        filter.threshold = threshold;
    }

    [filter forceProcessingAtSize:image.size];
    [filter useNextFrameForImageCapture];
    
    GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
    [stillImageSource addTarget:filter];
    
    [stillImageSource processImage];
    return [filter imageFromCurrentFramebuffer];
}

+ (UIImage *)kuwaharaFilter:(UIImage *)image value1:(CGFloat)radius isAuto:(BOOL)isAuto{
    GPUImageKuwaharaFilter *filter = [GPUImageKuwaharaFilter new];
    if (!isAuto) {
        filter.radius = radius;
    }

    [filter forceProcessingAtSize:image.size];
    [filter useNextFrameForImageCapture];
    
    GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
    [stillImageSource addTarget:filter];
    
    [stillImageSource processImage];
    return [filter imageFromCurrentFramebuffer];
}

+ (UIImage *)swirlFilter:(UIImage *)image value1:(CGFloat)radius value2:(CGFloat)angle isAuto:(BOOL)isAuto {
    GPUImageSwirlFilter *filter = [GPUImageSwirlFilter new];
    if (!isAuto) {
        filter.radius = radius;
        filter.angle = angle;
    }
    [filter forceProcessingAtSize:image.size];
    [filter useNextFrameForImageCapture];
    
    GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
    [stillImageSource addTarget:filter];
    
    [stillImageSource processImage];
    return [filter imageFromCurrentFramebuffer];
}

+ (UIImage *)bulgeDistortionFilter:(UIImage *)image value1:(CGFloat)radius value2:(CGFloat)scale isAuto:(BOOL)isAuto {
    GPUImageBulgeDistortionFilter *filter = [GPUImageBulgeDistortionFilter new];
    if (!isAuto) {
        filter.radius = radius;
        filter.scale = scale;
    }
    [filter forceProcessingAtSize:image.size];
    [filter useNextFrameForImageCapture];
    
    GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
    [stillImageSource addTarget:filter];
    
    [stillImageSource processImage];
    return [filter imageFromCurrentFramebuffer];
}

+ (UIImage *)pinchDistortionFilter:(UIImage *)image value1:(CGFloat)radius value2:(CGFloat)scale isAuto:(BOOL)isAuto {
    GPUImagePinchDistortionFilter *filter = [GPUImagePinchDistortionFilter new];
    if (!isAuto) {
        filter.radius = radius;
        filter.scale = scale;
    }
    [filter forceProcessingAtSize:image.size];
    [filter useNextFrameForImageCapture];
    
    GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
    [stillImageSource addTarget:filter];
    
    [stillImageSource processImage];
    return [filter imageFromCurrentFramebuffer];
}

+ (UIImage *)glassSphereFilter:(UIImage *)image value1:(CGFloat)radius value2:(CGFloat)refractiveIndex isAuto:(BOOL)isAuto {
    GPUImageGlassSphereFilter *filter = [GPUImageGlassSphereFilter new];
    if (!isAuto) {
        filter.radius = radius;
        filter.refractiveIndex = refractiveIndex;
    }
    [filter forceProcessingAtSize:image.size];
    [filter useNextFrameForImageCapture];
    
    GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
    [stillImageSource addTarget:filter];
    
    [stillImageSource processImage];
    return [filter imageFromCurrentFramebuffer];
}

+ (UIImage *)embossFilter:(UIImage *)image value1:(CGFloat)intensity  isAuto:(BOOL)isAuto {
    GPUImageEmbossFilter *filter = [GPUImageEmbossFilter new];
    if (!isAuto) {
        filter.intensity = intensity;
    }
    [filter forceProcessingAtSize:image.size];
    [filter useNextFrameForImageCapture];
    
    GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
    [stillImageSource addTarget:filter];
    
    [stillImageSource processImage];
    return [filter imageFromCurrentFramebuffer];
}

+ (UIImage *)sharpenFilter:(UIImage *)image value1:(CGFloat)sharpness  isAuto:(BOOL)isAuto {
    GPUImageSharpenFilter *filter = [GPUImageSharpenFilter new];
    if (!isAuto) {
        filter.sharpness = sharpness;
    }
    [filter forceProcessingAtSize:image.size];
    [filter useNextFrameForImageCapture];
    
    GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
    [stillImageSource addTarget:filter];
    
    [stillImageSource processImage];
    return [filter imageFromCurrentFramebuffer];
}

+ (UIImage *)bilateralFilter:(UIImage *)image value1:(CGFloat)distanceNormalizationFactor  isAuto:(BOOL)isAuto {
    GPUImageBilateralFilter * filter = [GPUImageBilateralFilter new];
    if (!isAuto) {
        filter.distanceNormalizationFactor = distanceNormalizationFactor;
    }
    [filter forceProcessingAtSize:image.size];
    [filter useNextFrameForImageCapture];

    GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
    [stillImageSource addTarget:filter];
    [stillImageSource processImage];
    return [filter imageFromCurrentFramebuffer];
}

@end
