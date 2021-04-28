//
//  PTLiveHardwareAudioEncoder.h
//  GPUImageDemo
//
//  Created by Fei Yuan on 2021/4/28.
//

#import <Foundation/Foundation.h>
#import "PTLiveAudioEncoding.h"

NS_ASSUME_NONNULL_BEGIN

@interface PTLiveHardwareAudioEncoder : NSObject<PTLiveAudioEncoding>

- (nullable instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (nullable instancetype)new UNAVAILABLE_ATTRIBUTE;

@end

NS_ASSUME_NONNULL_END
