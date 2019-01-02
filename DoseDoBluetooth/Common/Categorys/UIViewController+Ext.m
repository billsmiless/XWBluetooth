//
//  UIViewController+Ext.m
//  WKDemo
//
//  Created by cgw on 2018/11/12.
//  Copyright © 2018 cgw. All rights reserved.
//

#import "UIViewController+Ext.h"

@implementation UIViewController (Ext)
- (void)configSelfData{
    self.view.backgroundColor = [UIColor colorWithWhite:1 alpha:0.85];//colorWithRgb_240_239_244];
    [self getNaviBgView];
    [self changeBackBarItem];
}

- (void)configWhiteNaviSelfData{
    self.view.backgroundColor = [UIColor colorWithWhite:1 alpha:0.85];
    [self getNaviBgView];
    [self addLeftBarItemWithAction:@selector(handleBackBtn:) imgName:@"arrow_left_51pp"];
}

#pragma mark - Public

- (void)hideBackBar{
    self.navigationItem.leftBarButtonItems = @[[UIBarButtonItem new]];
}

-(void)changeBackBarItemWithAction:(SEL)action{
    self.navigationItem.leftBarButtonItems = [self leftItemsWithTarget:self
                                                                action:action];
}

-(void)changeBackBarItem{
    [self changeBackBarItemWithAction:@selector(handleBackBtn:)];
}

-(void)addLeftBarItemWithAction:(SEL)action{
    self.navigationItem.leftBarButtonItems = [self leftItemsWithTarget:self
                                                                action:action
                                                               imgName:@"arrow_left_51"];
}

- (void)addLeftBarItemWithAction:(SEL)action imgName:(NSString *)imgName{
    NSArray *btns = [self leftItemsWithTarget:self action:action imgName:imgName];
    self.navigationItem.leftBarButtonItems = btns;
}

-(void)addLeftBarItem{
    [self addLeftBarItemWithAction:@selector(handleLeftBtn:)];
}

- (void)addLeftBarItemWithTitle:(NSString *)title action:(SEL)action{
    UIBarButtonItem *bar =
    [self barItemWithNormalTitle:title normalImage:nil hightImage:nil selectedImg:nil andTarget:self andAction:action titleAlignment:NSTextAlignmentLeft contentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    self.navigationItem.leftBarButtonItem = bar;
}

- (UIButton*)addRightBarItemWithTitle:(NSString *)title
                               action:(SEL)action{
    UIButton *rightBtn = nil;
    self.navigationItem.rightBarButtonItems = [self rightItemsWithTitle:title
                                                                imgName:nil
                                                             selImgName:nil
                                                                 action:action
                                                              titleFont:[UIFont systemFontOfSize:15.0]
                                                             titleColor:nil rightBtn:&rightBtn];
    return rightBtn;
}

-(void)addRightBarItemWithTitle:(NSString *)title
                        imgName:(NSString *)imgName
                     selImgName:(NSString *)selImgName
                         action:(SEL)action
                     titleColor:(UIColor*)color
                      titleFont:(UIFont *)font{
    self.navigationItem.rightBarButtonItems = [self rightItemsWithTitle:title
                                                                imgName:imgName
                                                             selImgName:selImgName
                                                                 action:action
                                                              titleFont:font
                                                             titleColor:color rightBtn:nil];
}

-(void)addRightBarItemWithTitle:(NSString *)title imgName:(NSString *)imgName selImgName:(NSString *)selImgName action:(SEL)action textAlignment:(NSTextAlignment)textAlignment{
    
    UIBarButtonItem *rightBarItem = [self barItemWithNormalTitle:title
                                                     normalImage:imgName
                                                      hightImage:nil
                                                     selectedImg:selImgName
                                                       andTarget:self andAction:action titleAlignment:NSTextAlignmentRight];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                    target:nil
                                                                                    action:nil];
    negativeSpacer.width = -5;
    self.navigationItem.rightBarButtonItems = @[negativeSpacer,rightBarItem];
    
}

- (UIButton *)getButtonAtRightBarItem{
    NSArray *btns =
    self.navigationItem.rightBarButtonItems;
    for( UIBarButtonItem *bi in btns ){
        if( [bi.customView isKindOfClass:[UIButton class]] ){
            //            bi.enabled = NO;
            return (UIButton*)(bi.customView);
        }
    }
    return nil;
}

-(void)addRightBarItemWithTitle:(NSString *)title action:(SEL)action titleFont:(UIFont*)font{
    [self addRightBarItemWithTitle:title
                           imgName:nil selImgName:nil
                            action:action titleColor:nil titleFont:nil];
}

