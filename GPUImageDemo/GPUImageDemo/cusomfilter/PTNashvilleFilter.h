//
//  PTNashvilleFilter.h
//  GPUImageDemo
//
//  Created by Fei Yuan on 2021/6/22.
//

#import <GPUImage/GPUImage.h>

NS_ASSUME_NONNULL_BEGIN

@interface PTFilter1 : GPUImageTwoInputFilter


@end


@interface PTNashvilleFilter : GPUImageFilterGroup
{
    GPUImagePicture *imageSource ;

}
@end

NS_ASSUME_NONNULL_END
