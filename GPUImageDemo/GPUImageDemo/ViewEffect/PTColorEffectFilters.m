//
//  PTColorEffectFilters.m
//  GPUImageDemo
//
//  Created by Fei Yuan on 2021/6/22.
//

#import "PTColorEffectFilters.h"
#import <GPUImage/GPUImage.h>
#import "PTNashvilleFilter.h"


@implementation PTColorEffectFilters

+ (UIImage *)brightnessFilter:(UIImage *)image value1:(CGFloat)brightness isAuto:(BOOL)isAuto {
    GPUImageBrightnessFilter * filter = [GPUImageBrightnessFilter new];
    if (!isAuto) {
        filter.brightness = brightness;
    }
    [filter forceProcessingAtSize:image.size];
    [filter useNextFrameForImageCapture];

    GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
    [stillImageSource addTarget:filter];
    [stillImageSource processImage];
    return [filter imageFromCurrentFramebuffer];
}

+ (UIImage *)exposureFilter:(UIImage *)image value1:(CGFloat)exposure  isAuto:(BOOL)isAuto {
    GPUImageExposureFilter * filter = [GPUImageExposureFilter new];
    if (!isAuto) {
        filter.exposure = exposure;
    }
    [filter forceProcessingAtSize:image.size];
    [filter useNextFrameForImageCapture];

    GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
    [stillImageSource addTarget:filter];
    [stillImageSource processImage];
    return [filter imageFromCurrentFramebuffer];
}

+ (UIImage *)contrastFilter:(UIImage *)image value1:(CGFloat)contrast  isAuto:(BOOL)isAuto {
    GPUImageContrastFilter * filter = [GPUImageContrastFilter new];
    if (!isAuto) {
        filter.contrast = contrast;
    }
    [filter forceProcessingAtSize:image.size];
    [filter useNextFrameForImageCapture];

    GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
    [stillImageSource addTarget:filter];
    [stillImageSource processImage];
    return [filter imageFromCurrentFramebuffer];
}

+ (UIImage *)saturationFilter:(UIImage *)image value1:(CGFloat)saturation  isAuto:(BOOL)isAuto {
    GPUImageSaturationFilter * filter = [GPUImageSaturationFilter new];
    if (!isAuto) {
        filter.saturation = saturation;
    }
    [filter forceProcessingAtSize:image.size];
    [filter useNextFrameForImageCapture];

    GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
    [stillImageSource addTarget:filter];
    [stillImageSource processImage];
    return [filter imageFromCurrentFramebuffer];
}

+ (UIImage *)gammaFilter:(UIImage *)image value1:(CGFloat)gamma  isAuto:(BOOL)isAuto {
    GPUImageGammaFilter * filter = [GPUImageGammaFilter new];
    if (!isAuto) {
        filter.gamma = gamma;
    }
    [filter forceProcessingAtSize:image.size];
    [filter useNextFrameForImageCapture];

    GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
    [stillImageSource addTarget:filter];
    [stillImageSource processImage];
    return [filter imageFromCurrentFramebuffer];
}

