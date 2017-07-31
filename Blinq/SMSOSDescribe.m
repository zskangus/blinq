//
//  SMSOSDescribe.m
//  Blinq
//
//  Created by zsk on 2017/6/29.
//  Copyright © 2017年 zsk. All rights reserved.
//

#import "SMSOSDescribe.h"

@interface SMSOSDescribe ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *goback;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *ok;

@property(nonatomic,strong)NSArray *strTitles;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation SMSOSDescribe

- (NSArray *)strTitles{
    if (!_strTitles) {
        if ([NSLocalizedString(@"language", nil)isEqualToString:@"German"]) {
            _strTitles = @[@"1. Erbringung von Dienstleistungen",@"2. Eingereichte Inhalte",@"3. Gewährleistungsausschluss",@"4. Haftungsbeschränkung",@"5. Vollständige Zustimmung",@"6. Änderungen an den Bedingungen"];
        }else if ([NSLocalizedString(@"language", nil)isEqualToString:@"中文"]){
            _strTitles = @[@"1. Provision of Services",@"2. Submitted Content",@"3. Disclaimer of Warranties",@"4. Limitation of Liability",@"5. Entire Agreement",@"6. Changes to the Terms"];
        }else{
            _strTitles = @[@"1. Provision of Services",@"2. Submitted Content",@"3. Disclaimer of Warranties",@"4. Limitation of Liability",@"5. Entire Agreement",@"6. Changes to the Terms"];
        }
    }
    return _strTitles;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.titleLabel.text = NSLocalizedString(@"disclaimer", nil);
    
    [self.goback setTitle:NSLocalizedString(@"decline", nil)];
    
    [self.ok setTitle:NSLocalizedString(@"accept", nil)];

    NSString *messageStrring = NSLocalizedString(@"sos_Liability", nil);
    
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc]initWithString:messageStrring attributes:[self demoTextAttributes]];
    
    if ([NSLocalizedString(@"language", nil)isEqualToString:@"German"]) {
        [att addAttribute: NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, messageStrring.length)];

    }else if ([NSLocalizedString(@"language", nil)isEqualToString:@"中文"]){
        [att addAttribute: NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, messageStrring.length)];
    }else{
        [att addAttribute: NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, messageStrring.length)];

    }
    
    for (NSString *stringStitle in self.strTitles) {
        NSRange rangess = [messageStrring rangeOfString:stringStitle];
        [att addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:rangess];
        [att addAttribute: NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:rangess];
    }
    
    [att addAttributes:[self demoTextAttributes] range:NSMakeRange(0, messageStrring.length)];
    
    self.textView.textAlignment = NSTextAlignmentJustified;
    self.textView.attributedText = att;
    
    self.textView.editable = NO;

}

- (IBAction)goBack:(id)sender {
    //[self dismissViewControllerAnimated:YES completion:nil];
    [SKViewTransitionManager dismissViewController:self duration:0.3 transitionType:TransitionPush directionType:TransitionFromLeft];

}

- (IBAction)okBtn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    [SKUserDefaults setBool:YES forKey:@"isAccpetDisclaimer"];
    self.okBlock();
}

- (NSDictionary *)demoTextAttributes {
    NSMutableParagraphStyle *ps = [NSMutableParagraphStyle new];
    ps.alignment = NSTextAlignmentJustified;
    // here, NSBaselineOffsetAttributeName must be set though the default value is 0 to make the justified work.
    return @{NSParagraphStyleAttributeName :ps, NSBaselineOffsetAttributeName : @0.0f};
}



@end
