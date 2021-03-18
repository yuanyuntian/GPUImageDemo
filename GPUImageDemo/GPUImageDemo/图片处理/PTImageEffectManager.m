//
//  PTImageEffectManager.m
//  GPUImageDemo
//
//  Created by yuanf on 2021/3/16.
//

#import "PTImageEffectManager.h"
#import <GPUImage/GPUImage.h>
#import "PTGPUImage3DFilter.h"

static PTImageEffectManager * instance = nil;

@interface PTImageEffectManager()
{
    PTGPUImage3DFilter * _3dFilter;
}
@end

@implementation PTImageEffectManager

+(instancetype)shareInstance {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [PTImageEffectManager new];
    });
    return instance;
}

-(UIImage*)visualEffectImage:(UIImage*)image withType:(NSInteger)type {
    switch (type) {
        case 0:{
            //素描
            GPUImageSketchFilter *filter = [GPUImageSketchFilter new];
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];
            
            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
        break;
        case 1:{
            //阀值素描，形成有噪点的素描
            GPUImageThresholdSketchFilter *filter = [GPUImageThresholdSketchFilter new];

            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];
            
            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
        break;
        case 2:{
            //卡通效果（黑色粗线描边）
            GPUImageToonFilter *filter = [GPUImageToonFilter new];
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];
            
            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
        break;
        case 3:{
            //平滑
            GPUImageSmoothToonFilter *filter = [GPUImageSmoothToonFilter new];
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];
            
            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
        break;
        case 4:{
            //桑原(Kuwahara)滤波,水粉画
            GPUImageKuwaharaFilter *filter = [GPUImageKuwaharaFilter new];
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];
            
            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
        break;
        case 5:{
            //黑白马赛克
            GPUImageMosaicFilter *filter = [GPUImageMosaicFilter new];
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];
            
            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
        break;
        case 6:{
            //像素化
            GPUImagePixellateFilter *filter = [GPUImagePixellateFilter new];
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];
            
            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
        break;
        case 7:{
            //同心圆像素化
            GPUImagePolarPixellateFilter *filter = [GPUImagePolarPixellateFilter new];
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];
            
            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
        break;
        case 8:{
            //交叉线阴影，形成黑白网状画面
            GPUImageCrosshatchFilter *filter = [GPUImageCrosshatchFilter new];
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];
            
            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
        break;
        case 9:{
            //色彩丢失，模糊（类似监控摄像效果）
            GPUImageColorPackingFilter *filter = [GPUImageColorPackingFilter new];
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];
            
            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
        break;
        case 10:{
            //晕影，形成黑色圆形边缘，突出中间图像的效果
            GPUImageVignetteFilter *filter = [GPUImageVignetteFilter new];
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];
            
            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
        break;
        case 11:{
            //漩涡，中间形成卷曲的画面
            GPUImageSwirlFilter *filter = [GPUImageSwirlFilter new];
//            GPUVector3()
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];
            
            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
        break;
        case 12:{
            //凸起失真，鱼眼效果
            GPUImageBulgeDistortionFilter *filter = [GPUImageBulgeDistortionFilter new];
//            GPUVector3()
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];
            
            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
        break;
        case 13:{
            //收缩失真，凹面镜
            GPUImagePinchDistortionFilter *filter = [GPUImagePinchDistortionFilter new];
//            GPUVector3()
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];
            
            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
        break;
        case 14:{
            //伸展失真，哈哈镜

            GPUImageStretchDistortionFilter *filter = [GPUImageStretchDistortionFilter new];
//            GPUVector3()
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];
            
            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
        break;
        case 15:{
            //水晶球效果
            GPUImageGlassSphereFilter *filter = [GPUImageGlassSphereFilter new];
//            GPUVector3()
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];
            
            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
        break;
        case 16:{
            //球形折射，图形倒立
            GPUImageSphereRefractionFilter *filter = [GPUImageSphereRefractionFilter new];
//            GPUVector3()
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];
            
            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
        break;
        case 17:{
            //色调分离，形成噪点效果
            GPUImagePosterizeFilter *filter = [GPUImagePosterizeFilter new];
//            GPUVector3()
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];
            
            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
        break;
        case 18:{
            //CGA色彩滤镜，形成黑、浅蓝、紫色块的画面
            GPUImageCGAColorspaceFilter *filter = [GPUImageCGAColorspaceFilter new];
//            GPUVector3()
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];
            
            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
        break;
        case 19:{
            //柏林噪点，花边噪点
            GPUImagePerlinNoiseFilter *filter = [GPUImagePerlinNoiseFilter new];
//            GPUVector3()
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];
            
            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
        break;
        case 20:{
            //3x3卷积，高亮大色块变黑，加亮边缘、线条等

            GPUImage3x3ConvolutionFilter *filter = [GPUImage3x3ConvolutionFilter new];
//            GPUVector3()
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];
            
            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
        break;

        case 21:{
            //浮雕效果，带有点3d的感觉
            GPUImageEmbossFilter *filter = [GPUImageEmbossFilter new];
//            GPUVector3()
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];
            
            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
        break;
        case 22:{
            //像素圆点花样
            GPUImagePolkaDotFilter *filter = [GPUImagePolkaDotFilter new];
//            GPUVector3()
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];
            
            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
        break;
        case 23:{
            //点染,图像黑白化，由黑点构成原图的大致图形
            GPUImageHalftoneFilter *filter = [GPUImageHalftoneFilter new];
            
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];
            
            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
        break;
        default:
            break;
    }
    return nil;
}


