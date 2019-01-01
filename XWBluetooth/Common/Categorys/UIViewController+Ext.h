//
//  UIViewController+Ext.h
//  WKDemo
//
//  Created by cgw on 2018/11/12.
//  Copyright © 2018 cgw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+LayoutMethods.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Ext)
- (void)configSelfData;
- (void)configWhiteNaviSelfData;

/**
 因此导航栏返回按钮
 */
- (void)hideBackBar;

/**
 *  替换掉系统的返回按钮
 */
-(void)changeBackBarItem;
-(void)changeBackBarItemWithAction:(SEL)action;


/**
 *  添加导航栏左侧按钮
 */
-(void)addLeftBarItem;
-(void)addLeftBarItemWithAction:(SEL)action;
-(void)addLeftBarItemWithAction:(SEL)action imgName:(NSString*)imgName;
- (void)addLeftBarItemWithTitle:(NSString *)title action:(SEL)action;


/**
 *  添加右侧导航栏按钮
 *
 *  @param title 按钮标题
 *  @return 得到返回的右侧按钮实例
 */

-(UIButton*)addRightBarItemWithTitle:(NSString*)title
                              action:(SEL)action;

-(void)addRightBarItemWithTitle:(NSString*)title
                         action:(SEL)action
                      titleFont:(UIFont*)font;
-(void)addRightBarItemWithAction:(SEL)action
                         imgName:(NSString*)imgName;
-(void)addRightBarItemWithTitle:(NSString *)title
                        imgName:(NSString*)imgName
                     selImgName:(NSString*)selImgName
                         action:(SEL)action
                     titleColor:(UIColor*)color
                      titleFont:(UIFont*)font;
-(void)addRightBarItemWithTitle:(NSString *)title
                        imgName:(NSString*)imgName
                     selImgName:(NSString*)selImgName
                         action:(SEL)action
                  textAlignment:(NSTextAlignment)textAlignment;

- (UIButton*)getButtonAtRightBarItem;

#pragma mark - NavigationBar
/**
 设置导航栏透明
 */
- (void)setNavigationBarBgClear;


/**
 配置导航栏背景，仅仅为了将 背景视图的初始化写在Ctrl的类别中。
 
 */
- (UIView*)getNaviBgView;

/**
 设置导航栏文本的颜色
 
 @param color 文本颜色
 */
- (void)setNaviBarTextColor:(UIColor*)color;

- (void)setStatusBarStyleIsDefault;
- (void)setStatusBarStyleIsLight;
@end


@interface UIViewController (ViewTag)

extern NSInteger const TagNaviBgView;

@end

NS_ASSUME_NONNULL_END
