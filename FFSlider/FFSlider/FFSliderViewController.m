//
//  FFSliderViewController.m
//  FFSlider
//
//  Created by ixiazer on 15/12/22.
//  Copyright © 2015年 ixiazer. All rights reserved.
//

#import "FFSliderViewController.h"
#import "FFSliderSingleViewController.h"
#import "FFSliderModel.h"
#import "UIView+FF.h"

@interface FFSliderViewController () <UIScrollViewDelegate>
// sliderView容器
@property (nonatomic, strong) UIScrollView *sliderScrollView;
@property (nonatomic, strong) NSMutableArray *scrollviewSliderInfoArr;
@property (nonatomic, strong) FFSliderSingleViewController *currentSingleVC;
// 缓存池数据
@property (nonatomic, strong) NSCache *sliderCache;
@property (nonatomic, assign) FFSliderCachePolicy cachePolicy;
@property (nonatomic, strong) NSMutableArray *sliderCachePools;

// sliderView 相关数据
@property (nonatomic, strong) NSArray *sliderInfoArr;

// 回掉block
@property (nonatomic, copy) void(^sliderBlock)(id vcData, NSInteger currentIndex);
@end

@implementation FFSliderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
}

- (void)initData {
    self.cachePolicy = FFSliderCachePolicyNoLimit;
    self.sliderCache = [[NSCache alloc] init];
    self.sliderCachePools = [[NSMutableArray alloc] init];
    self.scrollviewSliderInfoArr = [[NSMutableArray alloc] init];
}

- (void)configSliderView:(NSArray *)sliderInfoArr currentIndex:(NSInteger)currentIndex sliderBlock:(void(^)(id vcData, NSInteger currentIndex))sliderBlock {
    self.sliderBlock = sliderBlock;
    
    [self.sliderScrollView removeFromSuperview];
    self.sliderScrollView = nil;
    
    self.sliderInfoArr = [NSArray arrayWithArray:sliderInfoArr];
    self.currentSingleVC = nil;
    self.currentIndex = currentIndex;
    
    [self initUI];
}

- (void)initUI {
    if (self.sliderInfoArr.count == 0) {
        return;
    } else {
        [self resetScrollViewCon:FFSliderUIInitTypeForNormal];
    }
    
    [self.view addSubview:self.sliderScrollView];
}

- (FFSliderSingleViewController *)getSingleVC:(NSInteger)index {
    FFSliderModel *model = (FFSliderModel *)[self.sliderInfoArr objectAtIndex:index];
    
    FFSliderSingleViewController *singleVC;
    FFSliderSingleViewController *tempVC = [self.sliderCache objectForKey:@(model.sliderIndex)];
    if (tempVC) {
        singleVC = tempVC;
    } else {
        singleVC = [[FFSliderSingleViewController alloc] init];
        [self.sliderCache setObject:singleVC forKey:@(model.sliderIndex)];
    }
    singleVC.index = model.sliderIndex;
    
    if (index == 0) {
        singleVC.view.backgroundColor = [UIColor redColor];
    } else if (index == 1) {
        singleVC.view.backgroundColor = [UIColor orangeColor];
    } else if (index == 2) {
        singleVC.view.backgroundColor = [UIColor yellowColor];
    } else if (index == 3) {
        singleVC.view.backgroundColor = [UIColor greenColor];
    } else if (index == 4) {
        singleVC.view.backgroundColor = [UIColor blueColor];
    } else if (index == 5) {
        singleVC.view.backgroundColor = [UIColor grayColor];
    } else if (index == 6) {
        singleVC.view.backgroundColor = [UIColor darkGrayColor];
    } else if (index == 7) {
        singleVC.view.backgroundColor = [UIColor purpleColor];
    } else if (index == 8) {
        singleVC.view.backgroundColor = [UIColor lightGrayColor];
    } else if (index == 9) {
        singleVC.view.backgroundColor = [UIColor brownColor];
    }
    
    return singleVC;
}

