//
//  FFSliderSingleViewController.m
//  FFSlider
//
//  Created by ixiazer on 15/12/22.
//  Copyright © 2015年 ixiazer. All rights reserved.
//

#import "FFSliderSingleViewController.h"

@interface FFSliderSingleViewController ()
@property (nonatomic, strong) UILabel *lab;
@end

@implementation FFSliderSingleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setIndex:(NSInteger)index {
    _index = index;
    self.lab.text = [NSString stringWithFormat:@"%ld",index];
    [self.view addSubview:self.lab];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - get method
- (UILabel *)lab {
    if (!_lab) {
        _lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width)];
        _lab.font = [UIFont boldSystemFontOfSize:150];
        _lab.textAlignment = NSTextAlignmentCenter;
    }
    return _lab;
}

@end
