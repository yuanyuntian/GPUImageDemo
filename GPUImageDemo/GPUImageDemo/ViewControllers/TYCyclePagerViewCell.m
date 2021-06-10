//
//  TYCyclePagerViewCell.m
//  TYCyclePagerViewDemo
//
//  Created by tany on 2017/6/14.
//  Copyright © 2017年 tany. All rights reserved.
//

#import "TYCyclePagerViewCell.h"
#import <Masonry/Masonry.h>

@interface TYCyclePagerViewCell ()
@end

@implementation TYCyclePagerViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        self.label  = [UILabel new];
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.textColor = [UIColor blackColor];
        self.label.numberOfLines = 2;
        self.label.font = [UIFont systemFontOfSize:16];
        [self addSubview:self.label];
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.label mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];
}



@end
