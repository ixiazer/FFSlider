//
//  UIView+FF.m
//  FFSlider
//
//  Created by ixiazer on 15/12/23.
//  Copyright © 2015年 ixiazer. All rights reserved.
//

#import "UIView+FF.h"

@implementation UIView (FF)

- (void)removeAllSubViews {
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
}

@end
