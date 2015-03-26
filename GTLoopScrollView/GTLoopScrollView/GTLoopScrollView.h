//
//  GTLoopScrollVie.h
//  ScrollImages
//
//  Created by 赵国腾 on 15/3/25.
//  Copyright (c) 2015年 zhaoguoteng. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol GTLoopScrollViewDelegate;

@interface GTLoopScrollView : UIView

@property (nonatomic, assign) id<GTLoopScrollViewDelegate> delegate;
@property (nonatomic, assign) CGFloat timeInterval;                              // 设置定时器间隔

@end

@protocol GTLoopScrollViewDelegate <NSObject>

@required
// 加载数据源
- (NSArray *)imageUrlsInGTLoopScrollView:(GTLoopScrollView *)loopScrollView;

@optional
// 点击cell的索引
- (void)loopScrollView:(GTLoopScrollView *)loopScrollView didSelectRowAtIndex:(NSInteger)index;

// 如果是图片的网络地址加载，需要实现下面的协议方法
- (void)loopScrollView:(GTLoopScrollView *)loopScrollView imageViewInCell:(UIImageView *)imageView atIndex:(NSInteger)index;

@end