//
//  XWWriteCharacteristicView.m
//  XWBluetooth
//
//  Created by cgw on 2019/1/2.
//  Copyright © 2019 bill. All rights reserved.
//

#import "XWWriteCharacteristicView.h"
#import "UIView+LayoutMethods.h"

@implementation XWWriteCharacteristicView{
    UILabel *_titleL;
    UITextField *_valueTf;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if( self ){
        _titleL = [UILabel new];
        _titleL.font = [UIFont systemFontOfSize:14];
        _titleL.textColor = [UIColor blackColor];
        _titleL.frame = CGRectMake(10, 5, 150, frame.size.height/2-5);
        [self addSubview:_titleL];
        
        _valueTf = [UITextField new];
        _valueTf.frame = CGRectMake(_titleL.x, _titleL.bottom, frame.size.width-2*_titleL.x, _titleL.height);
        _valueTf.font = [UIFont systemFontOfSize:12];
        _valueTf.textColor = [UIColor blackColor];
        _valueTf.layer.masksToBounds = YES;
        _valueTf.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:1].CGColor;
        _valueTf.layer.borderWidth = 0.5;
        
        _textField = _valueTf;
        [self addSubview:_valueTf];
        
        _titleL.text = @"写特征FFF6的特征值";
        
        //阴影
        UIView *view = self;
        view.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
        view.layer.shadowOffset = CGSizeMake(0,-3);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        view.layer.shadowOpacity = 0.1;//阴影透明度，默认0
        view.layer.shadowRadius = 3;//阴影半径，默认3
    }
    return self;
}


@end
