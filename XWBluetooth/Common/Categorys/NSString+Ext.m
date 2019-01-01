//
//  NSString+Ext.m
//  XWBluetooth
//
//  Created by wkun on 2019/1/1.
//  Copyright © 2019 bill. All rights reserved.
//

#import "NSString+Ext.h"

@implementation NSString (Ext)

+ (BOOL)isNullString:(NSString *)str{
    if( str && [str isKindOfClass:[NSString class]] && str.length && [str isEqualToString:@""]==NO && [str isEqualToString:@"(null)"]==NO ){
        return NO;
    }
    return YES;
}

@end
