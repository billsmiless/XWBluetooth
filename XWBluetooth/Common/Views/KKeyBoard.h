//
//  KKeyBoard.h
//  HopeHelpClient
//
//  Created by 端倪 on 16/2/2.
//  Copyright © 2016年 deepai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@protocol KKeyBoardDelegate;

@interface KKeyBoard : NSObject

@property (nonatomic, weak) id<KKeyBoardDelegate> delegate;

/**
 *  当键盘类型为NumPad时，是否需要添加Done按钮
 */
@property (nonatomic, assign) BOOL isNeedAddDoneWhenKeyboardNumPad;

/**
 *  是否监听键盘动画
 */
@property (nonatomic, assign) BOOL isNeedAnimation;

/**
 *  即将成为第一响应者的 textField或textView 距离屏幕底部的距离。默认为-1
 */
@property (nonatomic, assign) CGFloat textFieldToScreenBottom;

@property (nonatomic, assign, readonly) CGFloat keyBoardHeight;

@property(nonatomic,assign) BOOL keyBoardIsVisible; //键盘是否正在展示

/**
 *  监听键盘消失和出现
 */
-(void)addObserverKeyBoard;
/**
 *  当本实例销毁时，一定要移除监听。
 */
-(void)removeObserver;

@end

@protocol KKeyBoardDelegate <NSObject>

@optional
/**
 *  键盘展示动画结束。在此设置需要跟随键盘移动的视图的最终坐标
 *
 *  @param keyBoard KKeyBoard实例
 */
-(void)keyBoardAnimationShow:(KKeyBoard*)keyBoard;
/**
 *  键盘隐藏动画结束。在此设置需要跟随键盘移动的视图的最终坐标
 *
 *  @param keyBoard KKeyBoard实例
 */
-(void)keyBoardAnimationHide:(KKeyBoard*)keyBoard;

/**
 *  当键盘类型为 NumPad。且isNeedAddDoneWhenKeyboardNumPad 属性值为YES。则返回键盘左下角键盘按钮点击事件
 *
 *  @param keyBoard KKeyBoard 实例
 */
-(void)keyBoardDone:(KKeyBoard*)keyBoard;

/**
 *  键盘将要出现。此时，键盘高度已取到。
 *
 *  @param keyBoard
 */
- (void)keyBoardWillShow:(KKeyBoard*)keyBoard keyBoardHeight:(CGFloat)height;

/**
 *  键盘消失。
 *
 *  @param keyBoard 
 */
- (void)keyBoardWillHide:(KKeyBoard*)keyBoard keyBoardHeight:(CGFloat)height;

/**
 键盘完全弹出
 @param keyBoard 键盘
 */
- (void)keyBoardDidShow:(KKeyBoard*)keyBoard ;

@end