- (void)addRightBarItemWithAction:(SEL)action imgName:(NSString *)imgName{
    [self addRightBarItemWithTitle:nil imgName:imgName selImgName:nil action:action textAlignment:NSTextAlignmentLeft];
}

#pragma mark - NavigationBar

//- (UIView*)addNaviBgViewWithNoHaveBottomLine{
//    HTNaviBgView *navi = (HTNaviBgView*)[self addNaviBgView];
//    if( [navi isKindOfClass:[HTNaviBgView class]] ){
//        navi.bottomLine.hidden = YES;
//    }
//    return navi;
//}

- (UIView*)addNaviBgView {
    UIView *navi = [self.view viewWithTag:TagNaviBgView];
    if( [navi isKindOfClass:[UIView class]] ) return navi;
    
    UIView *bgView = [[UIView alloc] init];
    bgView.tag = TagNaviBgView;
    CGFloat navH = NAVGATION_VIEW_HEIGHT;
    bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, navH);
    bgView.backgroundColor = [UIColor whiteColor];//colorWithRgb_83_179_239];
    [self.view addSubview:bgView];
    
    //阴影
    UIView *view = bgView;
    view.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
    view.layer.shadowOffset = CGSizeMake(0,3);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    view.layer.shadowOpacity = 0.1;//阴影透明度，默认0
    view.layer.shadowRadius = 3;//阴影半径，默认3
    
    //重新设置返回按钮后，左滑返回会失效。所以需要重新设置
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    return bgView;
}

- (UIView*)getNaviBgView {
    
    return [self addNaviBgView];
}

- (void)setNaviBarTextColor:(UIColor*)color{
    self.navigationController.navigationBar.tintColor = color;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:color}];
}

- (void)setStatusBarStyleIsDefault{
    [self setNaviBarTextColor:[UIColor blackColor]];
    
    //设置状态栏为黑色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)setStatusBarStyleIsLight{
    [self setNaviBarTextColor:[UIColor whiteColor]];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)setNavigationBarBgClear{
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
}

#pragma mark - AlertView
- (void)showMsg:(NSString*)msg{
    /*  消息提示  */
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:nil message:msg preferredStyle:UIAlertControllerStyleAlert];
    [alertCtrl addAction:action];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertCtrl animated:YES completion:nil];
}


#pragma mark - Private
-(UIBarButtonItem*)backItemWithTarget:(id)target action:(SEL)action{
    return [self  backItemWithTarget:target action:action imgName:nil];
}

-(NSArray*)leftItemsWithTarget:(id)target action:(SEL)action{
    return [self leftItemsWithTarget:target action:action imgName:nil];
}

-(NSArray*)leftItemsWithTarget:(id)target action:(SEL)action imgName:(NSString*)imgName{
    
    UIBarButtonItem *backBarItem = [self backItemWithTarget:target action:action];
    if( imgName && imgName.length > 0 ){
        backBarItem = [self  backItemWithTarget:target action:action imgName:imgName];
    }
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                    target:nil
                                                                                    action:nil];
    negativeSpacer.width = -5;
    return @[negativeSpacer,backBarItem];
}

-(NSArray*)rightItemsWithTitle:(NSString*)title imgName:(NSString*)imgName selImgName:(NSString*)selImgName action:(SEL)action titleFont:(UIFont*)font titleColor:(UIColor*)titleColor rightBtn:(UIButton**)rightBtn{
    UIBarButtonItem *rightBarItem = [self barItemWithNormalTitle:title
                                                     normalImage:imgName
                                                      hightImage:nil
                                                     selectedImg:selImgName
                                                       andTarget:self andAction:action
                                                       titleFont:font titleColor:titleColor];
    if( rightBtn ){
        UIButton *rb = [rightBarItem customView];
        if( [rb isKindOfClass:[UIButton class]] ){
            *rightBtn = rb;
        }
    }
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                    target:nil
                                                                                    action:nil];
    negativeSpacer.width = -5;
    return @[negativeSpacer,rightBarItem];
}

