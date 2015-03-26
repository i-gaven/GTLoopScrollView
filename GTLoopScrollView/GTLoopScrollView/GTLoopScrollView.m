//
//  GTLoopScrollVie.m
//  ScrollImages
//
//  Created by 赵国腾 on 15/3/25.
//  Copyright (c) 2015年 zhaoguoteng. All rights reserved.
//

#import "GTLoopScrollView.h"
#import "GTCollectionViewCell.h"

static NSString *cellIdentifier = @"imageCell";
static const NSInteger multiple     = 500;                  // 扩大倍数的中间值

typedef NS_OPTIONS(NSUInteger, GTLoopScrollViewPosition) {
    GTLoopScrollViewPositionLeft,   // 向左滑动
    GTLoopScrollViewPositionRight   // 向右滑动
};

@interface GTLoopScrollView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionViewFlowLayout *collectionViewLayout;
@property (nonatomic, strong) UICollectionView  *collectionView;        // 显示图片浏览
@property (nonatomic, strong) UIPageControl     *pageControl;           // 翻页指示器
@property (nonatomic, strong) NSArray           *imageList;             // 图片名字数组
@property (nonatomic, assign) NSInteger         imageCount;             // 图片数量
@property (nonatomic, assign) GTLoopScrollViewPosition  loopScrollViewPosition;  // 滑动方向
@property (nonatomic, assign)            NSInteger         currentIndex;         // 当前索引

@end

@implementation GTLoopScrollView {
    NSTimer           *timer;                 // 定时器
}

- (void)dealloc {
    
    timer = nil;
}

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
    
    // 设置collectionView布局属性
    self.collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionViewLayout.minimumLineSpacing = 0;
    self.collectionViewLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    // 添加collectionView
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:self.collectionViewLayout];
    self.collectionView.pagingEnabled = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.bouncesZoom = NO;
    self.collectionView.delegate    = self;
    self.collectionView.dataSource  = self;
    [self addSubview:_collectionView];
    
    // 添加翻页指示器
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectZero];
    self.pageControl.currentPage = 0;
    self.pageControl.hidesForSinglePage = YES;
    self.pageControl.frame = CGRectZero;
    self.pageControl.backgroundColor = [UIColor clearColor];
    [self addSubview:_pageControl];

}

- (void)setTimeInterval:(CGFloat)timeInterval {
    
    _timeInterval = timeInterval;
    
    // 添加定时器
    [self p_addTimer];
}

// 添加定时器
- (void)p_addTimer {
    
    // 添加定时器
    timer = [NSTimer scheduledTimerWithTimeInterval:_timeInterval
                                                  target:self
                                                selector:@selector(startTimer:)
                                                userInfo:nil
                                                 repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)startTimer:(NSTimer *)timer {
        
        [self rollCellToIndex:self.currentIndex + 1 animated:YES];
        self.loopScrollViewPosition = GTLoopScrollViewPositionLeft;
    
        NSLog(@"timer : %ld", (long)self.currentIndex);
}

- (void)layoutSubviews {
    
    // 设置frame
    self.collectionView.frame = self.bounds;
    self.collectionViewLayout.itemSize = self.frame.size;
    self.pageControl.frame = CGRectMake(CGRectGetWidth(self.frame) * (1 - 0.3), CGRectGetHeight(self.frame) - 30, CGRectGetWidth(self.frame) * 0.3, 30);
    
    // 注册一个重用cell
    [self.collectionView registerClass:[GTCollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];
    
    // 获取数据源
    self.imageList = [self.delegate imageUrlsInGTLoopScrollView:self];
    self.imageCount = self.imageList.count;
    self.pageControl.numberOfPages = self.imageCount;
    
    [self rollCellToIndex:_imageCount * multiple animated:NO];
    self.currentIndex = _imageCount * multiple;
}

// cell滚动到指定位置
- (void)rollCellToIndex:(NSInteger)index animated:(BOOL)animated {
    
    // 把cell滚动到中间
    NSIndexPath *midIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.collectionView selectItemAtIndexPath:midIndexPath animated:animated scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _imageCount * multiple * 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    GTCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    NSString *imgName = self.imageList[indexPath.row % _imageCount];
    
    // 判断是图片名，还是图片的网络地址
    if ([imgName hasPrefix:@"http"]) {
        
        UIImageView *imgView = (UIImageView *)[cell.contentView viewWithTag:1001];
        
        if ([self.delegate respondsToSelector:@selector(loopScrollView:imageViewInCell:atIndex:)]) {
            [self.delegate loopScrollView:self imageViewInCell:imgView atIndex:indexPath.row % _imageCount];
        }
        
    }else {
        
        cell.imageName = imgName;
    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // 当前位置索引
    NSInteger displayingCellIndex = indexPath.row;
    
    if (self.loopScrollViewPosition == GTLoopScrollViewPositionLeft) {
        
        self.currentIndex = displayingCellIndex + 1;
    }else {
     
        self.currentIndex = displayingCellIndex - 1;
    }
    
    self.pageControl.currentPage = self.currentIndex % _imageCount;
    [self.pageControl updateCurrentPageDisplay];
    
    NSLog(@"self.currentIndex %ld", self.currentIndex);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.delegate respondsToSelector:@selector(loopScrollView:didSelectRowAtIndex:)]) {
        [self.delegate loopScrollView:self didSelectRowAtIndex:(indexPath.row % _imageCount)];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    if (velocity.x >= 0) {      // 向左
        
        self.loopScrollViewPosition = GTLoopScrollViewPositionLeft;
    }else {
        
        self.loopScrollViewPosition = GTLoopScrollViewPositionRight;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [timer invalidate];
    timer = nil;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [self p_addTimer];
}

@end
