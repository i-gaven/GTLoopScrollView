//
//  GTCollectionViewCell.m
//  ScrollImages
//
//  Created by 赵国腾 on 15/3/26.
//  Copyright (c) 2015年 zhaoguoteng. All rights reserved.
//

#import "GTCollectionViewCell.h"


@interface GTCollectionViewCell ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation GTCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self p_addSubviews];
    }
    
    return self;
}

- (void)awakeFromNib {
    
    [self p_addSubviews];
}

// 添加子视图
- (void)p_addSubviews {
    
    // 添加显示图片的视图imageView
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    
    self.imageView.tag = 1001;
    [self.contentView addSubview:_imageView];

}

- (void)layoutSubviews {
    
    // 设置imageView的frame
    self.imageView.frame = self.bounds;
    
    // 赋值
    self.imageView.image = [UIImage imageNamed:_imageName];
}

@end
