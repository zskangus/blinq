//
//  SMStepCounterDescribeInterface.m
//  Blinq
//
//  Created by zsk on 2017/10/15.
//  Copyright © 2017年 zsk. All rights reserved.
//

#import "SMStepCounterDescribeInterface.h"

@interface SMStepCounterDescribeInterface ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *lable1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@end

@implementation SMStepCounterDescribeInterface

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setUi];
}

- (void)setUi{
    if ([NSLocalizedString(@"language", nil)isEqualToString:@"German"]) {
        [SKAttributeString setLabelFontContent:self.titleLabel title:NSLocalizedString(@"step_counter_Describe_title", nil) font:Avenir_Black Size:23 spacing:3.2 color:[UIColor whiteColor]];
        
        [SKAttributeString setLabelFontContent2:self.lable1 title:NSLocalizedString(@"step_counter_Describe_label1", nil) font:Avenir_Heavy Size:14 spacing:4.2 color:[UIColor whiteColor]];
        
        
        [SKAttributeString setLabelFontContent:self.label2 title:NSLocalizedString(@"step_counter_Describe_label2", nil) font:Avenir_Heavy Size:12 spacing:3 color:[UIColor whiteColor]];
        
        [SKAttributeString setLabelFontContent:self.label3 title:NSLocalizedString(@"step_counter_Describe_label3", nil) font:Avenir_Heavy Size:12 spacing:3 color:[UIColor whiteColor]];
        
        [SKAttributeString setLabelFontContent:self.label4 title:NSLocalizedString(@"step_counter_Describe_label4", nil) font:Avenir_Heavy Size:12 spacing:3 color:[UIColor whiteColor]];
        
        [SKAttributeString setButtonFontContent:self.doneButton title:NSLocalizedString(@"step_counter_Describe_button_title", nil) font:Avenir_Light Size:20 spacing:3 color:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }else if ([NSLocalizedString(@"language", nil)isEqualToString:@"中文"]){
        
        [SKAttributeString setLabelFontContent:self.titleLabel title:NSLocalizedString(@"step_counter_Describe_title", nil) font:Avenir_Black Size:30 spacing:3.2 color:[UIColor whiteColor]];
        
        [SKAttributeString setLabelFontContent2:self.lable1 title:NSLocalizedString(@"step_counter_Describe_label1", nil) font:Avenir_Heavy Size:24 spacing:2 color:[UIColor whiteColor]];
        
        
        CGRect label1Frame = self.lable1.frame;
        
        label1Frame.origin.y -= 30;
        
        label1Frame.size.height += 80;
        
        self.lable1.frame = label1Frame;
        
        [SKAttributeString setLabelFontContent:self.label2 title:NSLocalizedString(@"step_counter_Describe_label2", nil) font:Avenir_Heavy Size:20 spacing:3 color:[UIColor whiteColor]];
        
        
        [SKAttributeString setLabelFontContent:self.label3 title:NSLocalizedString(@"step_counter_Describe_label3", nil) font:Avenir_Heavy Size:20 spacing:3 color:[UIColor whiteColor]];
        
        CGRect label3Frame = self.label3.frame;
        
        //label4Frame.size.height += 15;
        
        label3Frame.origin.y += 10;
        
        self.label3.frame = label3Frame;
        
        [SKAttributeString setLabelFontContent:self.label4 title:NSLocalizedString(@"step_counter_Describe_label4", nil) font:Avenir_Heavy Size:20 spacing:3 color:[UIColor whiteColor]];
        
        CGRect label4Frame = self.label4.frame;
        
        label4Frame.size.width += 15;
        
        label4Frame.origin.y += 14;
        
        self.label4.frame = label4Frame;

    
        
        [SKAttributeString setButtonFontContent:self.doneButton title:NSLocalizedString(@"step_counter_Describe_button_title", nil) font:Avenir_Light Size:20 spacing:3 color:[UIColor whiteColor] forState:UIControlStateNormal];
    }else{
        [SKAttributeString setLabelFontContent:self.titleLabel title:NSLocalizedString(@"step_counter_Describe_title", nil) font:Avenir_Black Size:23 spacing:3.2 color:[UIColor whiteColor]];
        
        [SKAttributeString setLabelFontContent2:self.lable1 title:NSLocalizedString(@"step_counter_Describe_label1", nil) font:Avenir_Heavy Size:14 spacing:4.2 color:[UIColor whiteColor]];
        
        
        [SKAttributeString setLabelFontContent:self.label2 title:NSLocalizedString(@"step_counter_Describe_label2", nil) font:Avenir_Heavy Size:13 spacing:3.6 color:[UIColor whiteColor]];
        
        [SKAttributeString setLabelFontContent:self.label3 title:NSLocalizedString(@"step_counter_Describe_label3", nil) font:Avenir_Heavy Size:13 spacing:3.6 color:[UIColor whiteColor]];
        
        [SKAttributeString setLabelFontContent:self.label4 title:NSLocalizedString(@"step_counter_Describe_label4", nil) font:Avenir_Heavy Size:13 spacing:3.6 color:[UIColor whiteColor]];
        
        [SKAttributeString setButtonFontContent:self.doneButton title:NSLocalizedString(@"step_counter_Describe_button_title", nil) font:Avenir_Light Size:20 spacing:3 color:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

- (void)setLabelFontContent1:(UILabel*)label title:(NSString*)string font:(Avenir)font Size:(CGFloat)size spacing:(CGFloat)spacing color:(UIColor*)color particularString:(NSString*)particularString particularColor:(UIColor*)particularColor{
    
    if (string.length <= 0) {
        string = @"";
    }
    
    NSRange range = NSMakeRange(0, string.length);
    
    NSMutableAttributedString * attribute = [[NSMutableAttributedString alloc]initWithString:string];
    
    // 设置文字颜色
    [attribute addAttribute:NSForegroundColorAttributeName value:color range:range];
    
    if (particularString.length > 0) {
        NSRange rangess = [string rangeOfString:particularString];
        [attribute addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:rangess];
        [attribute addAttribute:NSForegroundColorAttributeName value:particularColor range:rangess];

    }

    
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

- (void)setLabelFontContent:(UILabel*)label title:(NSString*)string font:(Avenir)font Size:(CGFloat)size spacing:(CGFloat)spacing color:(UIColor*)color particularString:(NSString*)particularString particularColor:(UIColor*)particularColor{
    
    if (string.length <= 0) {
        string = @"";
    }
    
    NSRange range = NSMakeRange(0, string.length);
    
    NSMutableAttributedString * attribute = [[NSMutableAttributedString alloc]initWithString:string];
    
    // 设置文字颜色
    [attribute addAttribute:NSForegroundColorAttributeName value:color range:range];
    
    
    if (particularString.length > 0) {
        NSRange rangess = [string rangeOfString:particularString];
        [attribute addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:rangess];
        [attribute addAttribute:NSForegroundColorAttributeName value:particularColor range:rangess];
        
    }
    
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

- (IBAction)doneButton:(id)sender {
    
    [SKUserDefaults setBool:YES forKey:@"stepVcTurnedOn"];
    
    [SKViewTransitionManager dismissViewController:self duration:0.3 transitionType:TransitionPush directionType:TransitionFromLeft];
    
    self.returnBlock();
}

@end
