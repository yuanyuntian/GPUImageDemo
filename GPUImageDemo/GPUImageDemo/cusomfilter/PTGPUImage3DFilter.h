//
//  PTGPUImage3DFilter.h
//  GPUImageDemo
//
//  Created by Fei Yuan on 2021/3/18.
//




#import <GPUImage/GPUImage.h>

NS_ASSUME_NONNULL_BEGIN

@interface PTGPUImage3DFilter : GPUImageFilter
{
    GLint pixUniform;
}

// > 0
@property(readwrite, nonatomic) CGFloat deviate;



@end

NS_ASSUME_NONNULL_END
