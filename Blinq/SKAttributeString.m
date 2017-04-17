//
//  SKAttributeString.m
//  integration
//
//  Created by zsk on 16/7/28.
//  Copyright © 2016年 zsk. All rights reserved.
//

#import "SKAttributeString.h"

@implementation SKAttributeString


+ (NSMutableAttributedString*)setTextFieldAttributedPlaceholder:(NSString*)string font:(Avenir)font Size:(CGFloat)size spacing:(CGFloat)spacing color:(UIColor*)color{
    
    NSRange range = NSMakeRange(0, string.length);
    
    NSMutableAttributedString * attribute = [[NSMutableAttributedString alloc]initWithString:string];
    
    // 设置文字颜色
    [attribute addAttribute:NSForegroundColorAttributeName value:color range:range];
    
    NSString *fontString = [[NSString alloc]init];
    
    switch (font) {
        case Avenir_Black:
            fontString = @"Avenir-Black";
            break;
        case Avenir_Book:
            fontString = @"Avenir-Book";
            break;
        case Avenir_Heavy:
            fontString = @"Avenir-Heavy";
            break;
        case Avenir_Light:
            fontString = @"Avenir-Light";
            break;
            
        default:
            break;
    }
    
    // 设置字体及字体大小
    [attribute addAttribute: NSFontAttributeName value: [UIFont fontWithName:fontString size:size]range:range];
    
    CGFloat floatNum = spacing;
    NSNumber *num = [NSNumber numberWithFloat:floatNum];
    
    // 设置文字间距
    [attribute addAttribute:NSKernAttributeName value:num range:range];

    return attribute;
}

+ (void)setLabelFontContent:(UILabel*)label title:(NSString*)string font:(Avenir)font Size:(CGFloat)size spacing:(CGFloat)spacing color:(UIColor*)color{
    
    NSRange range = NSMakeRange(0, string.length);
    
    NSMutableAttributedString * attribute = [[NSMutableAttributedString alloc]initWithString:string];
    
    // 设置文字颜色
    [attribute addAttribute:NSForegroundColorAttributeName value:color range:range];
    
    NSString *fontString = [[NSString alloc]init];
    
    switch (font) {
        case Avenir_Black:
            fontString = @"Avenir-Black";
            break;
        case Avenir_Book:
            fontString = @"Avenir-Book";
            break;
        case Avenir_Heavy:
            fontString = @"Avenir-Heavy";
            break;
        case Avenir_Light:
            fontString = @"Avenir-Light";
            break;
            
        default:
            break;
    }
    
    // 设置字体及字体大小
    [attribute addAttribute: NSFontAttributeName value: [UIFont fontWithName:fontString size:size]range:range];
    
    CGFloat floatNum = spacing;
    NSNumber *num = [NSNumber numberWithFloat:floatNum];
    
    // 设置文字间距
    [attribute addAttribute:NSKernAttributeName value:num range:range];
    
    label.attributedText =attribute;
}


+ (void)setLabelFontContent2:(UILabel*)label title:(NSString*)string font:(Avenir)font Size:(CGFloat)size spacing:(CGFloat)spacing color:(UIColor*)color{
    
    NSRange range = NSMakeRange(0, string.length);
    
    NSMutableAttributedString * attribute = [[NSMutableAttributedString alloc]initWithString:string];
    
    // 设置文字颜色
    [attribute addAttribute:NSForegroundColorAttributeName value:color range:range];
    
    NSString *fontString = [[NSString alloc]init];
    
    switch (font) {
        case Avenir_Black:
            fontString = @"Avenir-Black";
            break;
        case Avenir_Book:
            fontString = @"Avenir-Book";
            break;
        case Avenir_Heavy:
            fontString = @"Avenir-Heavy";
            break;
        case Avenir_Light:
            fontString = @"Avenir-Light";
            break;
            
        default:
            break;
    }
    
    // 设置字体及字体大小
    [attribute addAttribute: NSFontAttributeName value: [UIFont fontWithName:fontString size:size]range:range];
    
    CGFloat floatNum = spacing;
    NSNumber *num = [NSNumber numberWithFloat:floatNum];
    
    // 设置文字间距
    [attribute addAttribute:NSKernAttributeName value:num range:range];
    
    NSMutableParagraphStyle *paragtaphStyle = [[NSMutableParagraphStyle alloc]init];
    
    paragtaphStyle.alignment = NSTextAlignmentJustified;//对齐方式
    paragtaphStyle.paragraphSpacing = 0.0;             //段落后面的间距
    paragtaphStyle.paragraphSpacingBefore = 0.0;       //段落前面的间距
    paragtaphStyle.firstLineHeadIndent = 0.0;           //首行头缩进
    paragtaphStyle.headIndent = 0.0;                    //头部缩进
    
    [attribute addAttribute:NSParagraphStyleAttributeName value:paragtaphStyle range:range];
    [attribute addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleNone] range:range];
    
    label.attributedText =attribute;
}

