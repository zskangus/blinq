//
//  SMSocialViewController.m
//  Blinq
//
//  Created by zsk on 16/9/30.
//  Copyright © 2016年 zsk. All rights reserved.
//

#import "SMSocialViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import "customSwitch.h"

typedef NS_ENUM(NSInteger,loginState){
    FBlogin = 0,
    FBlogOut
};

loginState FBloginState;

@interface SMSocialViewController ()<customSwitchDelegate,UITextViewDelegate,FBSDKLoginButtonDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;

@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UILabel *postlabel;
@property (weak, nonatomic) IBOutlet customSwitch *postToWall;

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *portraitImage;
@property (weak, nonatomic) IBOutlet UIView *accountView;
@property (weak, nonatomic) IBOutlet UILabel *placeHolderLabel;

@end

static int keyboardHeight;
static BOOL isUserClick = NO;

@implementation SMSocialViewController

- (void)viewWillAppear:(BOOL)animated{
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive)
                                                 name:UIApplicationWillResignActiveNotification object:nil];
    
    [SKUserDefaults setBool:YES forKey:@"socialView"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [self setupFaceBookLoginButton];
    
    [self setupUI];

    [self setupText];
    
    self.textView.scrollEnabled = YES;
    
    self.textView.delegate = self;
    
    [self removeSocialDescriptionVc];
}

- (void)removeSocialDescriptionVc{
    //得到当前视图控制器中的所有控制器
    NSMutableArray *array = [self.navigationController.viewControllers mutableCopy];
    NSLog(@"%d",array.count);
    if (array.count >= 3) {
        //把SocialDescriptionVc从里面删除
        [array removeObjectAtIndex:1];
        //把删除后的控制器数组再次赋值
        [self.navigationController setViewControllers:[array copy] animated:YES];
    }

}

