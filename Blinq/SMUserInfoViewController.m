//
//  SMUserInfoViewController.m
//  Blinq
//
//  Created by zsk on 2017/10/15.
//  Copyright © 2017年 zsk. All rights reserved.
//

#import "SMUserInfoViewController.h"
#import "UITextField+Extension.h"
#import "SMTextField.h"

@interface SMUserInfoViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel1;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property(nonatomic)CGRect textframe;

@end

@implementation SMUserInfoViewController

- (void)viewWillAppear:(BOOL)animated{
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setUi];
}

- (void)setUi{
    if ([NSLocalizedString(@"language", nil)isEqualToString:@"German"]) {
 
        [SKAttributeString setLabelFontContent:self.titleLabel title:NSLocalizedString(@"your_info_title", nil) font:Avenir_Black Size:20 spacing:3 color:[UIColor whiteColor]];
        
        [SKAttributeString setLabelFontContent:self.titleLabel1 title:NSLocalizedString(@"yout_info_title1", nil) font:Avenir_Black Size:12 spacing:2 color:[UIColor whiteColor]];
        
        [SKAttributeString setLabelFontContent2:self.label title:NSLocalizedString(@"your_info_label", nil) font:Avenir_Light Size:14 spacing:4.1 color:[UIColor whiteColor]];
        
        [SKAttributeString setLabelFontContent:self.firstNameLabel title:NSLocalizedString(@"your_info_firstName", nil) font:Avenir_Black Size:16 spacing:2.46 color:[UIColor whiteColor]];
        [SKAttributeString setLabelFontContent:self.lastNameLabel title:NSLocalizedString(@"your_info_lastName", nil) font:Avenir_Black Size:16 spacing:2.46 color:[UIColor whiteColor]];
        
        [SKAttributeString setButtonFontContent:self.doneButton title:self.bottomButtonTitle font:Avenir_Light Size:20 spacing:3 color:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }else if ([NSLocalizedString(@"language", nil)isEqualToString:@"中文"]){
        
        [SKAttributeString setLabelFontContent:self.titleLabel title:NSLocalizedString(@"your_info_title", nil) font:Avenir_Black Size:20 spacing:3 color:[UIColor whiteColor]];
        
        [SKAttributeString setLabelFontContent:self.titleLabel1 title:NSLocalizedString(@"yout_info_title1", nil) font:Avenir_Black Size:20 spacing:5 color:[UIColor whiteColor]];
        
        self.titleLabel1.textAlignment = NSTextAlignmentCenter;
        
        CGRect titleLabel1Frame = self.titleLabel1.frame;
        
        titleLabel1Frame.size.width = 290;
        
        self.titleLabel1.frame = titleLabel1Frame;
        
        [SKAttributeString setLabelFontContent2:self.label title:NSLocalizedString(@"your_info_label", nil) font:Avenir_Black Size:18 spacing:8 color:[UIColor whiteColor]];
        
        CGRect labelFrame = self.label.frame;
        
        labelFrame.origin.y += 40;
        
        self.label.frame = labelFrame;
        
        [SKAttributeString setLabelFontContent:self.firstNameLabel title:NSLocalizedString(@"your_info_firstName", nil) font:Avenir_Black Size:16 spacing:2.46 color:[UIColor whiteColor]];
        [SKAttributeString setLabelFontContent:self.lastNameLabel title:NSLocalizedString(@"your_info_lastName", nil) font:Avenir_Black Size:16 spacing:2.46 color:[UIColor whiteColor]];
        
        [SKAttributeString setButtonFontContent:self.doneButton title:self.bottomButtonTitle font:Avenir_Light Size:20 spacing:3 color:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }else{
        [SKAttributeString setLabelFontContent:self.titleLabel title:NSLocalizedString(@"your_info_title", nil) font:Avenir_Black Size:20 spacing:3 color:[UIColor whiteColor]];
        
        [SKAttributeString setLabelFontContent:self.titleLabel1 title:NSLocalizedString(@"yout_info_title1", nil) font:Avenir_Black Size:13 spacing:3.5 color:[UIColor whiteColor]];
        
        [SKAttributeString setLabelFontContent2:self.label title:NSLocalizedString(@"your_info_label", nil) font:Avenir_Light Size:14 spacing:4.1 color:[UIColor whiteColor]];
        
        [SKAttributeString setLabelFontContent:self.firstNameLabel title:NSLocalizedString(@"your_info_firstName", nil) font:Avenir_Black Size:16 spacing:2.46 color:[UIColor whiteColor]];
        [SKAttributeString setLabelFontContent:self.lastNameLabel title:NSLocalizedString(@"your_info_lastName", nil) font:Avenir_Black Size:16 spacing:2.46 color:[UIColor whiteColor]];
        
        [SKAttributeString setButtonFontContent:self.doneButton title:self.bottomButtonTitle font:Avenir_Light Size:20 spacing:3 color:[UIColor whiteColor] forState:UIControlStateNormal];

    }
    
    self.firstNameTextField.delegate = self;
    [self.firstNameTextField addTarget:self action:@selector(numTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.firstNameTextField.tintColor = [UIColor whiteColor];
    
    self.lastNameTextField.delegate = self;
    [self.lastNameTextField addTarget:self action:@selector(numTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.lastNameTextField.tintColor = [UIColor whiteColor];
    //self.lastNameTextField.hidden = YES;
    
    SMTextField *tes = [[SMTextField alloc]initWithFrame:self.lastNameTextField.frame];
    //tes.backgroundColor = [UIColor grayColor];
    
    tes.delegate = self;
    tes.tintColor = [UIColor whiteColor];
    //[self.view addSubview:tes];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.firstNameTextField)
    {
        [self.firstNameTextField resignFirstResponder];
        [self.lastNameTextField becomeFirstResponder];
    }else if (textField == self.lastNameTextField){
        [self.lastNameTextField resignFirstResponder];

    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    self.textframe = textField.frame;
    
}

- (void)numTextFieldDidChange:(id) sender {
    
    UITextField *field = (UITextField *)sender;
    
    NSRange cursor = [field selectedCursorRange];
    NSLog(@"%@",NSStringFromRange(cursor));
    
    NSString *content = field.text;
    
    switch (field.tag) {
        case 1:
            NSLog(@"输入的内容:%@",content);
            //[SKUserDefaults setObject:content forKey:@"firstName"];
            break;
        case 2:
        {
            NSLog(@"输入的内容:%@",content);
            //[SKUserDefaults setObject:content forKey:@"lastName"];
        }
            break;
        case 3:
        {
            NSLog(@"输入的内容:%@",content);
            //            [SKUserDefaults setObject:content forKey:@"emailAddress"];
            
        }
            break;
        default:
            break;
    }
    
    field.text = content;

    NSDictionary *attrsDictionary =@{
                                     NSFontAttributeName:[UIFont fontWithName:@"Avenir-Light" size:13],
                                     NSKernAttributeName:[NSNumber numberWithFloat:3.9f],//这里修改字符间距
                                     NSForegroundColorAttributeName:[UIColor whiteColor]
                                     };
    field.attributedText=[[NSAttributedString alloc]initWithString:content attributes:attrsDictionary];
    
    [field setSelectedRange:cursor];
    
    
}

static int keyboardHeight;

- (void)keyboardWillShow:(NSNotification *)aNotification
{
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardHeight = keyboardRect.size.height;
    int height = keyboardRect.size.height;
    int width = keyboardRect.size.width;
    NSLog(@"键盘高度是  %d",height);
    NSLog(@"键盘宽度是  %d",width);
    
    CGFloat ratio = 0;
    
    if(SCREEN_HEIGHT == 667) ratio = 1;
    if(SCREEN_HEIGHT == 568) ratio = SCREEN_HEIGHT/667;
    if(SCREEN_HEIGHT == 736) ratio = SCREEN_HEIGHT/667;
    
    CGFloat textHeight = self.textframe.origin.y + self.textframe.size.height;
    
    textHeight = textHeight*ratio;
    
    CGFloat offset = self.view.frame.size.height - (textHeight + keyboardHeight+20);
    
    if (offset <= 0) {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = self.view.frame;
            frame.origin.y = offset;
            self.view.frame = frame;
        }];
    }
}

- (void)keyboardWillHide{
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = 0.0;
        self.view.frame = frame;
    }];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    NSString *content = textField.text;
    
    switch (textField.tag) {
        case 1:
            NSLog(@"最终输入的内容:%@",content);
            break;
        case 2:
            NSLog(@"最终输入的内容:%@",content);
            break;
        case 3:
            NSLog(@"最终输入的内容:%@",content);
            
            break;
        default:
            break;
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = 0.0;
        self.view.frame = frame;
    }];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //隐藏键盘
    [self.firstNameTextField resignFirstResponder];
    [self.lastNameTextField resignFirstResponder];
    
}



- (IBAction)doneButton:(id)sender {
    
    NSString *firstName = self.firstNameTextField.text;
    NSString *lastName = self.lastNameTextField.text;
    //NSString *emailAddress = self.textField3.text;
    
    if ([self isBlankString:firstName] || [self isBlankString:lastName]) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"tip_fill_text", nil) preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"ok", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertController setValue:[self setAlertControllerWithStrring:NSLocalizedString(@"tip_fill_text", nil) fontSize:14 spacing:1.85]  forKey:@"attributedMessage"];
        
        [alertController addAction:okAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        return;
    }else{
        
        SMPersonalModel *userInfo = [SMBlinqInfo userInfo];
        userInfo.familyName = firstName;
        userInfo.givenName = lastName;
        [SMBlinqInfo setUserInfo:userInfo];
        
        [self dismissViewControllerAnimated:NO completion:nil];
        self.returnBlock();
    }

}


@end
