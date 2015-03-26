//
//  ViewController.m
//  GTLoopScrollView
//
//  Created by 赵国腾 on 15/3/26.
//  Copyright (c) 2015年 zhaoguoteng. All rights reserved.
//

#import "ViewController.h"
#import "GTLoopScrollView.h"

@interface ViewController () <GTLoopScrollViewDelegate>

@property (nonatomic, weak) IBOutlet GTLoopScrollView *loopScrollView;
@property (nonatomic, strong) NSArray *imageList;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.loopScrollView.delegate = self;
    self.loopScrollView.timeInterval = 3.0;
    
    self.imageList = @[@"img1", @"img2", @"img3", @"img4"];
}

#pragma mark - GTLoopScrollViewDelegate

// 加载数据源
- (NSArray *)imageUrlsInGTLoopScrollView:(GTLoopScrollView *)loopScrollView {
    
    return self.imageList;
}

@end