#pragma mark - 绘制UIScrollView 的子视图
- (void)resetScrollViewCon:(FFSliderUIInitType)type {
    [self readyForSliderViewData:type];
}
#pragma mark - 准备绘制UIScrollView 的数据
- (void)readyForSliderViewData:(FFSliderUIInitType)type {
    NSInteger scrollViewCurrentIndex;
    // 先删除废弃的VC
    if (type == FFSliderUIInitTypeForForward) {
        // 移除不显示视图
        FFSliderModel *model = (FFSliderModel *)[self.scrollviewSliderInfoArr lastObject];
        FFSliderSingleViewController *singleVC = (FFSliderSingleViewController *)[self getSingleVC:model.sliderIndex];
        [singleVC.view removeFromSuperview];
        [singleVC removeFromParentViewController];
        
        // 组织新的数据对象
        if (self.currentIndex <= 1) {
            // 前2页
            NSMutableArray *temArr = [NSMutableArray arrayWithArray:[self.scrollviewSliderInfoArr subarrayWithRange:NSMakeRange(0, 3)]];
            self.scrollviewSliderInfoArr = [NSMutableArray arrayWithArray:temArr];
        } else {
            // 其他
            [self.scrollviewSliderInfoArr removeLastObject];
            FFSliderModel *firstModel = (FFSliderModel *)[self.sliderInfoArr objectAtIndex:self.currentIndex-2];
            NSMutableArray *mutTemVC = [[NSMutableArray alloc] init];
            // 新的视图对象第一位
            [mutTemVC addObject:firstModel];
            // 原视图对象第二、三位
            [mutTemVC addObjectsFromArray:self.scrollviewSliderInfoArr];
            
            self.scrollviewSliderInfoArr = [NSMutableArray arrayWithArray:mutTemVC];
        }
        
        // 当前视图在所有数组中定位
        scrollViewCurrentIndex = 1;
    } else if (type == FFSliderUIInitTypeForBackward) {
        FFSliderModel *model = (FFSliderModel *)[self.scrollviewSliderInfoArr firstObject];
        FFSliderSingleViewController *singleVC = (FFSliderSingleViewController *)[self getSingleVC:model.sliderIndex];
        [singleVC.view removeFromSuperview];
        [singleVC removeFromParentViewController];
        
        // 最后2页
        if (self.currentIndex >= self.sliderInfoArr.count-2) {
            NSMutableArray *temArr = [NSMutableArray arrayWithArray:[self.sliderInfoArr subarrayWithRange:NSMakeRange(self.sliderInfoArr.count-3, 3)]];
            self.scrollviewSliderInfoArr = [NSMutableArray arrayWithArray:temArr];
        } else {
            // 其他
            NSMutableArray *temArr = [NSMutableArray arrayWithArray:[self.scrollviewSliderInfoArr subarrayWithRange:NSMakeRange(1, 2)]];
            NSMutableArray *mutTemVC = [[NSMutableArray alloc] init];
            // 新的视图对象第一、二位
            [mutTemVC addObjectsFromArray:temArr];
            // 原视图对象第三位
            FFSliderModel *lastModel = (FFSliderModel *)[self.sliderInfoArr objectAtIndex:self.currentIndex+2];
            [mutTemVC addObject:lastModel];
            self.scrollviewSliderInfoArr = [NSMutableArray arrayWithArray:mutTemVC];
        }
        
        // 当前视图在所有数组中定位
        scrollViewCurrentIndex = 1;
    } else {
        if (self.sliderInfoArr.count <= 3) {
            self.scrollviewSliderInfoArr = [[NSMutableArray alloc] initWithArray:self.sliderInfoArr];
            scrollViewCurrentIndex = self.currentIndex;
            self.sliderScrollView.contentSize = CGSizeMake(self.view.bounds.size.width*self.sliderInfoArr.count, self.view.bounds.size.height);
        } else {
            self.sliderScrollView.contentSize = CGSizeMake(self.view.bounds.size.width*3, self.view.bounds.size.height);
            if (self.currentIndex <= 1) {
                self.scrollviewSliderInfoArr = [[NSMutableArray alloc] initWithArray:[self.sliderInfoArr subarrayWithRange:NSMakeRange(0, 3)]];
                scrollViewCurrentIndex = self.currentIndex;
            } else if (self.currentIndex >= self.sliderInfoArr.count-2) {
                NSInteger sliderIndex = 3+self.currentIndex-self.sliderInfoArr.count;
                self.scrollviewSliderInfoArr = [[NSMutableArray alloc] initWithArray:[self.sliderInfoArr subarrayWithRange:NSMakeRange(self.sliderInfoArr.count-3, 3)]];
                scrollViewCurrentIndex = sliderIndex;
            } else {
                self.scrollviewSliderInfoArr = [[NSMutableArray alloc] initWithArray:[self.sliderInfoArr subarrayWithRange:NSMakeRange(self.currentIndex-1, 3)]];
                scrollViewCurrentIndex = 1;
            }
        }
    }
    
    [self drawSliderView:scrollViewCurrentIndex];
}

