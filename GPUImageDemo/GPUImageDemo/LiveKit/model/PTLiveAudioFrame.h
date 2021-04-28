//
//  PTLiveAudioFrame.h
//  GPUImageDemo
//
//  Created by Fei Yuan on 2021/4/28.
//

#import "PTLiveFrame.h"

NS_ASSUME_NONNULL_BEGIN

@interface PTLiveAudioFrame : PTLiveFrame

/// flv打包中aac的header
@property (nonatomic, strong) NSData *audioInfo;


@end

NS_ASSUME_NONNULL_END
