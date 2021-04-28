//
//  PTLiveFrame.h
//  GPUImageDemo
//
//  Created by Fei Yuan on 2021/4/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PTLiveFrame : NSObject

@property (nonatomic, assign,) uint64_t timestamp;
@property (nonatomic, strong) NSData *data;
///< flv或者rtmp包头
@property (nonatomic, strong) NSData *header;


@end

NS_ASSUME_NONNULL_END
