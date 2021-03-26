//
//  PTGPUImageSketchFilter.m
//  GPUImageDemo
//
//  Created by Fei Yuan on 2021/3/22.
//

#import "PTGPUImageSketchFilter.h"


#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
NSString *const kPTGPUImageSketchFilterFragmentShaderString = SHADER_STRING
(
 // 纹理坐标 -1 ~1
  varying highp vec2 textureCoordinate;
  // 纹理
  uniform sampler2D inputImageTexture;
  
 //图片像素坐标
  uniform lowp vec2 resolution;
 
  void main()
  {
    lowp vec4 luminance_vector = vec4(0.3, 0.59, 0.11, 0.0);
    lowp vec2 uv = vec2(1.0) - (gl_FragCoord.xy / resolution.xy);
    lowp vec2 n = 1.0/resolution.xy;
    lowp vec4 CC = texture2D(inputImageTexture, uv);
    lowp vec4 RD = texture2D(inputImageTexture, uv + vec2( n.x, -n.y));
    lowp  vec4 RC = texture2D(inputImageTexture, uv + vec2( n.x,  0.0));
    lowp  vec4 RU = texture2D(inputImageTexture, uv + n);
    lowp  vec4 LD = texture2D(inputImageTexture, uv - n);
    lowp  vec4 LC = texture2D(inputImageTexture, uv - vec2( n.x,  0.0));
    lowp  vec4 LU = texture2D(inputImageTexture, uv - vec2( n.x, -n.y));
    lowp  vec4 CD = texture2D(inputImageTexture, uv - vec2( 0.0,  n.y));
    lowp  vec4 CU = texture2D(inputImageTexture, uv + vec2( 0.0,  n.y));

    gl_FragColor = vec4(2.0*abs(length(
        vec2(
            -abs(dot(luminance_vector, RD - LD))
            +4.0*abs(dot(luminance_vector, RC - LC))
            -abs(dot(luminance_vector, RU - LU)),
            -abs(dot(luminance_vector, LD - LU))
            +4.0*abs(dot(luminance_vector, CD - CU))
            -abs(dot(luminance_vector, RD - RU))
        )
    )-0.5));
  }
);
#else
NSString *const kPTGPUImageSketchFilterFragmentShaderString = SHADER_STRING
(
 // 纹理坐标 -1 ~1
  varying highp vec2 textureCoordinate;
  // 纹理
  uniform sampler2D inputImageTexture;
  
 //图片像素坐标
  uniform lowp vec2 resolution;
 
 const lowp vec4 luminance_vector = vec4(0.3, 0.59, 0.11, 0.0);

  void main()
  {
    vec2 uv = vec2(1.0) - (gl_FragCoord.xy / resolution.xy);
    vec2 n = 1.0/resolution.xy;
    vec4 CC = texture2D(inputImageTexture, uv);
    vec4 RD = texture2D(inputImageTexture, uv + vec2( n.x, -n.y));
    vec4 RC = texture2D(inputImageTexture, uv + vec2( n.x,  0.0));
    vec4 RU = texture2D(inputImageTexture, uv + n);
    vec4 LD = texture2D(inputImageTexture, uv - n);
    vec4 LC = texture2D(inputImageTexture, uv - vec2( n.x,  0.0));
    vec4 LU = texture2D(inputImageTexture, uv - vec2( n.x, -n.y));
    vec4 CD = texture2D(inputImageTexture, uv - vec2( 0.0,  n.y));
    vec4 CU = texture2D(inputImageTexture, uv + vec2( 0.0,  n.y));

    gl_FragColor = vec4(2.0*abs(length(
        vec2(
            -abs(dot(luminance_vector, RD - LD))
            +4.0*abs(dot(luminance_vector, RC - LC))
            -abs(dot(luminance_vector, RU - LU)),
            -abs(dot(luminance_vector, LD - LU))
            +4.0*abs(dot(luminance_vector, CD - CU))
            -abs(dot(luminance_vector, RD - RU))
        )
    )-0.5));
  }
);
#endif


@implementation PTGPUImageSketchFilter

-(id)init {
    if (self = [super initWithFragmentShaderFromString:kPTGPUImageSketchFilterFragmentShaderString]) {
//        [self setFloat:5.0 forUniformName:@"deviate"];
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
        [self setSize:imagePixel forUniformName:@"resolution"];
    });
}

@end
