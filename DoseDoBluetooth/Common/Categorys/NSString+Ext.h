//
//  NSString+Ext.h
//  XWBluetooth
//
//  Created by wkun on 2019/1/1.
//  Copyright © 2019 bill. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Ext)
+ (BOOL)isNullString:(NSString*)str;
+ (NSString *)convertDataToHexStr:(NSData *)data;
+ (NSData *)convertHexStrToData:(NSString *)str;
@end

NS_ASSUME_NONNULL_END
