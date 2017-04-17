//
//  UILabel+Font.m
//  wenzishipeiDemo
//
//  Created by zsk on 16/4/28.
//  Copyright © 2016年 zsk. All rights reserved.
//

#import "UILabel+Font.h"

#define Avenir_Black @"Avenir-Black"
#define Avenir_Heavy @"Avenir-Heavy"
#define Avenir_Light @"Avenir-Light"
#define Avenir_Book @"Avenir-Book"

#define Screen_height [[UIScreen mainScreen] bounds].size.height
#define Screen_width [[UIScreen mainScreen] bounds].size.width

@implementation UILabel (Font)

+ (void)load{
    Method imp = class_getInstanceMethod([self class], @selector(initWithCoder:));
    Method myImp = class_getInstanceMethod([self class], @selector(myInitWithCoder:));
    
    
    method_exchangeImplementations(imp, myImp);
}

- (id)myInitWithCoder:(NSCoder*)aDecode{
    [self myInitWithCoder:aDecode];
    if (self) {
        //部分不像改变字体的 把tag值设置成333跳过
        if(self.tag != 0){
            CGFloat fontSize = self.font.pointSize;
            NSString *string = self.text;
            
            NSLog(@"labelstr%@",string);
            
            switch (self.tag) {
                case 1:
                self.attributedText = [self setupLabelFont:Avenir_Black fontSize:fontSize spacing:@5.4 stringInfo:string];
                    break;
                case 2:
                self.attributedText = [self setupLabelFont:Avenir_Heavy fontSize:fontSize spacing:@3.6 stringInfo:string];
                    break;
                case 3:
                    self.attributedText = [self setupLabelFont:Avenir_Heavy fontSize:fontSize spacing:@3 stringInfo:string];
                    break;
                case 4:
                    self.attributedText = [self setupLabelFont:Avenir_Heavy fontSize:fontSize spacing:@3.7 stringInfo:string];
                    break;
                case 5:
                    self.attributedText = [self setupLabelFont:Avenir_Book fontSize:fontSize spacing:@2.46 stringInfo:string];
                    break;
                case 6:
                    self.attributedText = [self setupLabelFont:Avenir_Light fontSize:fontSize spacing:@3.3 stringInfo:string];
                    break;
                case 7:
                    self.attributedText = [self setupLabelFont:Avenir_Heavy fontSize:fontSize spacing:@2.1 stringInfo:string];
                    break;
                    
                default:
                    break;
            }
            
        }
        
    }
    return self;
}

- (NSMutableAttributedString *)setupLabelFont:(NSString*)font fontSize:(CGFloat)fontSize spacing:(id)spacing stringInfo:(NSString *)string{
    
//    CGFloat ratio = 0;
//    
//    if(Screen_height == 667) ratio = 1;
//    if(Screen_height == 568) ratio = Screen_height/667;
//    if(Screen_height == 736) ratio = Screen_height/667;
//    
//    NSLog(@"---ratio%f",ratio);
    
    NSRange range = NSMakeRange(0, string.length);
    
    NSMutableAttributedString * attribute = [[NSMutableAttributedString alloc]initWithString:string];
    
    // 设置字体及字体大小
    [attribute addAttribute: NSFontAttributeName value: [UIFont fontWithName: font size:fontSize]range:range];
    
    //NSLog(@"字体大小%f--倍率%f--结果%f",fontSize,ratio,fontSize*ratio);
    
    // 设置文字颜色
    [attribute addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:range];

    CGFloat spacingFloat = [spacing floatValue];
    
    spacingFloat = spacingFloat;
    
    NSNumber *newSpacing = [NSNumber numberWithFloat:spacingFloat];
    
    //NSLog(@"初始值----%@----倍率%f----最终值----%@",spacing,ratio,newSpacing);
    
    // 设置文字间距
    [attribute addAttribute:NSKernAttributeName value:newSpacing range:range];
    
    return attribute;
}



@end
