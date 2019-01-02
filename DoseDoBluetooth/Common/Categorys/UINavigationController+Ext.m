//
//  UINavigationController+Ext.m
//  HiTravelService
//
//  Created by hitomedia on 2017/4/14.
//  Copyright © 2017年 hitumedia. All rights reserved.
//

#import "UINavigationController+Ext.h"
#import "UIColor+Ext.h"

@implementation UINavigationController (Ext)
- (void)configNavigationCtrl{
    // Do any additional setup after loading the view.
    [self setNeedsStatusBarAppearanceUpdate];
    
    //取出Appearance对象
    UINavigationBar *navBar = [UINavigationBar appearance];
    
    //需要在plist中，将 View controller-based status bar appearance 设置为NO，以下代码才起作用
    //设置状态栏为白色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    [navBar setBarStyle:UIBarStyleDefault];
    //设置返回按钮为黑色
    navBar.tintColor = navBar.barTintColor = [UIColor blackColor];
    
    //设置barButtonItem的主题
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    //不显示返回按钮的标题
    [item setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, 0) forBarMetrics:UIBarMetricsDefault];
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStyleDone target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backBtn];
    item.tintColor = [UIColor blackColor];

    //设置标题的文字字号颜色
    NSDictionary *attr =
    @{NSForegroundColorAttributeName:[UIColor blackColor],
      NSFontAttributeName:[UIFont fontWithName:@"STHeitiSC-Light"//@"STHeitiSC-Light"Medium
                                          size:18.0]};
    [navBar setTitleTextAttributes:attr];
}

/**
 设置NaviBar 透明
 */
- (void)setNavigationBarBgClear{
    
    self.navigationBar.translucent = YES;
    [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.shadowImage = [UIImage new];
}

#pragma mark - reload 

- (UIViewController*)childViewControllerForStatusBarStyle{
    return self.visibleViewController;
}

@end
