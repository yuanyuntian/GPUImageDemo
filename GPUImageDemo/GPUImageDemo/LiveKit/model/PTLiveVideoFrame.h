//
//  PTLiveVideoFrame.h
//  GPUImageDemo
//
//  Created by Fei Yuan on 2021/4/28.
//

#import "PTLiveFrame.h"

NS_ASSUME_NONNULL_BEGIN

@interface PTLiveVideoFrame : PTLiveFrame

@property (nonatomic, assign) BOOL isKeyFrame;
@property (nonatomic, strong) NSData *sps;
@property (nonatomic, strong) NSData *pps;


@end

NS_ASSUME_NONNULL_END