+ (void)setLabelFontContent3:(UILabel*)label title:(NSString*)string font:(Avenir)font Size:(CGFloat)size spacing:(CGFloat)spacing color:(UIColor*)color{
    
    NSRange range = NSMakeRange(0, string.length);
    
    NSMutableAttributedString * attribute = [[NSMutableAttributedString alloc]initWithString:string];
    
    // 设置文字颜色
    [attribute addAttribute:NSForegroundColorAttributeName value:color range:range];
    
    NSString *fontString = [[NSString alloc]init];
    
    switch (font) {
        case Avenir_Black:
            fontString = @"Avenir-Black";
            break;
        case Avenir_Book:
            fontString = @"Avenir-Book";
            break;
        case Avenir_Heavy:
            fontString = @"Avenir-Heavy";
            break;
        case Avenir_Light:
            fontString = @"Avenir-Light";
            break;
            
        default:
            break;
    }
    
    // 设置字体及字体大小
    [attribute addAttribute: NSFontAttributeName value: [UIFont fontWithName:fontString size:size]range:range];
    
    CGFloat floatNum = spacing;
    NSNumber *num = [NSNumber numberWithFloat:floatNum];
    
    // 设置文字间距
    [attribute addAttribute:NSKernAttributeName value:num range:range];
    
    NSMutableParagraphStyle *paragtaphStyle = [[NSMutableParagraphStyle alloc]init];
    
    paragtaphStyle.alignment = NSTextAlignmentCenter;//对齐方式
    paragtaphStyle.paragraphSpacing = 0.0;             //段落后面的间距
    paragtaphStyle.paragraphSpacingBefore = 0.0;       //段落前面的间距
    paragtaphStyle.firstLineHeadIndent = 0.0;           //首行头缩进
    paragtaphStyle.headIndent = 0.0;                    //头部缩进
    
    [attribute addAttribute:NSParagraphStyleAttributeName value:paragtaphStyle range:range];
    [attribute addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleNone] range:range];
    
    label.attributedText =attribute;
}


+ (void)setButtonFontContent:(UIButton *)button title:(NSString *)string font:(Avenir)font Size:(CGFloat)size spacing:(CGFloat)spacing color:(UIColor *)color forState:(UIControlState)state{

    [button setTitle:string forState:state];
    
    [button setTitleColor:color forState:state];
    
    NSRange range = NSMakeRange(0, string.length);
    
    NSMutableAttributedString * attribute = [[NSMutableAttributedString alloc]initWithString:string];
    
    // 设置文字颜色
    [attribute addAttribute:NSForegroundColorAttributeName value:color range:range];
    
    NSString *fontString = [[NSString alloc]init];
    
    switch (font) {
        case Avenir_Black:
            fontString = @"Avenir-Black";
            break;
        case Avenir_Book:
            fontString = @"Avenir-Book";
            break;
        case Avenir_Heavy:
            fontString = @"Avenir-Heavy";
            break;
        case Avenir_Light:
            fontString = @"Avenir-Light";
            break;
            
        default:
            break;
    }
    
    // 设置字体及字体大小
    [attribute addAttribute: NSFontAttributeName value: [UIFont fontWithName:fontString size:size]range:range];
    
    CGFloat floatNum = spacing;
    NSNumber *num = [NSNumber numberWithFloat:floatNum];
    
    // 设置文字间距
    [attribute addAttribute:NSKernAttributeName value:num range:range];
    
    button.titleLabel.attributedText = attribute;
}


+ (NSMutableAttributedString*)setTextFieldContent:(NSString*)string font:(Avenir)font Size:(CGFloat)size spacing:(CGFloat)spacing color:(UIColor*)color{

    NSRange range = NSMakeRange(0, string.length);
    
    NSMutableAttributedString * attribute = [[NSMutableAttributedString alloc]initWithString:string];
    
    // 设置文字颜色
    [attribute addAttribute:NSForegroundColorAttributeName value:color range:range];
    
    NSString *fontString = [[NSString alloc]init];
    
    switch (font) {
        case Avenir_Black:
            fontString = @"Avenir-Black";
            break;
        case Avenir_Book:
            fontString = @"Avenir-Book";
            break;
        case Avenir_Heavy:
            fontString = @"Avenir-Heavy";
            break;
        case Avenir_Light:
            fontString = @"Avenir-Light";
            break;
            
        default:
            break;
    }
    
    // 设置字体及字体大小
    [attribute addAttribute: NSFontAttributeName value: [UIFont fontWithName:fontString size:size]range:range];
    
    CGFloat floatNum = spacing;
    NSNumber *num = [NSNumber numberWithFloat:floatNum];
    
    // 设置文字间距
    [attribute addAttribute:NSKernAttributeName value:num range:range];
    
    NSMutableParagraphStyle *paragtaphStyle = [[NSMutableParagraphStyle alloc]init];
    
    paragtaphStyle.alignment = NSTextAlignmentJustified;//对齐方式
    paragtaphStyle.paragraphSpacing = 0.0;             //段落后面的间距
    paragtaphStyle.paragraphSpacingBefore = 0.0;       //段落前面的间距
    paragtaphStyle.firstLineHeadIndent = 0.0;           //首行头缩进
    paragtaphStyle.headIndent = 0.0;                    //头部缩进
    
    [attribute addAttribute:NSParagraphStyleAttributeName value:paragtaphStyle range:range];
    [attribute addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleNone] range:range];
    
    return attribute;
}

@end
