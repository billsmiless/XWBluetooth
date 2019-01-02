//
//  KKeyBoard.m
//  HopeHelpClient
//
//  Created by 端倪 on 16/2/2.
//  Copyright © 2016年 deepai. All rights reserved.
//

#import "KKeyBoard.h"
#import <UIKit/UIKit.h>

#define SCREEN_SIZE [UIScreen mainScreen].bounds.size

@implementation KKeyBoard{         
    UIButton *_doneBtn;
//    BOOL _keyBoardIsVisible;//键盘是否已经弹出
    BOOL _needAni;
}

@synthesize keyBoardHeight = _keyBoardHeight;

- (id)init{
   self = [super init];
    if( self){
        _textFieldToScreenBottom = -1;
        _keyBoardIsVisible = NO;
    }
    return self;
}

#pragma mark - Notification

- (void)keyBoardDidShow{
    //键盘弹出完毕
    if( _delegate && [_delegate respondsToSelector:@selector(keyBoardDidShow:)] ){
        [_delegate keyBoardDidShow:self];
    }
}

-(void)keyBoardWillShow:(NSNotification*)noti{
    

    NSDictionary *userInfo = [noti userInfo];
//    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
//    CGFloat keyBoardEndY = value.CGRectValue.origin.y;          //得到键盘弹出后，键盘视图的Y坐标
//    
//    CGFloat keyBoardHeight = [UIScreen mainScreen].bounds.size.height - keyBoardEndY;
//    _keyBoardHeight = keyBoardHeight;
    NSLog(@"_keyBoardHeight=%lf",_keyBoardHeight);
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    _keyBoardHeight = value.CGRectValue.size.height;
    if( self.delegate && [_delegate respondsToSelector:@selector(keyBoardWillShow:keyBoardHeight:)] && _keyBoardHeight> 100){
        
        [_delegate keyBoardWillShow:self keyBoardHeight:_keyBoardHeight];
        
        _keyBoardIsVisible = YES;
    }
    
    _needAni = NO;
    if( _keyBoardHeight > _textFieldToScreenBottom && _textFieldToScreenBottom > 0 ){
        //需要移动
        _needAni = YES;
    }
    
    if( _isNeedAnimation || _needAni ){
               //键盘动画，使视图更随键盘移动
//        NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
//        NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
//
//        [UIView animateWithDuration:duration.doubleValue animations:^{
//            [UIView setAnimationBeginsFromCurrentState:YES];
//            [UIView setAnimationCurve:[curve intValue]];
//
//        }];
    }
    
    [self addDoneBtn];
}

-(void)keyboardWillHide:(NSNotification*)noti{
    
    if( _delegate && [_delegate respondsToSelector:@selector(keyBoardWillHide:keyBoardHeight:)] ){
        [_delegate keyBoardWillHide:self keyBoardHeight:_keyBoardHeight];
        
        _keyBoardIsVisible = NO;
    }
}

-(void)keyBoardAnimationShowSel{
    [_delegate keyBoardAnimationShow:self];
}

#pragma mark - Other

-(void)removeDoneBtn{
    if( _doneBtn ){
        [_doneBtn removeFromSuperview];
        _doneBtn = nil;
    }
}

- (void)addDoneBtn{
    
#warning 暂时不加完成按钮，IOS9 点击没有事件 与 键盘事件冲突
    return;
    
    UIView *foundKeyboard = nil;
    UIWindow *keyboardWindow = nil;
    
    for (UIWindow *testWindow in [[UIApplication sharedApplication] windows]) {
        if (![[testWindow class] isEqual:[UIWindow class]]) {
            keyboardWindow = testWindow;
        }
    }
    
    if (!keyboardWindow) return;
    
    for (__strong UIView *possibleKeyboard in [keyboardWindow subviews]) {
        
        if ([[possibleKeyboard description] hasPrefix:@"<UIInputSetContainerView"]) {
            for (__strong UIView *possibleKeyboard_2 in possibleKeyboard.subviews) {
                if ([possibleKeyboard_2.description hasPrefix:@"<UIInputSetHostView"]) {
                    foundKeyboard = possibleKeyboard_2;
                }
            }
        }
    }
    
    if (foundKeyboard) {
        if ([[foundKeyboard subviews] indexOfObject:_doneBtn] == NSNotFound) {
            _doneBtn = [self doneBtn];
            _doneBtn.backgroundColor = [UIColor redColor];
            
            [foundKeyboard addSubview:_doneBtn];
            [foundKeyboard bringSubviewToFront:_doneBtn];
        } else {
            [foundKeyboard bringSubviewToFront:_doneBtn];
        }
    }
}

