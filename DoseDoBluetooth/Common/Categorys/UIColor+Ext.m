//
//  UIColor+Ext.m
//  Hitu
//
//  Created by hitomedia on 16/6/21.
//  Copyright © 2016年 hitomedia. All rights reserved.
//

#import "UIColor+Ext.h"

@implementation UIColor (Ext)
+ (UIColor *)colorWithR:(CGFloat)r G:(CGFloat)g B:(CGFloat)b{
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
}

+ (UIColor *)colorWithR:(CGFloat)r G:(CGFloat)g B:(CGFloat)b alpha:(CGFloat)alpha{
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:alpha];
}

#pragma mark - AappColor


/**
 登录页文本框背景色，暗绿色
 
 @return 颜色
 */
+ (UIColor*)colorWithRgb_61_173_198{
    return [self colorWithR:61 G:173 B:198];
}


+ (UIColor*)colorWithRgb_0_254_245{
    return [self colorWithR:0 G:254 B:245];
}

+ (UIColor *)colorWithRgb111{
    return [self colorWithR:111 G:111 B:111];
}

+ (UIColor *)colorWithRgb_239_239_244{
    return [self colorWithR:239  G:239 B:244];
}

+ (UIColor *)colorWithRgb_46_220_214{
    return [self colorWithR:46  G:220 B:215];
}

+ (UIColor *)colorWithRgb_155_180_251{
    return [self colorWithR:155 G:180 B:251];
}

+ (UIColor *)colorWithRgb_118_126_130{
    return [self colorWithR:118 G:126 B:130];
}

+ (UIColor *)colorWithRgb_23_201_203{
    return [self colorWithR:23 G:201 B:203];
}

#pragma mark -Old

+ (UIColor*)pColorWithR:(CGFloat)r G:(CGFloat)g B:(CGFloat)b{
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
}


+ (UIColor *)colorWithRgb_83_179_239{
    return [UIColor colorWithR:83 G:179 B:239];
}

+ (UIColor *)colorWithRgb7{
    return [UIColor colorWithR:7 G:7 B:7];
}

+ (UIColor*)colorWithRgb231{
    return [UIColor pColorWithR:231 G:231 B:231];
}

#pragma mark - OldAppColor

+ (UIColor *)colorWithRgb_4_128_195{
    return [UIColor pColorWithR:4 G:128 B:195];
}

+ (UIColor *)colorWithRgb_24_148_209{
    return [UIColor pColorWithR:24 G:148 B:209];
}

+ (UIColor*)colorWithRgb221{
    return [UIColor pColorWithR:221 G:221 B:221];
}

+ (UIColor*)colorWithRgb_155_155_163{
    return [UIColor pColorWithR:155 G:155 B:163];
}

+ (UIColor*)colorWithRgb_240_239_244{
    return [UIColor pColorWithR:240 G:239 B:244];
}

+ (UIColor *)colorWithRgb51{
    return [UIColor pColorWithR:51 G:51 B:51];
}

+ (UIColor *)colorWithRgb85{
    return [UIColor pColorWithR:85 G:85 B:85];
}

+ (UIColor *)colorWithRgb68{
    return [UIColor pColorWithR:68 G:68 B:68];
}

+ (UIColor*)colorWithRgb102{
    return [UIColor pColorWithR:102 G:102 B:102];
}

+ (UIColor*)colorWithRgb_250_100_92{
    return [UIColor pColorWithR:250 G:100 B:92];
}

+ (UIColor *)colorWithRgb153{
    return [UIColor pColorWithR:153 G:153 B:153];
}

+ (UIColor *)colorWithRgb_36_149_207{
    return [UIColor pColorWithR:36 G:149 B:207];
}

+(UIColor*)silverColor{
    return [UIColor pColorWithR:227 G:228 B:230];
}

+ (UIColor *)pinkishGreyColor{
    return [UIColor pColorWithR:204 G:204 B:204];
}

+ (UIColor*)colorWithRgb84_97_105{
    return [UIColor pColorWithR:84 G:97 B:105];
}

+ (UIColor*)colorWithRgb255_248_224{
    return [UIColor pColorWithR:255 G:248 B:224];
}


+ (UIColor*)colorWithRgb251_66_56{
    return [UIColor pColorWithR:251 G:66 B:56];
}

+ (UIColor*)colorWithRgb34{
    return [UIColor pColorWithR:34 G:34 B:34];
}

+ (UIColor *)colorWithRgb238{
    return [UIColor pColorWithR:238 G:238 B:238];
}

+ (UIColor *)colorWithRgb245{
    return [UIColor pColorWithR:245 G:245 B:245];
}

+ (UIColor *)colorWithRgb153_217_255{
    return [UIColor pColorWithR:153 G:217 B:255];
}

+ (UIColor*)colorWithRgb250_202_121{
    return [UIColor pColorWithR:250 G:202 B:121];
}

+ (UIColor*)colorWithRgb253_151_146{
    return [UIColor pColorWithR:253 G:151 B:146];
}

+ (UIColor*)colorWithRgb_214_213_215{
    return [UIColor pColorWithR:214 G:213 B:215];
}

+ (UIColor*)colorWithRgb_243_152_0{
    return [UIColor pColorWithR:243 G:152 B:0];
}

+ (UIColor*)colorWithRgb_70_169_218{//旅途中
    return [UIColor pColorWithR:70 G:169 B:218];
}

+ (UIColor*)colorWithRgb_92_191_185{//3小时40分钟后出发
    return [UIColor pColorWithR:92 G:191 B:185];
}

+ (UIColor*)colorWithRgb_251_131_125{//晚点，检票
    return [UIColor pColorWithR:251 G:131 B:125];
}

+ (UIColor*)colorWithRgb_101_186_127{//添加乘客
    return [UIColor pColorWithR:101 G:186 B:127];
}

+ (UIColor*)colorWithRgb_248_101_96{//
    return [UIColor pColorWithR:248 G:101 B:96];
}

+ (UIColor*)colorWithRgb_246_253_245{//
    return [UIColor pColorWithR:246 G:253 B:245];
}

+ (UIColor *)colorWithRgb_245_250_216{
    return [UIColor colorWithRed:254/255.0 green:250/255.0 blue:216/255.0 alpha:1.0];
}

+ (UIColor*)colorWithRgb_62_79_88{
    return [UIColor pColorWithR:62 G:79 B:88];
}

+ (UIColor *)colorWithRgb_42_197_90{
    return [UIColor pColorWithR:41 G:197 B:90];
}

#pragma mark - ThreeShow
//蓝色
+ (UIColor*)colorWithRgb_0_151_216{
    return [UIColor pColorWithR:0 G:151 B:216];
}

+ (UIColor *)colorWithRgb251_10_10{
     return [UIColor pColorWithR:251 G:10 B:10];
}

+ (UIColor *)colorWithRgb252_199_17{
    return [UIColor colorWithR:252 G:199 B:17];
}

@end
