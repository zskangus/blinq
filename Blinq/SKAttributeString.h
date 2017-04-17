//
//  SKAttributeString.h
//  integration
//
//  Created by zsk on 16/7/28.
//  Copyright © 2016年 zsk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, Avenir) {
    Avenir_Black,
    Avenir_Heavy,
    Avenir_Light,
    Avenir_Book
};

typedef void(^attribute)(NSMutableAttributedString *str);

@interface SKAttributeString : NSObject

+ (NSMutableAttributedString*)setTextFieldAttributedPlaceholder:(NSString*)string font:(Avenir)font Size:(CGFloat)size spacing:(CGFloat)spacing color:(UIColor*)color;

+ (void)setLabelFontContent2:(UILabel*)label title:(NSString*)string font:(Avenir)font Size:(CGFloat)size spacing:(CGFloat)spacing color:(UIColor*)color;

+ (void)setLabelFontContent:(UILabel*)label title:(NSString*)string font:(Avenir)font Size:(CGFloat)size spacing:(CGFloat)spacing color:(UIColor*)color;

+ (void)setButtonFontContent:(UIButton*)button title:(NSString*)string font:(Avenir)font Size:(CGFloat)size spacing:(CGFloat)spacing color:(UIColor*)color forState:(UIControlState)state;

+ (NSMutableAttributedString*)setTextFieldContent:(NSString*)string font:(Avenir)font Size:(CGFloat)size spacing:(CGFloat)spacing color:(UIColor*)color;

+ (void)setLabelFontContent3:(UILabel*)label title:(NSString*)string font:(Avenir)font Size:(CGFloat)size spacing:(CGFloat)spacing color:(UIColor*)color;
@end