-(void)addDoneBtn1{
    // locate keyboard view
    UIWindow* tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
    UIView* keyboard;
    UIView *inputSetContainerView = nil;
    if( tempWindow.subviews.count ){
        inputSetContainerView = [tempWindow subviews][0];
    }
    for(int i=0; i<[ inputSetContainerView subviews].count; i++) {
        keyboard = [inputSetContainerView.subviews objectAtIndex:i];
        // keyboard view found; add the custom button to it
        if([[keyboard description] hasPrefix:@"<UIInputSetHostView"] == YES){
           
            UIButton *doneButton = _doneBtn;
            
            if( self.isNeedAddDoneWhenKeyboardNumPad ){
                
                if( doneButton ){
                    [doneButton removeFromSuperview];
                    doneButton = nil;
                }
                
                if (doneButton==nil) {
                    doneButton = [[UIButton alloc] init];
                    _doneBtn = doneButton;
//                    doneButton.frame = CGRectMake(0, 163, 104, 53);
                    doneButton.frame = CGRectMake(0, SCREEN_SIZE.height-53, 104, 53);
                    doneButton.adjustsImageWhenHighlighted = NO;
                    [doneButton setBackgroundImage:[UIImage imageNamed:@"done_normal"] forState:UIControlStateNormal];
                    [doneButton setTitle:@"完成" forState:UIControlStateNormal];
                    [doneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    [doneButton setBackgroundImage:[UIImage imageNamed:@"done_down"] forState:UIControlStateHighlighted];
                    [doneButton addTarget:self action:@selector(doneButton:) forControlEvents:UIControlEventTouchUpInside];
//                    UIView *kb = keyboard.subviews.count ? keyboard.subviews[0] :nil;
//                    [kb addSubview:doneButton];
//                    [kb bringSubviewToFront:doneButton];
                    doneButton.backgroundColor = [UIColor redColor];
                    [tempWindow addSubview:doneButton];
                    [tempWindow bringSubviewToFront:doneButton];
//                    [keyboard bringSubviewToFront:doneButton];
                }
            }
        }
    }
}

- (UIButton*)doneBtn{
    UIButton *doneButton = [[UIButton alloc] init];
    doneButton.frame = CGRectMake(0, 163, 104, 53);
    doneButton.adjustsImageWhenHighlighted = NO;
    [doneButton setBackgroundImage:[UIImage imageNamed:@"done_normal"] forState:UIControlStateNormal];
    [doneButton setTitle:@"完成" forState:UIControlStateNormal];
    [doneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [doneButton setBackgroundImage:[UIImage imageNamed:@"done_down"] forState:UIControlStateHighlighted];
    
    [doneButton addTarget:self action:@selector(doneButton:) forControlEvents:UIControlEventTouchUpInside];
    return doneButton;
}

- (void)setIsNeedAddDoneWhenKeyboardNumPad:(BOOL)isNeedAddDoneWhenKeyboardNumPad{
    _isNeedAddDoneWhenKeyboardNumPad = isNeedAddDoneWhenKeyboardNumPad;

    if( isNeedAddDoneWhenKeyboardNumPad == NO ){
        [self removeDoneBtn];
    }
    else{
        if( _keyBoardIsVisible )
            [self addDoneBtn];
    }
}

- (void)doneButton:(UIButton*)done{
    if( _delegate && [_delegate respondsToSelector:@selector(keyBoardDone:)]){
        [_delegate keyBoardDone:self];
    }
}

#pragma mark - public

-(void)addObserverKeyBoard{

    NSNotificationCenter *noti = [NSNotificationCenter defaultCenter];
    [noti addObserver:self selector:@selector(keyBoardWillShow:)  name:UIKeyboardWillShowNotification object:nil];
    [noti addObserver:self selector:@selector(keyBoardDidShow) name:UIKeyboardDidShowNotification object:nil];
    [noti addObserver:self selector:@selector(keyboardWillHide:)  name:UIKeyboardWillHideNotification object:nil];
}

-(void)removeObserver{

    NSNotificationCenter *noti = [NSNotificationCenter defaultCenter];
    [noti removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [noti removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

@end