+ (UIImage *)sepiaFilter:(UIImage *)image value1:(CGFloat)intensity  isAuto:(BOOL)isAuto {
    GPUImageSepiaFilter * filter = [GPUImageSepiaFilter new];
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

+ (UIImage *)grayscaleFilter:(UIImage *)image {
    GPUImageGrayscaleFilter * filter = [GPUImageGrayscaleFilter new];
    [filter forceProcessingAtSize:image.size];
    [filter useNextFrameForImageCapture];

    GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
    [stillImageSource addTarget:filter];
    [stillImageSource processImage];
    return [filter imageFromCurrentFramebuffer];
}

+ (UIImage *)rgbFilter:(UIImage *)image value1:(CGFloat)red value2:(CGFloat)green value3:(CGFloat)blue isAuto:(BOOL)isAuto {
    GPUImageRGBFilter * filter = [GPUImageRGBFilter new];
    if (!isAuto) {
        filter.red = red;
        filter.green = green;
        filter.blue = blue;
    }
    [filter forceProcessingAtSize:image.size];
    [filter useNextFrameForImageCapture];

    GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
    [stillImageSource addTarget:filter];
    [stillImageSource processImage];
    return [filter imageFromCurrentFramebuffer];
}

+ (UIImage *)opacityFilter:(UIImage *)image value1:(CGFloat)opacity isAuto:(BOOL)isAuto {
    GPUImageOpacityFilter * filter = [GPUImageOpacityFilter new];
    if (!isAuto) {
        filter.opacity = opacity;
    }
    [filter forceProcessingAtSize:image.size];
    [filter useNextFrameForImageCapture];

    GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
    [stillImageSource addTarget:filter];
    [stillImageSource processImage];
    return [filter imageFromCurrentFramebuffer];
}

+ (UIImage *)highlightShadowFilter:(UIImage *)image value1:(CGFloat)shadows value2:(CGFloat)highlights isAuto:(BOOL)isAuto {
    GPUImageHighlightShadowFilter * filter = [GPUImageHighlightShadowFilter new];
    if (!isAuto) {
        filter.shadows = shadows;
        filter.highlights = highlights;
    }

    [filter forceProcessingAtSize:image.size];
    [filter useNextFrameForImageCapture];

    GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
    [stillImageSource addTarget:filter];
    [stillImageSource processImage];
    return [filter imageFromCurrentFramebuffer];
}

+ (UIImage *)whiteBalanceFilter:(UIImage *)image value1:(CGFloat)temperature value2:(CGFloat)tint isAuto:(BOOL)isAuto {
    GPUImageWhiteBalanceFilter * filter = [GPUImageWhiteBalanceFilter new];
    if (!isAuto) {
        filter.temperature = temperature;
        filter.tint = tint;
    }
    [filter forceProcessingAtSize:image.size];
    [filter useNextFrameForImageCapture];

    GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
    [stillImageSource addTarget:filter];
    [stillImageSource processImage];
    return [filter imageFromCurrentFramebuffer];
}

+ (UIImage *)amatorkaFilter:(UIImage *)image {
    GPUImageAmatorkaFilter *filter = [[GPUImageAmatorkaFilter alloc] init];
    [filter forceProcessingAtSize:image.size];
    GPUImagePicture *pic = [[GPUImagePicture alloc] initWithImage:image];
    [pic addTarget:filter];

    [pic processImage];
    [filter useNextFrameForImageCapture];
    return [filter imageFromCurrentFramebuffer];
}

+ (UIImage *)missEtikateFilter:(UIImage *)image {
    GPUImageMissEtikateFilter *filter = [[GPUImageMissEtikateFilter alloc] init];
    [filter forceProcessingAtSize:image.size];
    GPUImagePicture *pic = [[GPUImagePicture alloc] initWithImage:image];
    [pic addTarget:filter];
    
    [pic processImage];
    [filter useNextFrameForImageCapture];
    return [filter imageFromCurrentFramebuffer];
}

+ (UIImage *)softEleganceFilter:(UIImage *)image {
    GPUImageSoftEleganceFilter *filter = [[GPUImageSoftEleganceFilter alloc] init];
    [filter forceProcessingAtSize:CGSizeMake(image.size.width / 2.0, image.size.height / 2.0)];
    GPUImagePicture *pic = [[GPUImagePicture alloc] initWithImage:image];
    [pic addTarget:filter];
    
    [pic processImage];
    [filter useNextFrameForImageCapture];
    return [filter imageFromCurrentFramebuffer];
}

+ (UIImage *)nashvilleFilter:(UIImage *)image {
    PTNashvilleFilter *filter = [[PTNashvilleFilter alloc] init];
    [filter forceProcessingAtSize:image.size];
    GPUImagePicture *pic = [[GPUImagePicture alloc] initWithImage:image];
    [pic addTarget:filter];

    [pic processImage];
    [filter useNextFrameForImageCapture];
    return [filter imageFromCurrentFramebuffer];
}


@end
