//
//  PTEncoder.m
//  GPUImageDemo
//
//  Created by Fei Yuan on 2021/3/31.
//

#import "PTEncoder.h"

@implementation PTEncoder

-(void) open{
}

-(void)close{
}

-(void) onErrorWithCode:(PTEncoderErrorCode) code des:(NSString *) des{
    printf("[ERROR] encoder error code:%ld des:%s", (unsigned long)code, des.UTF8String);
}


@end