- (void)setupUI{
    
    [self setupNavigationTitle:@"SOCIAL S.O.S."];
    
    [SKAttributeString setLabelFontContent:self.titleLabel title:@"SOCIAL S.O.S." font:Avenir_Black Size:20 spacing:3 color:[UIColor whiteColor]];
    
    [SKAttributeString setLabelFontContent:self.label1 title:@"BLINQ CAN POST EMERGENCY MESSAGES TO YOUR FACEBOOK WALL IN THE CASE OF AN EMERGENCY. CONNECT YOUR ACCOUNT SO THAT WE CAN POST MESSAGES ON YOUR BEHALF" font:Avenir_Light Size:10 spacing:3 color:[UIColor whiteColor]];
    
    [SKAttributeString setLabelFontContent:self.postlabel title:@"POST TO MY WALL" font:Avenir_Book Size:16 spacing:2.46 color:[UIColor whiteColor]];
    
    [SKAttributeString setLabelFontContent:self.label2 title:@"POST MY LOCATION TO MY FACEBOOK WALL SO THAT ANYONE IN MY NETWORK CAN SEE THE MESSAGE AND COME TO MY RESCUE." font:Avenir_Light Size:8 spacing:2.4 color:[UIColor whiteColor]];
    
    [SKAttributeString setButtonFontContent:self.doneButton title:@"DONE" font:Avenir_Light Size:20 spacing:3 color:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [SKAttributeString setLabelFontContent:self.placeHolderLabel title:@"ENTER SOS MESSAGE HERE…" font:Avenir_Light Size:10 spacing:2.4 color:[UIColor blackColor]];
    
    
    
    self.postToWall.delegate = self;
    
    //设置发布开关的状态
    if ([SKUserDefaults boolForKey:@"faceBookConnectState"] == YES) {// 如果为登录状态
        [self.postToWall setOn:[SKUserDefaults boolForKey:@"postToWallPower"]];
        NSLog(@"faceBookPower%@",[SKUserDefaults boolForKey:@"postToWallPower"]?@"YES":@"NO");
        
        //显示登录的账号信息
        self.label1.hidden = YES;
        self.accountLabel.hidden = NO;
        self.portraitImage.hidden = NO;;
        self.postToWall.isDisable = NO;
        
        NSString *accountName = [SKUserDefaults objectForKey:@"faceBookAccountName"];
        NSData *portraitData = [SKUserDefaults objectForKey:@"portraitData"];
        
        [self setAccountLabel:accountName portrait:portraitData];
        
        
    }else{//如果连接状态为登出
        //显示登录的账号信息
        self.label1.hidden = NO;
        self.accountLabel.hidden = YES;
        self.portraitImage.hidden = YES;
        self.postToWall.isDisable = YES;
        [self.postToWall setOn:NO];
        [SKUserDefaults setBool:NO forKey:@"postToWallPower"];
    }

}

- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error{
    
    if (error) {
        NSLog(@"是否有错误:%@",error);
        
        if (error.code == 306) {
            
            NSString *str = @"Access has not been granted to the Facebook account. Verify device settings.";
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:[str uppercaseString] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alertController addAction:okAction];
            
            [alertController setValue:[self setAlertControllerWithStrring:[str uppercaseString] fontSize:14 spacing:1.85]  forKey:@"attributedMessage"];
            
            [self presentViewController:alertController animated:YES completion:nil];
            
        }
        
    }else if(result.isCancelled){
        
    }else{
        NSLog(@"已登录faceBook");
        
        FBloginState = FBlogin;
        
        [SKUserDefaults setBool:YES forKey:@"faceBookConnectState"];
        
        if ([FBSDKAccessToken currentAccessToken]) {
            [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
             startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                 if (!error) {
                     NSLog(@"fetched user:%@", result);
                     
                     // 用户名
                     NSString *userName = [result objectForKey:@"name"];
                     NSString *userId = [result objectForKey:@"id"];
                     [SKUserDefaults setObject:userName forKey:@"faceBookAccountName"];
                     
                     // 用户ID
                     NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=%d&height=%d",userId,200,200]];
                     dispatch_queue_t downloader = dispatch_queue_create("PicDownloader", NULL);
                     dispatch_async(downloader, ^{
                         
                         NSData *data = [NSData dataWithContentsOfURL:url];
                         [SKUserDefaults setObject:data forKey:@"portraitData"];
                         
                         dispatch_async(dispatch_get_main_queue(), ^{
                             
                             if (FBloginState == FBlogin) {
                                 //显示登录的账号信息
                                 self.label1.hidden = YES;
                                 self.accountLabel.hidden = NO;
                                 self.portraitImage.hidden = NO;;
                                 self.postToWall.isDisable = NO;
                                 [self setAccountLabel:userName portrait:data];
                             }

                         });
                         
                     });
                     
                     
                     //----------------------
                 }
             }];
        }
        
    }
    
}

- (void)setAccountLabel:(NSString*)accountName portrait:(NSData*)portrait{

    [SKAttributeString setLabelFontContent:self.accountLabel title:accountName font:Avenir_Black Size:14 spacing:2.8 color:[UIColor whiteColor]];
    self.portraitImage.image = [UIImage imageWithData:portrait];
    
    self.portraitImage.layer.cornerRadius = self.portraitImage.frame.size.width / 2;

    self.portraitImage.clipsToBounds = YES;
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton{
    NSLog(@"faceBook退出登录");
    
    FBloginState = FBlogOut;
    
    self.label1.hidden = NO;
    self.accountLabel.hidden = YES;
    self.portraitImage.hidden = YES;
    self.postToWall.isDisable = YES;
    [self.postToWall setOn:NO];
    [SKUserDefaults setBool:NO forKey:@"postToWallPower"];
    [SKUserDefaults setBool:NO forKey:@"faceBookConnectState"];
    
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me/permissions/publish_actions"
                                       parameters:nil
                                       HTTPMethod:@"DELETE"]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
         NSLog(@"%@",result);
     }];
}

