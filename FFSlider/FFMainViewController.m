//
//  ViewController.m
//  FFSlider
//
//  Created by ixiazer on 15/12/22.
//  Copyright © 2015年 ixiazer. All rights reserved.
//

#import "FFMainViewController.h"
#import "FFSliderModel.h"
#import "FFSliderViewController.h"
#import "FFSliderSingleViewController.h"

@interface FFMainViewController ()
@property (nonatomic, strong) NSMutableArray *sliderInfoArr;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) FFSliderViewController *sliderVC;

@end

@implementation FFMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"FFSlider";
    
    self.view.backgroundColor = [UIColor whiteColor];

    self.automaticallyAdjustsScrollViewInsets = NO;
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self initData];
    [self initUI];
}

- (void)initData {
    self.sliderInfoArr = [NSMutableArray new];
    for (NSInteger i = 0; i < 20; i++) {
        FFSliderModel *model = [[FFSliderModel alloc] init];
        model.sliderTitle = [NSString stringWithFormat:@"title+%ld",(long)i];
        model.sliderIndex = i;
        
        [self.sliderInfoArr addObject:model];
    }
}

- (void)initUI {
    UIScrollView *secondScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    secondScrollView.backgroundColor = [UIColor whiteColor];
    secondScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:secondScrollView];

    CGFloat width = 0.0;
    for (NSInteger i = 0; i < self.sliderInfoArr.count; i++) {
        FFSliderModel *model = (FFSliderModel *)[self.sliderInfoArr objectAtIndex:i];

        NSString *menuTitle = model.sliderTitle;
        CGSize size = [self getTextSizeWithFont:[UIFont systemFontOfSize:13] width:200 text:menuTitle];
        
        UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        menuBtn.frame = CGRectMake(width, 0, size.width+20, 44);
        [menuBtn setTitle:menuTitle forState:UIControlStateNormal];
        menuBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [menuBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        menuBtn.tag = i;
        [menuBtn addTarget:self action:@selector(menuClick:) forControlEvents:UIControlEventTouchUpInside];
    
        width += size.width+20;
    
        [secondScrollView addSubview:menuBtn];
    }
    
    [secondScrollView setContentSize:CGSizeMake(width, 44)];

    self.sliderVC = [[FFSliderViewController alloc] init];
    self.sliderVC.view.frame = CGRectMake(0, 44, self.view.bounds.size.width, self.view.bounds.size.height-44);
    [self addChildViewController:self.sliderVC];
    [self.view addSubview:self.sliderVC.view];
    
    __weak typeof(self) this = self;
    [self.sliderVC configSliderView:self.sliderInfoArr currentIndex:0 vcClassName:@"FFSliderSingleViewController" sliderBlock:^(id vcData, NSInteger currentIndex) {
        [this sliderHandle:vcData cvClassName:@"FFSliderSingleViewController" currentIndex:currentIndex];
    }];
}

- (void)menuClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    NSInteger tag = btn.tag;
    
    __weak typeof(self) this = self;
    [self.sliderVC configSliderView:self.sliderInfoArr currentIndex:tag vcClassName:@"FFSliderSingleViewController" sliderBlock:^(id vcData, NSInteger currentIndex) {
        [this sliderHandle:vcData cvClassName:@"FFSliderSingleViewController" currentIndex:currentIndex];
    }];
}

- (void)sliderHandle:(id)vcData cvClassName:(NSString *)cvClassName currentIndex:(NSInteger)currentIndex {
    if ([cvClassName isEqualToString:@"FFSliderSingleViewController"]) {
        FFSliderSingleViewController *singleVC = (FFSliderSingleViewController *)vcData;
        
        singleVC.index = currentIndex;

        if (singleVC.index == 0) {
            singleVC.view.backgroundColor = [UIColor redColor];
        } else if (singleVC.index == 1) {
            singleVC.view.backgroundColor = [UIColor orangeColor];
        } else if (singleVC.index == 2) {
            singleVC.view.backgroundColor = [UIColor yellowColor];
        } else if (singleVC.index == 3) {
            singleVC.view.backgroundColor = [UIColor greenColor];
        } else if (singleVC.index == 4) {
            singleVC.view.backgroundColor = [UIColor blueColor];
        } else if (singleVC.index == 5) {
            singleVC.view.backgroundColor = [UIColor grayColor];
        } else if (singleVC.index == 6) {
            singleVC.view.backgroundColor = [UIColor darkGrayColor];
        } else if (singleVC.index == 7) {
            singleVC.view.backgroundColor = [UIColor purpleColor];
        } else if (singleVC.index == 8) {
            singleVC.view.backgroundColor = [UIColor lightGrayColor];
        } else if (singleVC.index == 9) {
            singleVC.view.backgroundColor = [UIColor brownColor];
        }
        
    }
    NSLog(@"currentVCInfo---->>%@/%ld",vcData,(long)currentIndex);
}

- (CGSize)getTextSizeWithFont:(UIFont*)font width:(float)width text:(NSString *)text {
    //动态计算文字大小
    NSDictionary *oldDict = @{NSFontAttributeName:font};
    CGSize oldPriceSize = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:oldDict context:nil].size;
    return oldPriceSize;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
