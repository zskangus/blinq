//
//  SMTextField.m
//  Blinq
//
//  Created by zsk on 2017/10/13.
//  Copyright © 2017年 zsk. All rights reserved.
//

#import "SMTextField.h"
#import "SKAttributeString.h"
#import "UITextField+Extension.h"

@implementation SMTextField

- (void)awakeFromNib {
    [super awakeFromNib];
    
        [self addTarget:self action:@selector(numTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if ([super initWithFrame:frame]) {
           [self addTarget:self action:@selector(numTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    
    return self;
}

- (void)numTextFieldDidChange:(id) sender {
    
    UITextField *field = (UITextField *)sender;
    
    NSString *content = field.text;
    
    NSRange cursor = [field selectedCursorRange];


            NSLog(@"输入的内容:%@",content);

    field.attributedText = [SKAttributeString setTextFieldContent:content font:Avenir_Light Size:13 spacing:3.9 color:[UIColor whiteColor]];

    [field setSelectedRange:cursor];
    
}

- (void)drawRect:(CGRect)rect{

}

- (BOOL)becomeFirstResponder

{
    
//    [self setValue:[UIColor whiteColor] forKeyPath:placeholderTextlable.textColor];
//    
//    return [super becomeFirstResponder];
    return [super becomeFirstResponder];
    
}

- (void)drawTextInRect:(CGRect)rect{
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(c, 1);
    CGContextSetLineJoin(c, kCGLineJoinRound);
    
    CGContextSetTextDrawingMode(c, kCGTextStroke);
    self.textColor = [UIColor whiteColor];
    [super drawTextInRect:rect];
}



@end