- (void)setupNavigationTitle:(NSString *)string{
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0, 200, 44)];
    
    titleLabel.backgroundColor = [UIColor clearColor];
    
    titleLabel.text = string;
    
    titleLabel.font = [UIFont fontWithName: @"Avenir-Book" size:16];

    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    NSRange range = NSMakeRange(0, titleLabel.text.length);
    
    NSMutableAttributedString * attribute = [[NSMutableAttributedString alloc]initWithString:titleLabel.text];
    
    // 设置文字颜色
    [attribute addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:range];
    
    CGFloat floatNum = 2.46f;
    NSNumber *num = [NSNumber numberWithFloat:floatNum];
    
    // 设置文字间距
    [attribute addAttribute:NSKernAttributeName value:num range:range];
    
    titleLabel.attributedText = attribute;
    
    self.navigationItem.titleView = titleLabel;
}

- (void)setupFaceBookLoginButton{

    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    // Optional: Place the button in the center of your view.
    loginButton.frame = CGRectMake(45, 160, 280, 47);
    loginButton.delegate = self;
    loginButton.loginBehavior = FBSDKLoginBehaviorSystemAccount;
    [loginButton setTitle: @"Connect using Facebook" forState: UIControlStateNormal];
    
    [self.view addSubview:loginButton];
    
}

//发布开关
- (void)clickSwitch:(customSwitch *)Switch withBOOL:(BOOL)isOn{
    [self.postToWall setOn:isOn];
    [SKUserDefaults setBool:isOn forKey:@"postToWallPower"];
    
    NSLog(@"faceBookPower%@",isOn?@"YES":@"NO");
    
    if (![[FBSDKAccessToken currentAccessToken] hasGranted:@"publish_actions"]) {
        FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
        [loginManager logInWithPublishPermissions:@[@"publish_actions"]
                               fromViewController:self
                                          handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                              //TODO: process error or result.
                                              NSLog(@"%@",result);
                                          }];

    }
}

- (IBAction)doneButton:(id)sender {
    
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0]
                                          animated:YES];
    
    //[self.navigationController popViewControllerAnimated:YES];
}

- (void)keyboardWillShow:(NSNotification *)aNotification
{
    
    if (isUserClick == YES) {
        isUserClick = NO;

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
    
    CGFloat textHeight = self.textView.frame.origin.y + self.textView.frame.size.height;
    
    textHeight = textHeight*ratio;
    
    CGFloat offset = self.view.frame.size.height - (textHeight + keyboardHeight);
    
    if (offset <= 0) {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = self.view.frame;
            frame.origin.y = offset;
            self.view.frame = frame;
        }];
    }
    }
}


// textView开始编辑
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    isUserClick = YES;
    

    return YES;
}

// textView结束编辑
-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = 64;
        self.view.frame = frame;
    }];
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //隐藏键盘
    [self.textView resignFirstResponder];
    
}

// 加载此前保存的求救文本信息
- (void)setupText{
    NSString *string = [SKUserDefaults objectForKey:@"faceBookMessage"];
    
    if (![self isBlankString:string]) {
        self.placeHolderLabel.hidden = YES;
        self.textView.text = string;
    }
    

}

#pragma mark - textView的代理方法 - 监听文本信息
-(void)textViewDidChange:(UITextView *)textView{
    
    if (textView.text.length == 0) {
        self.placeHolderLabel.hidden = NO;
    }else{
        self.placeHolderLabel.hidden = YES;
    }
    
    NSUserDefaults *sosTextMessage = [NSUserDefaults standardUserDefaults];
    if (textView.markedTextRange == nil) {
        NSLog(@"----%@",textView.text);
        [sosTextMessage setObject:textView.text forKey:@"faceBookMessage"];
        [sosTextMessage synchronize];
    }


}

// textView回车推出键盘
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)applicationWillResignActive{
    [self.textView resignFirstResponder];
}


- (void)viewWillDisappear:(BOOL)animated{
    [SKUserDefaults setBool:NO forKey:@"socialView"];
    [self.textView resignFirstResponder];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
