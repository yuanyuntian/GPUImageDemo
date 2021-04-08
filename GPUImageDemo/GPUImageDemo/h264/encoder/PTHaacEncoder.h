//
//  PTHaacEncoder.h
//  GPUImageDemo
//
//  Created by Fei Yuan on 2021/4/8.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PTAACEncoderDelegate <NSObject>

@required
- (void)gotAACEncodedData:(NSData *)data timestamp:(CMTime)timestamp error:(NSError*)error;

@end


@interface PTHaacEncoder : NSObject

@property (weak, nonatomic) id<PTAACEncoderDelegate> delegate;

@property (nonatomic) dispatch_queue_t callbackQueue;

- (void) encode:(CMSampleBufferRef)sampleBuffer;

@end

NS_ASSUME_NONNULL_END
