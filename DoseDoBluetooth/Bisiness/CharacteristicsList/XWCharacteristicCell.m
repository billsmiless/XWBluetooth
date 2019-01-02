//
//  XWCharacteristicCell.m
//  XWBluetooth
//
//  Created by cgw on 2019/1/2.
//  Copyright © 2019 bill. All rights reserved.
//

#import "XWCharacteristicCell.h"
#import "UIView+LayoutMethods.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "NSString+Ext.h"

@interface XWCharacteristicCell()


@property (nonatomic, strong) UILabel *propertiesL;   //特征类型 如读或写
@property (nonatomic, strong) UISwitch *notifySwitch; //通知开关

@end

@implementation XWCharacteristicCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if( self ){
        _nameL = [self labelWithFont:[UIFont systemFontOfSize:14]];
        _valueL = [self labelWithFont:nil];
        _propertiesL = [self labelWithFont:nil];
        
        _notifySwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
        [_notifySwitch setOn:NO];
        _notifySwitch.onTintColor = [UIColor orangeColor];
        [_notifySwitch addTarget:self action:@selector(handleSwitch:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_notifySwitch];
    }
    return self;
}

- (void)setChara:(CBCharacteristic *)chara{
    _chara = chara;
    _nameL.text = [NSString stringWithFormat:@"特性%@",chara.UUID.UUIDString];
    _valueL.text = [NSString convertDataToHexStr:chara.value];
    _valueL.adjustsFontSizeToFitWidth = YES;
    _propertiesL.text = [self characteristicTypeTextWithProperties:chara.properties];
    
    self.notifySwitch.hidden = !(chara.properties&CBCharacteristicPropertyNotify);
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGSize size = self.size;
    
    CGFloat btnW = 60,btnH = 40;
    self.notifySwitch.frame = CGRectMake(size.width-btnW, (size.height-btnH)/2, btnW, btnH);
    
    CGFloat ix = 10;
    CGFloat iTop = 5;
    CGFloat ih = (size.height - iTop*2)/3;
    _nameL.frame  = CGRectMake(ix, iTop, _notifySwitch.x-ix-5, ih);
    _valueL.frame = CGRectMake(ix, _nameL.bottom, _nameL.width, ih);
    _propertiesL.frame = CGRectMake(ix, _valueL.bottom, _valueL.width, ih);
}

#pragma mark - Private

- (UILabel*)labelWithFont:(UIFont*)font{
    UILabel *lbl = [UILabel new];
    lbl.textColor = [UIColor colorWithWhite:51/255.0 alpha:1];
    if( font )
        lbl.font = font;
    else{
        lbl.font = [UIFont systemFontOfSize:12];
    }
    [self.contentView addSubview:lbl];
    return lbl;
}

- (NSString*)characteristicTypeTextWithProperties:(CBCharacteristicProperties)properties{
    NSString *text = nil;
    if( properties & CBCharacteristicPropertyRead ){
        text = @"Read";
    }
    
    if( properties & CBCharacteristicPropertyWrite ){
        NSString *wr = @"Write";
        if( text == nil ){
            text = wr;
        }
        else{
            text = [NSString stringWithFormat:@"%@,%@",text,wr];
        }
    }
    
    if( properties & CBCharacteristicPropertyNotify ){
        NSString *nty = @"Notify";
        if( text == nil ){
            text = nty;
        }else{
            text = [NSString stringWithFormat:@"%@,%@",text,nty];
        }
    }
    
    if( text ){
        text = [NSString stringWithFormat:@"(%@)",text];
    }
    
    return text;
}

#pragma mark - TouchEvents
- (void)handleSwitch:(UISwitch*)swi{
    
    if( self.chara.properties & CBCharacteristicPropertyNotify ){
        if( _delegate && [_delegate respondsToSelector:@selector(characteristicCell:handleNotifiSwitch:)] ){
            [_delegate characteristicCell:self handleNotifiSwitch:swi];
        }
    }
}

@end