-(UIBarButtonItem*)backItemWithTarget:(id)target action:(SEL)action imgName:(NSString*)imgName{
    UIButton *button = [[UIButton alloc] init];
    button.frame = CGRectMake(-10, 0, 80, 40);
    NSString *name = @"arrow_left_51";
    if( imgName && imgName.length > 0 ){
        name = imgName;
    }
    [button setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, button.frame.size.width - button.currentImage.size.width);
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    if( [target respondsToSelector:action] ){
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (UIBarButtonItem *)barItemWithNormalTitle:(NSString *)title normalImage:(NSString *)normalI hightImage:(NSString *)hightI selectedImg:(NSString*)seletImgName andTarget:(id)target andAction:(SEL)action titleFont:(UIFont*)font titleColor:(UIColor*)titleColor{
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:title forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 80, 40);
    [button setImage:[UIImage imageNamed:normalI] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:hightI] forState:UIControlStateHighlighted];
    [button setImage:[UIImage imageNamed:seletImgName] forState:UIControlStateSelected];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    if( [titleColor isKindOfClass:[UIColor class]] )
        [button setTitleColor:titleColor forState:UIControlStateNormal];
    if( button.currentImage ){
        button.imageEdgeInsets = UIEdgeInsetsMake(0, button.frame.size.width - button.currentImage.size.width, 0, 0);
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    }
    else{
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        
        [button setTitleColor:[UIColor colorWithWhite:0.8 alpha:0.9] forState:UIControlStateHighlighted];
        
    }
    UIFont *titleFont = [UIFont systemFontOfSize:16.0];
    if( font ){
        titleFont = font;
    }
    //    [button setTitleColor:[UIColor colorWithRed:51/255./0 green:51/255.0 blue:51/255.0 alpha:1] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:102/255./0 green:102/255.0 blue:102/255.0 alpha:1] forState:UIControlStateDisabled];
    [button.titleLabel setFont:titleFont];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (UIBarButtonItem *)barItemWithNormalTitle:(NSString *)title normalImage:(NSString *)normalI hightImage:(NSString *)hightI selectedImg:(NSString*)seletImgName andTarget:(id)target andAction:(SEL)action titleAlignment:(NSTextAlignment)ta{
    UIControlContentHorizontalAlignment ha = UIControlContentHorizontalAlignmentRight;
    if( [UIImage imageNamed:normalI] ){
        ha =  UIControlContentHorizontalAlignmentCenter;
    }
    
    return
    [self barItemWithNormalTitle:title normalImage:normalI hightImage:hightI selectedImg:seletImgName andTarget:target andAction:action titleAlignment:ta contentHorizontalAlignment:ha];
}

- (UIBarButtonItem *)barItemWithNormalTitle:(NSString *)title normalImage:(NSString *)normalI hightImage:(NSString *)hightI selectedImg:(NSString*)seletImgName andTarget:(id)target andAction:(SEL)action titleAlignment:(NSTextAlignment)ta contentHorizontalAlignment:(UIControlContentHorizontalAlignment)contentAli{
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:title forState:UIControlStateNormal];
    CGSize tileSize = [self lableSizeWithText:title font:[UIFont systemFontOfSize:14.0] width:100];
    button.frame = CGRectMake(0, 0, 70, 40);
    if( normalI.length )
        [button setImage:[UIImage imageNamed:normalI] forState:UIControlStateNormal];
    if( hightI.length )
        [button setImage:[UIImage imageNamed:hightI] forState:UIControlStateHighlighted];
    if( seletImgName.length )
        [button setImage:[UIImage imageNamed:seletImgName] forState:UIControlStateSelected];
    if( button.currentImage ){
        button.imageEdgeInsets = UIEdgeInsetsMake(0, button.frame.size.width - button.currentImage.size.width, 0, 0);
        CGFloat titleToImg = 3.0;
        button.titleEdgeInsets = UIEdgeInsetsMake(0, button.frame.size.width-button.currentImage.size.width*2 - tileSize.width - titleToImg, 0, button.currentImage.size.width+titleToImg);
        //        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    }
    //    else{
    //        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    //    }
    if( normalI == nil ){
        [button setTitleColor:[UIColor colorWithWhite:0.7 alpha:0.9] forState:UIControlStateHighlighted];
    }
    [button.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    if( [target respondsToSelector:action] ){
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    button.titleLabel.textAlignment = ta;
    button.contentHorizontalAlignment = contentAli;
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

-(CGSize)lableSizeWithText:(NSString *)text font:(UIFont *)font width:(CGFloat)width{
    CGSize size = CGSizeMake(width, MAXFLOAT);
    return [ text boundingRectWithSize:size
                               options:NSStringDrawingUsesLineFragmentOrigin
                            attributes:@{NSFontAttributeName:font} context:nil].size;
}

#pragma mark - TouchEvents
- (void)handleBackBtn:(id)obj{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)handleLeftBtn:(id)obj{
    NSLog(@"%s",__func__);
}
@end

@implementation UIViewController(ViewTag)

NSInteger const TagNaviBgView = 987654321;

@end