-(UIImage*)visualProcessImage:(UIImage*)image withType:(NSInteger)type {
    switch (type) {
        case 0:{
            //十字准线
            return image;
//            GPUImageCrosshairGenerator *crosshairGenerator = [GPUImageCrosshairGenerator new];
//            crosshairGenerator.crosshairWidth = 15.0;
//            [crosshairGenerator forceProcessingAtSize:image.size];
//
//            GPUImageHarrisCornerDetectionFilter *edgesDetector = [GPUImageHarrisCornerDetectionFilter new];
//            [edgesDetector setCornersDetectedBlock:^(GLfloat* cornerArray, NSUInteger cornersDetected, CMTime frameTime){
//                    [crosshairGenerator renderCrosshairsFromArray:cornerArray count:cornersDetected frameTime:frameTime];
//                    NSLog(@"corners: %u", cornersDetected);
//            }];
//
//            GPUImageAlphaBlendFilter *blendFilter = [[GPUImageAlphaBlendFilter alloc] init];
//            [blendFilter forceProcessingAtSize:image.size];
//            [crosshairGenerator addTarget:blendFilter];
//
//            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
//            [stillImageSource addTarget:blendFilter];
//
//            [stillImageSource processImage];
//            return [crosshairGenerator imageFromCurrentFramebuffer];
        }
        break;
        case 1:{
            //线条检测
            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            GPUImageHoughTransformLineDetector *lineFilter = [[GPUImageHoughTransformLineDetector alloc] init];
            [stillImageSource addTarget:lineFilter];
            GPUImageLineGenerator *lineDrawFilter = [[GPUImageLineGenerator alloc] init];
            [lineDrawFilter forceProcessingAtSize:image.size];
            [lineFilter setLinesDetectedBlock:^(GLfloat *flt, NSUInteger count, CMTime time) {
                NSLog(@"Number of lines: %ld", (unsigned long)count);
                GPUImageAlphaBlendFilter *blendFilter = [GPUImageAlphaBlendFilter new];
                [blendFilter forceProcessingAtSize:image.size];
                [stillImageSource addTarget:blendFilter];
                [lineDrawFilter addTarget:blendFilter];

                [blendFilter useNextFrameForImageCapture];
                [lineDrawFilter renderLinesFromArray:flt count:count frameTime:time];
            }];
            [stillImageSource processImage];
            return image;
        }
        break;
        case 2:{
            //形状变化
            //Z轴旋转
            GPUImageTransformFilter *filter = [GPUImageTransformFilter new];
            CATransform3D  transform = CATransform3DIdentity;
            transform  = CATransform3DRotate(transform,40, 0.0, 0.0, 1.0);
            filter.transform3D =transform;
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];
            
            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
        break;//GPUImageCropFilter
        case 3:{
            //裁剪
            GPUImageCropFilter *filter = [[GPUImageCropFilter alloc] initWithCropRegion:CGRectMake(0.5, 0.5, 1, 1)];
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];
            
            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
        break;
        case 4:{
            //锐化
            GPUImageSharpenFilter *filter = [GPUImageSharpenFilter new];
            filter.sharpness = 2.0;
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];
            
            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
        break;//
        case 5:{
            //反遮罩锐化
            GPUImageUnsharpMaskFilter *filter = [GPUImageUnsharpMaskFilter new];
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];
            
            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
        break;
        case 6:{
            //模糊
            GPUImageGaussianBlurFilter * filter = [GPUImageGaussianBlurFilter new];
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];

            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
        break;
        case 7:{
            //高斯模糊
            GPUImageGaussianBlurFilter * filter = [GPUImageGaussianBlurFilter new];
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];

            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
        break;
        case 8:{
            //高斯模糊
            GPUImageGaussianSelectiveBlurFilter * filter = [GPUImageGaussianSelectiveBlurFilter new];
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];

            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
        break;
        case 9:{
            //盒状模糊
            GPUImageBoxBlurFilter * filter = [GPUImageBoxBlurFilter new];
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];

            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
        break;
        case 10:{
            //条纹模糊，中间清晰，上下两端模糊
            GPUImageTiltShiftFilter * filter = [GPUImageTiltShiftFilter new];
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];

            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
            break;
        case 11:{
            //中间值，有种稍微模糊边缘的效果
            GPUImageMedianFilter * filter = [GPUImageMedianFilter new];
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];

            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
            break;
        case 12:{
            //双边模糊
            GPUImageBilateralFilter * filter = [GPUImageBilateralFilter new];
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];

            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
            break;
        case 13:{
            //侵蚀边缘模糊，变黑白
            GPUImageErosionFilter * filter = [GPUImageErosionFilter new];
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];

            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
            break;
        case 14:{
            //RGB侵蚀边缘模糊，有色彩
            GPUImageRGBErosionFilter * filter = [GPUImageRGBErosionFilter new];
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];

            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
            break;
        case 15:{
            //扩展边缘模糊，变黑白
            GPUImageDilationFilter * filter = [GPUImageDilationFilter new];
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];

            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
            break;
        case 16:{
            //RGB扩展边缘模糊，有色彩
            GPUImageRGBDilationFilter * filter = [GPUImageRGBDilationFilter new];
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];

            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
            break;
        case 17:{
            //RGB侵蚀边缘模糊，有色彩
            GPUImageRGBErosionFilter * filter = [GPUImageRGBErosionFilter new];
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];

            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
            break;
        case 18:{
            //黑白色调模糊
            GPUImageOpeningFilter * filter = [GPUImageOpeningFilter new];
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];

            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
            break;
        case 19:{
            //彩色模糊
            GPUImageRGBOpeningFilter * filter = [GPUImageRGBOpeningFilter new];
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];

            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
            break;
        case 20:{
            //黑白色调模糊，暗色会被提亮
            GPUImageClosingFilter * filter = [GPUImageClosingFilter new];
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];

            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
            break;
        case 21:{
            //彩色模糊，暗色会被提亮
            GPUImageRGBClosingFilter * filter = [GPUImageRGBClosingFilter new];
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];

            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
            break;
        case 22:{
            //Lanczos重取样，模糊效果
            GPUImageLanczosResamplingFilter * filter = [GPUImageLanczosResamplingFilter new];
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];

            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
            break;
        case 23:{
            //非最大抑制，只显示亮度最高的像素，其他为黑
            GPUImageNonMaximumSuppressionFilter * filter = [GPUImageNonMaximumSuppressionFilter new];
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];

            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
            break;
        case 24:{
            //Sobel边缘检测算法(白边，黑内容，有点漫画的反色效果)
            GPUImageSobelEdgeDetectionFilter * filter = [GPUImageSobelEdgeDetectionFilter new];
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];

            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
            break;
        case 25:{
            //Canny边缘检测算法（比上更强烈的黑白对比度）
            GPUImageCannyEdgeDetectionFilter * filter = [GPUImageCannyEdgeDetectionFilter new];
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];

            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
            break;
        case 26:{
            //阈值边缘检测（效果与上差别不大）
            GPUImageThresholdEdgeDetectionFilter * filter = [GPUImageThresholdEdgeDetectionFilter new];
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];

            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
            break;
        case 27:{
            //普瑞维特(Prewitt)边缘检测(效果与Sobel差不多，貌似更平滑)
            GPUImagePrewittEdgeDetectionFilter * filter = [GPUImagePrewittEdgeDetectionFilter new];
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];

            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
            break;
        case 28:{
            //XYDerivative边缘检测，画面以蓝色为主，绿色为边缘，带彩色
            GPUImageXYDerivativeFilter * filter = [GPUImageXYDerivativeFilter new];
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];

            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
            break;
        case 29:{
            //Harris角点检测，会有绿色小十字显示在图片角点处
            GPUImageHarrisCornerDetectionFilter * filter = [GPUImageHarrisCornerDetectionFilter new];
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];

            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
            break;
        case 30:{
            //Noble角点检测，检测点更多
            GPUImageNobleCornerDetectionFilter * filter = [GPUImageNobleCornerDetectionFilter new];
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];

            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
            break;
        case 31:{
            //ShiTomasi角点检测，与上差别不大
            GPUImageShiTomasiFeatureDetectionFilter * filter = [GPUImageShiTomasiFeatureDetectionFilter new];
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];

            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
            break;
        case 32:{
            //图像黑白化，并有大量噪点
            GPUImageLocalBinaryPatternFilter * filter = [GPUImageLocalBinaryPatternFilter new];
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];

            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
            break;
        case 33:{
            //用于图像加亮
            GPUImageLowPassFilter * filter = [GPUImageLowPassFilter new];
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];

            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
            break;
        case 34:{
            //图像低于某值时显示为黑
            GPUImageHighPassFilter * filter = [GPUImageHighPassFilter new];
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];

            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
            break;
        default:
            break;
    }
    return nil;
}


