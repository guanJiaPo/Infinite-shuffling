//
//  FUScrollView.m
//  美女轮播
//
//  Created by iphone18 on 16/5/26.
//  Copyright © 2016年 apple18. All rights reserved.
//

#import "FUScrollView.h"

@implementation FUScrollView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 414, 706)];
        
        _imageView.userInteractionEnabled = YES;
        
        [self addSubview:_imageView];
    }
    
    return self;
}

@end
