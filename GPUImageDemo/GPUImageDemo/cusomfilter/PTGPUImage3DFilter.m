//
//  PTGPUImage3DFilter.m
//  GPUImageDemo
//
//  Created by Fei Yuan on 2021/3/18.
//

#import "PTGPUImage3DFilter.h"


#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
NSString *const kPTGPUImage3DFilterFragmentShaderString = SHADER_STRING
(
 // 纹理坐标 -1 ~1
  varying highp vec2 textureCoordinate;
  // 纹理
  uniform sampler2D inputImageTexture;
  
 //图片像素坐标
  uniform lowp vec2 imagePixel;
 
  uniform lowp float deviate;

  
  void main()
  {
      // 对纹理坐标进行偏移，*deviate代表着偏移五个像素
      lowp vec4 right = texture2D(inputImageTexture, textureCoordinate + imagePixel * deviate);
      lowp vec4 left = texture2D(inputImageTexture, textureCoordinate - imagePixel * deviate);
      // 最终取left的r跟right的gb组成一个新的像素,这里根据需求变动，获取rgb随机填充像素即可
      gl_FragColor = vec4(left.r,right.g,right.b,1.0);
  }
);
#else
NSString *const kGPUImageInvertFragmentShaderString = SHADER_STRING
(
 varying vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 
 void main()
 {
     vec4 textureColor = texture2D(inputImageTexture, textureCoordinate);
     
     gl_FragColor = vec4((1.0 - textureColor.rgb), textureColor.w);
 }
 );
#endif

@implementation PTGPUImage3DFilter


-(id)init {
    if (self = [super initWithFragmentShaderFromString:kPTGPUImage3DFilterFragmentShaderString]) {
        [self setFloat:5.0 forUniformName:@"deviate"];
    }
    return self;
}

- (void)setupFilterForSize:(CGSize)filterFrameSize
{
    runSynchronouslyOnVideoProcessingQueue(^{
        [GPUImageContext setActiveShaderProgram:filterProgram];
        CGSize imagePixel;
        imagePixel.width = 1.0 / filterFrameSize.width;
        imagePixel.height = 1.0 / filterFrameSize.height;
      // 这里是向着色器传递每个像素格式化成0~1的值
        [self setSize:imagePixel forUniformName:@"imagePixel"];
    });
}

-(void)setDeviate:(CGFloat)deviate {
    if (deviate <= 0) {
        [self setFloat:5.0 forUniformName:@"deviate"];
    }else{
        [self setFloat:deviate forUniformName:@"deviate"];
    }
}

@end
