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

+ (UIImage *)sobelEdgeDetectionFilter:(UIImage *)image value1:(CGFloat)edgeStrength  isAuto:(BOOL)isAuto {
    GPUImageSobelEdgeDetectionFilter * filter = [GPUImageSobelEdgeDetectionFilter new];
    if (!isAuto) {
        filter.edgeStrength = edgeStrength;
    }
    [filter forceProcessingAtSize:image.size];
    [filter useNextFrameForImageCapture];

    GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
    [stillImageSource addTarget:filter];
    [stillImageSource processImage];
    return [filter imageFromCurrentFramebuffer];
    
    //组合滤镜
//    GPUImageSobelEdgeDetectionFilter * filter = [GPUImageSobelEdgeDetectionFilter new];
//    if (!isAuto) {
//        filter.edgeStrength = edgeStrength;
//    }
//    [filter forceProcessingAtSize:image.size];
//
//    GPUImageColorInvertFilter * invertFilter = [GPUImageColorInvertFilter new];
//    [invertFilter forceProcessingAtSize:image.size];
//    GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
//    [stillImageSource addTarget:filter];
//    [filter addTarget:invertFilter];
//    [invertFilter useNextFrameForImageCapture];
//
//    [stillImageSource processImage];
//    return [invertFilter imageFromCurrentFramebuffer];
    
    
//    GPUImageSobelEdgeDetectionFilter * filter = [GPUImageSobelEdgeDetectionFilter new];
//    if (!isAuto) {
//        filter.edgeStrength = edgeStrength;
//    }
//    GPUImageColorInvertFilter * invertFilter = [GPUImageColorInvertFilter new];
//    GPUImageFilterGroup * group = [GPUImageFilterGroup new];
//    [group addFilter:filter];
//    [group addFilter:invertFilter];
//    [filter addTarget:invertFilter];
//    group.initialFilters = @[filter];
//    group.terminalFilter = invertFilter;
//    [group forceProcessingAtSize:image.size];
//
//    GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
//    [stillImageSource addTarget:group];
//    [group useNextFrameForImageCapture];
//    [stillImageSource processImage];
//    return [group imageFromCurrentFramebuffer];
    
}


+ (UIImage *)sobelEdgeDetectionAndcolorInvertFilter:(UIImage *)image value1:(CGFloat)edgeStrength  isAuto:(BOOL)isAuto {
        GPUImageSobelEdgeDetectionFilter * filter = [GPUImageSobelEdgeDetectionFilter new];
        if (!isAuto) {
            filter.edgeStrength = edgeStrength;
        }
        GPUImageColorInvertFilter * invertFilter = [GPUImageColorInvertFilter new];
    
        GPUImageFilterGroup * group = [GPUImageFilterGroup new];
        [group addFilter:filter];
        [group addFilter:invertFilter];
        [filter addTarget:invertFilter];
        group.initialFilters = @[filter];
        group.terminalFilter = invertFilter;
        [group forceProcessingAtSize:image.size];
    
        GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
        [stillImageSource addTarget:group];
        [group useNextFrameForImageCapture];
        [stillImageSource processImage];
        return [group imageFromCurrentFramebuffer];
}




+ (UIImage *)cartoonCustomFilter:(UIImage *)image value1:(CGFloat)blurRadiusInPixels value2:(CGFloat)intensity value3:(CGFloat)saturation  isAuto:(BOOL)isAuto {
    
    GPUImageUnsharpMaskFilter * filter1 = [GPUImageUnsharpMaskFilter new];
    if (!isAuto) {
        filter1.blurRadiusInPixels = blurRadiusInPixels;
        filter1.intensity = intensity;

    }
    
    GPUImageSaturationFilter * filter2 = [GPUImageSaturationFilter new];
    if (!isAuto) {
        filter2.saturation = saturation;
    }

    GPUImageBilateralFilter * filter3 = [GPUImageBilateralFilter new];
    if (!isAuto) {
//        filter3.distanceNormalizationFactor = distanceNormalizationFactor;
    }
    GPUImageFilterGroup * group = [GPUImageFilterGroup new];
    [group addFilter:filter1];
    [group addFilter:filter2];
    [group addFilter:filter3];

    [filter1 addTarget:filter2];
    
    [filter2 addTarget:filter3];

    group.initialFilters = @[filter1];
    group.terminalFilter = filter3;
    [group forceProcessingAtSize:image.size];

    GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
    [stillImageSource addTarget:group];
    [group useNextFrameForImageCapture];
    [stillImageSource processImage];
    return [group imageFromCurrentFramebuffer];
}
    
@end
