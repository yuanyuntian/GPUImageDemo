//
//  PTHh264Encoder.h
//  GPUImageDemo
//
//  Created by Fei Yuan on 2021/4/8.
//

#import <Foundation/Foundation.h>
#import <VideoToolbox/VideoToolbox.h>

NS_ASSUME_NONNULL_BEGIN


@protocol H264HWEncoderDelegate <NSObject>

@required

- (void)gotH264EncodedData:(NSData *)packet keyFrame:(BOOL)keyFrame timestamp:(CMTime)timestamp error:(NSError*)error;

@end


@interface PTHh264Encoder : NSObject

- (instancetype)initEncoderWidth:(int)width  height:(int)height;

- (void) invalidate;

- (void) encode:(CMSampleBufferRef)sampleBuffer;

@property (weak, nonatomic) id<H264HWEncoderDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