#pragma mark - 绘制UIScrollView 的视图
- (void)drawSliderView:(NSInteger)scrollViewCurrentIndex {
    for (NSInteger i = 0; i < self.scrollviewSliderInfoArr.count; i++) {
        FFSliderModel *model = (FFSliderModel *)self.scrollviewSliderInfoArr[i];
        FFSliderSingleViewController *singleVC = (FFSliderSingleViewController *)[self getSingleVC:model.sliderIndex];
        singleVC.view.frame = CGRectMake(self.view.bounds.size.width*i, 0, self.view.bounds.size.width, self.view.bounds.size.height);
        
        [self.sliderScrollView addSubview:singleVC.view];
        
        //        NSLog(@"singleVC--->>%ld/%ld/%@",self.currentIndex,(long)singleVC.index,singleVC.view);
        
        if (i == scrollViewCurrentIndex) {
            self.currentSingleVC = singleVC;
        }
    }
    
    [self.sliderScrollView setContentOffset:CGPointMake(self.view.bounds.size.width*scrollViewCurrentIndex, 0)];
    
    self.currentIndex = self.currentSingleVC.index;
    
    //    NSLog(@"self.currentIndex--->>%ld",(long)self.currentIndex);
}

#pragma mark - set method
- (void)setCurrentIndex:(NSInteger)currentIndex {
    _currentIndex = currentIndex;
    
    if (self.sliderBlock && self.currentSingleVC) {
        self.sliderBlock(self.currentSingleVC, currentIndex);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    // scrollView 位置
    NSInteger scrollViewIndex = offsetX/self.view.bounds.size.width;
//    NSLog(@"offsetX--->>%ld/%f",(long)scrollViewIndex,offsetX);

    if (self.sliderInfoArr.count <= 3) {
        self.currentIndex = scrollViewIndex;
        [self resetScrollViewCon:FFSliderUIInitTypeForNormal];
    } else {
        if (self.currentIndex == 0 || (self.currentIndex == 1 && scrollViewIndex == 0)) {
            // 前3页
            self.currentIndex = scrollViewIndex;
            [self resetScrollViewCon:FFSliderUIInitTypeForNormal];
        } else if (self.currentIndex == self.sliderInfoArr.count-2 && scrollViewIndex == 2) {
            // 倒数第2页,且朝后翻
            self.currentIndex += 1;
            [self resetScrollViewCon:FFSliderUIInitTypeForNormal];
        } else if (self.currentIndex == self.sliderInfoArr.count-1 && scrollViewIndex == 2) {
            self.currentIndex = self.currentSingleVC.index;
            [self resetScrollViewCon:FFSliderUIInitTypeForNormal];
        } else {
            if (scrollViewIndex == 0) {
                [self resetScrollViewCon:FFSliderUIInitTypeForForward];
            } else if (scrollViewIndex == 2) {
                [self resetScrollViewCon:FFSliderUIInitTypeForBackward];
            } else {
                if (self.currentIndex == self.sliderInfoArr.count - 1 && scrollViewIndex == 1) {
                    self.currentIndex -= 1;
                    [self resetScrollViewCon:FFSliderUIInitTypeForNormal];
                }
            }
        }
    }
}

#pragma mark - get method
- (UIScrollView *)sliderScrollView {
    if (!_sliderScrollView) {
        _sliderScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        _sliderScrollView.backgroundColor = [UIColor clearColor];
        _sliderScrollView.delegate = self;
        _sliderScrollView.pagingEnabled = YES;
        _sliderScrollView.showsHorizontalScrollIndicator = YES;
        _sliderScrollView.contentSize = CGSizeMake(self.view.bounds.size.width*3, self.view.bounds.size.height);
    }
    return _sliderScrollView;
}

@end