//
//  PTLiveHardwareVideoEncoder.h
//  GPUImageDemo
//
//  Created by Fei Yuan on 2021/4/28.
//

#import <Foundation/Foundation.h>
#import "PTLiveVideoEncoding.h"

NS_ASSUME_NONNULL_BEGIN

@interface PTLiveHardwareVideoEncoder : NSObject<PTLiveVideoEncoding>

- (nullable instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (nullable instancetype)new UNAVAILABLE_ATTRIBUTE;

@end

NS_ASSUME_NONNULL_END