-(UIImage*)colorProcessImage:(UIImage*)image withType:(NSInteger)type value1:(CGFloat)v1 value2:(CGFloat)v2 value3:(CGFloat)v3 {
    switch (type) {
        case 0:{
            //亮度
            //图像中RGB值的大小，RGB各个值越大，那么亮度越亮，越小，亮度越暗。比如我们要增加亮度，那么直接增加RGB值即可
            GPUImageBrightnessFilter * filter = [GPUImageBrightnessFilter new];
            filter.brightness = v1;
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];

            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
            break;
        case 1:{
            //曝光
            //和亮度很像，获取纹理像素点，每个像素点*2的指数级，就是曝光度
            GPUImageExposureFilter * filter = [GPUImageExposureFilter new];
            filter.exposure = v1;
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];

            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
            break;
        case 2:{
            //对比度
            //简单的讲对比度反应了图片上亮区域和暗区域的层次感。而反应到图像编辑上，调整对比度就是在保证平均亮度不变的情况下，扩大或缩小亮的点和暗的点的差异。既然是要保证平均亮度不变，所以对每个点的调整比例必须作用在该值和平均亮度的差值之上，这样才能够保证计算后的平均亮度不变
            GPUImageContrastFilter * filter = [GPUImageContrastFilter new];
            filter.contrast = v1;
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];

            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
            break;
        case 3:{
            //饱和度
            GPUImageSaturationFilter * filter = [GPUImageSaturationFilter new];
            filter.saturation = v1;
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];

            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
            break;
        case 4:{
            //伽马线
            GPUImageGammaFilter * filter = [GPUImageGammaFilter new];
            filter.gamma = v1;
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];

            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
            break;
        case 5:{
            //反色
            GPUImageColorInvertFilter * filter = [GPUImageColorInvertFilter new];
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];

            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
            break;
        case 6:{
            //怀旧
            GPUImageSepiaFilter * filter = [GPUImageSepiaFilter new];
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];

            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
            break;
        case 7:{
            //色阶
            GPUImageLevelsFilter * filter = [GPUImageLevelsFilter new];
            [filter setRedMin:0 gamma:0.5 max:v1];
            [filter setGreenMin:0 gamma:0.5 max:v2];
            [filter setBlueMin:0 gamma:0.5 max:v3];
            
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];

            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
            break;
        case 8:{
            //灰度
            GPUImageGrayscaleFilter * filter = [GPUImageGrayscaleFilter new];
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];

            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
            break;
        case 9:{
            //色彩直方图，显示在图片上
            GPUImageHistogramFilter * filter = [[GPUImageHistogramFilter alloc] initWithHistogramType:kGPUImageHistogramRed];
            filter.downsamplingFactor = v1;
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];

            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
            break;
        case 10:{
            //色彩直方图
            GPUImageHistogramGenerator * filter = [GPUImageHistogramGenerator new];
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];

            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
            break;
        case 11:{
            //RGB
            GPUImageRGBFilter * filter = [GPUImageRGBFilter new];
            filter.red = v1;
            filter.green = v2;
            filter.blue = v3;
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];

            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
            break;
        case 12:{
            //色调曲线
            GPUImageToneCurveFilter * filter = [GPUImageToneCurveFilter new];
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];

            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
            break;
        case 13:{
            //单色
            GPUImageMonochromeFilter * filter = [GPUImageMonochromeFilter new];
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];

            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
            break;
        case 14:{
            //不透明度
            GPUImageOpacityFilter * filter = [GPUImageOpacityFilter new];
            filter.opacity = v1;
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];

            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
            break;
        case 15:{
            //提亮阴影
            GPUImageHighlightShadowFilter * filter = [GPUImageHighlightShadowFilter new];
            filter.shadows = v1;
            filter.highlights = v2;
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];

            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
            break;
        case 16:{
            //色彩替换（替换亮部和暗部色彩）
            GPUImageFalseColorFilter * filter = [GPUImageFalseColorFilter new];
            [filter setFirstColorRed:v1 green:v2 blue:v3];
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];

            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
            break;
        case 17:{
            //色度
            GPUImageHueFilter * filter = [GPUImageHueFilter new];
            filter.hue = v1;
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];

            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
            break;
        case 18:{
            //色度键
            GPUImageChromaKeyFilter * filter = [GPUImageChromaKeyFilter new];
            [filter setColorToReplaceRed:v1 green:v2 blue:v3];
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];

            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
            break;
        case 19:{
            //白平横
            GPUImageWhiteBalanceFilter * filter = [GPUImageWhiteBalanceFilter new];
            filter.temperature = v1;
            filter.tint = v2;
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];

            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
            break;
        case 20:{
            //像素平均色值
            GPUImageAverageColor * filter = [GPUImageAverageColor new];
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];

            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
            break;
        case 21:{
            //纯色
            GPUImageSolidColorGenerator * filter = [GPUImageSolidColorGenerator new];
            [filter setColorRed:v1 green:v2 blue:v3 alpha:1.0];
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];

            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
            break;
        case 22:{
            //亮度平均
            GPUImageLuminosity * filter = [GPUImageLuminosity new];
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];

            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
            break;
        case 23:{
            //像素色值亮度平均，图像黑白（有类似漫画效果）
            GPUImageAverageLuminanceThresholdFilter * filter = [GPUImageAverageLuminanceThresholdFilter new];
            filter.thresholdMultiplier = v1;
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];

            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
            break;
        case 24:{
            //lookup 色彩调整
            GPUImageLookupFilter * filter = [GPUImageLookupFilter new];
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];

            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
            break;
        case 25:{
            //Amatorka lookup
            GPUImageAmatorkaFilter * filter = [GPUImageAmatorkaFilter new];
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];

            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
            break;
        case 26:{
            //MissEtikate looku
            GPUImageMissEtikateFilter * filter = [GPUImageMissEtikateFilter new];
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];

            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
            break;
        case 27:{
            //SoftElegance looku
            GPUImageSoftEleganceFilter * filter = [GPUImageSoftEleganceFilter new];
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];

            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
            break;
        default:
            break;
    }
    return image;
}

-(UIImage*)Process3DImage:(UIImage*)image withType:(NSInteger)type value1:(CGFloat)v1 value2:(CGFloat)v2 value3:(CGFloat)v3 {
    switch (type) {
        case 0:{
            PTGPUImage3DFilter * filter = [PTGPUImage3DFilter new];
            filter.deviate = v1;
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];

            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
            break;
        default:
            break;
    }
    return image;
}



@end
