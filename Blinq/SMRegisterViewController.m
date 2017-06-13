//
//  SMRegisterViewController.m
//  Blinq
//
//  Created by zsk on 2016/10/12.
//  Copyright © 2016年 zsk. All rights reserved.
//

#import "SMRegisterViewController.h"
#import "SMBindingViewController.h"
#import "SMNetWorkState.h"
#import "SKFTPManager.h"
#import "SMMailchimp.h"
#import "SMRegisterSuccessfullyViewController.h"

typedef NS_ENUM(NSUInteger, registerState) {
    registerWorking,
    registerStandby
};

registerState smRegisterState = registerStandby;

@interface SMRegisterViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UITextField *textField1;
@property (weak, nonatomic) IBOutlet UILabel *lastName;
@property (weak, nonatomic) IBOutlet UITextField *textFile2;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UITextField *textField3;

@property (weak, nonatomic) IBOutlet UIButton *registerButton;

@property(nonatomic)CGRect textframe;

@end

@implementation SMRegisterViewController

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
    
    [self setupUi];
    
    [self setupTextField];
    
}


- (void)setupUi{
    [SKAttributeString setLabelFontContent:self.titleLabel title:@"REGISTER" font:Avenir_Black Size:20 spacing:3 color:[UIColor whiteColor]];
    
    
    [SKAttributeString setLabelFontContent2:self.label title:@"REGISTER YOUR RING TODAY TO BE NOTIFIED OF ANY UPGRADES OR UPDATES IN THE FUTURE. YOU WILL ALSO BE KEPT IN THE LOOP WITH OUR LATEST PROMOTIONS AND PRODUCTS." font:Avenir_Heavy Size:13 spacing:3.9 color:[UIColor whiteColor]];
    
    [SKAttributeString setLabelFontContent:self.name title:@"FIRST NAME" font:Avenir_Black Size:16 spacing:2.46 color:[UIColor whiteColor]];
    
    [SKAttributeString setLabelFontContent:self.lastName title:@"LAST NAME" font:Avenir_Black Size:16 spacing:2.46 color:[UIColor whiteColor]];
    
    [SKAttributeString setLabelFontContent:self.address title:@"EMAIL ADDRESS" font:Avenir_Black Size:16 spacing:2.46 color:[UIColor whiteColor]];
    
    [SKAttributeString setButtonFontContent:self.registerButton title:@"REGISTER NOW" font:Avenir_Book Size:16 spacing:2.46 color:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.textField1.delegate = self;
    [self.textField1 addTarget:self action:@selector(numTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.textFile2.delegate = self;
    [self.textFile2 addTarget:self action:@selector(numTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.textField3.delegate = self;
    [self.textField3 addTarget:self action:@selector(numTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.textField3.adjustsFontSizeToFitWidth=YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.textField1)
    {
        [self.textField1 resignFirstResponder];
        [self.textFile2 becomeFirstResponder];
    }else if (textField == self.textFile2){
        [self.textFile2 resignFirstResponder];
        [self.textField3 becomeFirstResponder];
    }else{
        [self.textField3 resignFirstResponder];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    self.textframe = textField.frame;
}

- (void)numTextFieldDidChange:(id) sender {
    
    UITextField *field = (UITextField *)sender;
    
    NSString *content = field.text;
    
    switch (field.tag) {
        case 1:
            NSLog(@"输入的内容:%@",content);
            [SKUserDefaults setObject:content forKey:@"firstName"];
            [self setText:self.textField1 content:content];

            break;
        case 2:
            NSLog(@"输入的内容:%@",content);
            [SKUserDefaults setObject:content forKey:@"lastName"];
            [self setText:self.textFile2 content:content];
            break;
        case 3:
            NSLog(@"输入的内容:%@",content);
            [SKUserDefaults setObject:content forKey:@"emailAddress"];
            [self setText:self.textField3 content:content];
            break;
        default:
            break;
    }
    
}


- (void)setText:(UITextField*)textField content:(NSString*)content{
    if (content.length == 0) {
        textField.attributedText = [[NSMutableAttributedString alloc]initWithString:@" "];
        textField.text = @"";
    }else{
        
        textField.attributedText = [SKAttributeString setTextFieldContent:content font:Avenir_Light Size:13 spacing:3.9 color:[UIColor whiteColor]];
    }
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

- (BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex =@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //隐藏键盘
    [self.textField1 resignFirstResponder];
    [self.textFile2 resignFirstResponder];
    [self.textField3 resignFirstResponder];
    
}
- (IBAction)goBindVc:(id)sender {
    
    NSString *firstName = self.textField1.text;
    NSString *lastName = self.textFile2.text;
    NSString *emailAddress = self.textField3.text;
    
    if ([self isBlankString:firstName] || [self isBlankString:lastName] || [self isBlankString:emailAddress]) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"PLEASE FILL IN ALL FIELDS TO CONTINUE" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertController setValue:[self setAlertControllerWithStrring:@"PLEASE FILL IN ALL FIELDS TO CONTINUE" fontSize:14 spacing:1.85]  forKey:@"attributedMessage"];
        
        [alertController addAction:okAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        return;
    }else{
        NSLog(@"填写的内容：%@-%@-%@",self.textField1.text,self.textFile2.text,self.textField3.text);
        
        if ([SMNetWorkState state] == NO) {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"WARNING" message:@"NETWORK UNAVAILABLE.CHECK NETWORK" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alertController addAction:okAction];
            
            [alertController setValue:[self setAlertControllerWithStrring:@"WARNING" fontSize:17 spacing:1.85] forKey:@"attributedTitle"];
            
            [alertController setValue:[self setAlertControllerWithStrring:@"NETWORK UNAVAILABLE.CHECK NETWORK" fontSize:14 spacing:1.85]  forKey:@"attributedMessage"];
            
            [self presentViewController:alertController animated:YES completion:nil];
            
            return;
        }else{
            
            if ([self isValidateEmail:emailAddress] == NO) {
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:[@"THE EMAIL ADDRESS YOU ENTERED IS NOT VALID" uppercaseString] preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"CLOSE" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self.textField3 becomeFirstResponder];
                }];
                
                [alertController addAction:okAction];
                
                [alertController setValue:[self setAlertControllerWithStrring:@"THE EMAIL ADDRESS YOU ENTERED IS NOT VALID" fontSize:14 spacing:1.85]  forKey:@"attributedMessage"];
                
                [self presentViewController:alertController animated:YES completion:nil];
                
                return;
                
            }
            
            [SMMailchimp registerUserInfo:firstName lastName:lastName emailAddress:emailAddress];
            
 
            
            if (screenHeight == 480) {
                SMRegisterSuccessfullyViewController *RegisterSuccessfully = [[SMRegisterSuccessfullyViewController alloc]initWithNibName:@"SMRegisterSuccessfullyViewController_ip4" bundle:nil];
                [self presentViewController:RegisterSuccessfully animated:YES completion:nil];
            }else{
                SMRegisterSuccessfullyViewController *RegisterSuccessfully = [[SMRegisterSuccessfullyViewController alloc]initWithNibName:@"SMRegisterSuccessfullyViewController" bundle:nil];
                [self presentViewController:RegisterSuccessfully animated:YES completion:nil];
            }
        
        }
        
    }
}



- (void)goSMBindingViewController{
    [SKUserDefaults setBool:NO forKey:@"isUploadSuccessful"];
    
    SMBindingViewController *bind = [[SMBindingViewController alloc]initWithNibName:@"SMBindingViewController" bundle:nil];
    [self presentViewController:bind animated:YES completion:nil];
    
    smRegisterState = registerStandby;
}

- (void)setupTextField{
    NSString *firstName = [SKUserDefaults objectForKey:@"firstName"];
    NSString *lastName = [SKUserDefaults objectForKey:@"lastName"];
    NSString *emailAddress = [SKUserDefaults objectForKey:@"emailAddress"];
    
    if (![self isBlankString:firstName]) {
        //self.textField1.text = firstName;
        self.textField1.attributedText = [SKAttributeString setTextFieldContent:firstName font:Avenir_Light Size:13 spacing:3.9 color:[UIColor whiteColor]];
    }
    
    if (![self isBlankString:lastName]) {
        //self.textFile2.text = lastName;
        self.textFile2.attributedText = [SKAttributeString setTextFieldContent:lastName font:Avenir_Light Size:13 spacing:3.9 color:[UIColor whiteColor]];
    }
    
    if (![self isBlankString:emailAddress]) {
        //self.textField3.text = emailAddress;
        self.textField3.attributedText = [SKAttributeString setTextFieldContent:emailAddress font:Avenir_Light Size:13 spacing:3.9 color:[UIColor whiteColor]];
    }

}


@end
