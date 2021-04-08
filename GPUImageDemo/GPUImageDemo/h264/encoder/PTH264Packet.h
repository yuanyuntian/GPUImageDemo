//
//  PTH264Packet.h
//  GPUImageDemo
//
//  Created by Fei Yuan on 2021/4/8.
//

#import <Foundation/Foundation.h>
#import <VideoToolbox/VideoToolbox.h>

NS_ASSUME_NONNULL_BEGIN

@interface PTH264Packet : NSObject

@property (strong, nonatomic) NSMutableData *packet;
@property (assign, nonatomic) BOOL keyFrame;

-(instancetype)initWithCMSampleBuffer:(CMSampleBufferRef)sample;

@end

NS_ASSUME_NONNULL_END
