//
//  SMSosEmergencyViewController.m
//  Blinq
//
//  Created by zsk on 16/3/29.
//  Copyright © 2016年 zsk. All rights reserved.
//

#import "SMSosEmergencyViewController.h"
#import "customSwitch.h"
#import "SOSData.h"
#import "SOSModule.h"
#import "SmartRemindManager.h"
#import "NotificationInfo.h"
#import "SOSConfig.h"
#import "SMContactSosSelectViewController.h"
#import "SMMessageManager.h"
#import "SMContactModel.h"
#import "SMSosContactTool.h"
#import "NationalListViewController.h"
#import <ContactsUI/ContactsUI.h>
#import "SMSocialViewController.h"
#import "SMSocialDescriptionViewController.h"
#import "SMSosDescriptionViewController.h"
#import "SMSensitivityDescriptionViewController.h"
#import "SMSOSCheckAlgorithmService.h"
#import "BTServer.h"

typedef NS_ENUM(NSInteger,sosDescription){
    
    sosDescriptionOpening = 0,
    sosDescriptionOpened
    
};


sosDescription openStartup = sosDescriptionOpened;

@interface SMSosEmergencyViewController ()<customSwitchDelegate,UITextViewDelegate,CNContactPickerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *emergencyLable;
@property (weak, nonatomic) IBOutlet UILabel *sensitivityLabel;

@property (weak, nonatomic) IBOutlet UILabel *promptLable;
@property (weak, nonatomic) IBOutlet UILabel *addContacts;
@property (weak, nonatomic) IBOutlet UILabel *sendTextMessageLabel;
@property (weak, nonatomic) IBOutlet UILabel *promplabel2;
@property (weak, nonatomic) IBOutlet UILabel *socialLabel;
@property (weak, nonatomic) IBOutlet customSwitch *customSwitch;
@property (weak, nonatomic) IBOutlet customSwitch *locationSwitch;
@property (weak, nonatomic) IBOutlet customSwitch *sendMessageSwitch;
@property (weak, nonatomic) IBOutlet customSwitch *socialSOSSwitch;
@property (weak, nonatomic) IBOutlet customSwitch *sensitivitySwitch;

@property (weak, nonatomic) IBOutlet UIView *addContact;

@property (weak, nonatomic) IBOutlet UIView *contactView;
@property (weak, nonatomic) IBOutlet UIImageView *headPortrait;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumber;

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet UILabel *placeHolderLabel;

@property (weak, nonatomic) IBOutlet UIButton *socialBtn;

@end

static int keyboardHeight;

static BOOL isUserClick;

@implementation SMSosEmergencyViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [self autoDetectionRingVersion];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupContactInfo) name:@"ReloadSettingView" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(resignFirst) name:@"resignFirst" object:nil];
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sosViewkeyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive)
                                                 name:UIApplicationWillResignActiveNotification object:nil];
    [self setupContactInfo];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.textView.scrollEnabled = YES;
    
    self.textView.delegate = self;
    
    self.customSwitch.delegate = self;
    
    [self setupCustomSwitchTagAndDelegate];
    
    [self setupUi];
}

- (void)setupUi{
    
    [SKAttributeString setLabelFontContent2:self.promptLable title:@"IN THE EVENT OF AN EMERGENCY THE BLINQ SMART RING CAN BE TAPPED REPEATEDLY TO SEND OUT AN EMERGENCY SOS MESSAGE." font:Avenir_Light Size:11 spacing:3.3 color:[UIColor whiteColor]];
    
    [SKAttributeString setLabelFontContent:self.emergencyLable title:@"SOS/EMERGENCY MODE" font:Avenir_Book Size:16 spacing:2.46 color:[UIColor whiteColor]];
    
    [SKAttributeString setLabelFontContent:self.sensitivityLabel title:@"LOW SENSITIVITY MODE" font:Avenir_Book Size:16 spacing:2.46 color:[UIColor whiteColor]];
    
    [SKAttributeString setLabelFontContent:self.addContacts title:@"ADD FROM CONTACTS" font:Avenir_Black Size:16 spacing:2.46 color:[UIColor whiteColor]];
    
    [SKAttributeString setLabelFontContent:self.sendTextMessageLabel title:@"SEND TEXT MESSAGE" font:Avenir_Book Size:16 spacing:2.46 color:[UIColor whiteColor]];
    
    [SKAttributeString setLabelFontContent:self.promplabel2 title:@"SEND LOCATION AS SMS (STANDARD CARRIER RATES APPLY) LOCATION SERVICES MUST BE ENABLED FOR BLINQ TO SEND LOCATION." font:Avenir_Light Size:8 spacing:2.4 color:[UIColor whiteColor]];
    
    self.locationSwitch.transform = CGAffineTransformMakeScale(0.7, 0.7);
    
    [SKAttributeString setLabelFontContent:self.socialLabel title:@"SOCIAL S.O.S." font:Avenir_Book Size:16 spacing:2.46 color:[UIColor whiteColor]];
    
    [SKAttributeString setLabelFontContent:self.placeHolderLabel title:@"ENTER SOS MESSAGE HERE…" font:Avenir_Light Size:10 spacing:2.4 color:[UIColor blackColor]];
    
    [SKAttributeString setButtonFontContent:self.socialBtn title:@"SOCIAL S.O.S. SETTINGS" font:Avenir_Heavy Size:12 spacing:3.6 color:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)setupContactInfo{
    
    // 进入界面前先判断是否保存有值，如果有的话-隐藏添加视图（addContact）并显示联系人视图
    BOOL emergencyPower = [SKUserDefaults boolForKey:@"emergencyPower"];
    
    BOOL sendMessagePower = [SKUserDefaults boolForKey:@"sendMessagePower"];
    
    BOOL locationPower = [SKUserDefaults boolForKey:@"locationPower"];
    
    BOOL socialPower = [SKUserDefaults boolForKey:@"socialPower"];
    
    BOOL sensitivityPower = [SKUserDefaults boolForKey:@"sensitivityPower"];
    
    SMContactModel *contact = [[SMSosContactTool contacts]lastObject];
    
    if (contact) {
        
        NSLog(@"有紧急联系人");
        [self setupSosContactInfo:contact];
        
        // 隐藏添加视图
        self.addContact.hidden = YES;
        // 显示联系人视图
        self.contactView.hidden = NO;
        
        [self.customSwitch setOn:emergencyPower];
        
        [self.sendMessageSwitch setOn:sendMessagePower];
        
        [self.locationSwitch setOn:locationPower];
        
        [self.socialSOSSwitch setOn:socialPower];
        
        [self.sensitivitySwitch setOn:sensitivityPower];
        
        [self setupText];
        
        //[self isOpenDescription];
        
    }else{
        NSLog(@"没有紧急联系人");
        // 显示添加视图
        self.addContact.hidden = NO;
        //隐藏联系人视图
        self.contactView.hidden = YES;
        
        if (openStartup == sosDescriptionOpened) {
            [self.customSwitch setOn:NO];
        }
        
        //[SKUserDefaults setBool:NO forKey:@"emergencyPower"];
        [SMMessageManager emergencyPower:NO];
    }

}

// 设置自定义switch的tag值及代理
- (void)setupCustomSwitchTagAndDelegate{
    
    self.customSwitch.tag = 1;
    self.sendMessageSwitch.tag = 2;
    self.locationSwitch.tag = 3;
    self.socialSOSSwitch.tag = 4;
    self.sensitivitySwitch.tag = 5;
    
    self.customSwitch.delegate = self;
    self.sendMessageSwitch.delegate = self;
    self.locationSwitch.delegate = self;
    self.socialSOSSwitch.delegate = self;
    self.sensitivitySwitch.delegate = self;
    
}

#pragma mark - 自定义Switch的代理方法
-(void)clickSwitch:(customSwitch *)Switch withBOOL:(BOOL)isOn{
    
    NSLog(@"---switch--%ld",Switch.tag);
    switch (Switch.tag) {
        case 1:// 响应紧急联系人的开关按钮
        {
            [SMMessageManager emergencyPower:isOn];
            [SKUserDefaults setBool:NO forKey:@"addContactBtn"];
            BOOL sosVcTurnedOn = [SKUserDefaults boolForKey:@"sosVcTurnedOn"];
            if (isOn == YES && sosVcTurnedOn == NO) {
                
                openStartup = sosDescriptionOpening;
                
                SMSosDescriptionViewController *description = [[SMSosDescriptionViewController alloc]initWithNibName:@"SMSosDescriptionViewController" bundle:nil];
                
                description.bottomButtonTitle = @"NEXT";
                
                [SKViewTransitionManager presentModalViewControllerFrom:self to:description duration:0.3 transitionType:TransitionPush directionType:TransitionFromRight];
                
                description.returnBlock = ^(){

                    // 判断是否保存有联系人信息
                    SMContactModel *contact = [[SMSosContactTool contacts]lastObject];
                    if (!contact) {
                        //[self goContactSelectVc];
                        [self performSelector:@selector(goContactSelectVc) withObject:nil afterDelay:0.1];
                    }
          
                };
            }else if (isOn == YES && sosVcTurnedOn == YES){
                // 判断是否保存有联系人信息
                SMContactModel *contact = [[SMSosContactTool contacts]lastObject];
                if (!contact) {
                    [self goContactSelectVc];
                }
            }
        }
            break;
        case 2:// 响应发送信息的开关按钮
            NSLog(@"信息发送开关按钮为%@",isOn?@"YES":@"NO");
            [SKUserDefaults setBool:isOn forKey:@"sendMessagePower"];
            [SKUserDefaults synchronize];
            break;
        case 3:// 响应定位的开关按钮
            NSLog(@"定位开关按钮为%@",isOn?@"YES":@"NO");
            [SKUserDefaults setBool:isOn forKey:@"locationPower"];
            [SKUserDefaults synchronize];
            break;
        case 4:// 响应social的开关按钮
        {

            
            BOOL socialTurnedOn = [SKUserDefaults boolForKey:@"socialTurnedOn"];
            
            if (isOn == YES && socialTurnedOn == NO) {
                SMSocialDescriptionViewController *description = [[SMSocialDescriptionViewController alloc]initWithNibName:@"SMSocialDescriptionViewController" bundle:nil];
            [self.navigationController pushViewController:description animated:YES];
            }else{
            
            }
            
            NSLog(@"social开关按钮为%@",isOn?@"YES":@"NO");
            [SKUserDefaults setBool:isOn forKey:@"socialPower"];
            [SKUserDefaults synchronize];
        }
            break;
            
        case 5:// 响应灵敏度开关
        {
            
            [SKUserDefaults setBool:isOn forKey:@"sensitivityPower"];
            [SKUserDefaults synchronize];
            
            SOSLevel level;
            
            if (isOn) {
                level.Count = 20;
                level.DPercent = 16.0/20;
                level.TLimit = 500;
                level.TWindow = 0;
            }else{
                level.Count = 10;
                level.DPercent = 8.0/10;
                level.TLimit = 500;
                level.TWindow = 0;
            }
            
            [[SMSOSCheckAlgorithmService sharedSMSOSCheckAlgorithmService] setLevel:level];
            
            BOOL sensitivityTurnedOn = [SKUserDefaults boolForKey:@"sensitivityTurnedOn"];
            
            if (isOn == YES && sensitivityTurnedOn == NO) {
                SMSensitivityDescriptionViewController *sensitivity = [[SMSensitivityDescriptionViewController alloc]initWithNibName:@"SMSensitivityDescriptionViewController" bundle:nil];
                
                [self.navigationController pushViewController:sensitivity animated:YES];
            }
            

        }
            break;
        default:
            break;
    }
    
}

// 配置之前保存的联系人信息
- (void)setupSosContactInfo:(SMContactModel*)info{
    
    [SKAttributeString setLabelFontContent:self.name title:[info.name uppercaseString] font:Avenir_Heavy Size:14 spacing:2.1 color:[UIColor whiteColor]];
    
    NSString *phoneNumber = [NSString stringWithFormat:@"+%@%@",info.countryCode,info.phoneNum];
    
    [SKAttributeString setLabelFontContent:self.phoneNumber title:phoneNumber font:Avenir_Heavy Size:16 spacing:2.1 color:[UIColor whiteColor]];
    
    self.headPortrait.image = [UIImage imageWithData:info.photo];
    
    if (!self.headPortrait.image) {
        self.headPortrait.image = [UIImage imageNamed:@"headImage"];
    }
    
    self.headPortrait.layer.cornerRadius = self.headPortrait.frame.size.width / 2;
    
    self.headPortrait.clipsToBounds = YES;
}
- (IBAction)goSocialVc:(id)sender {
    
    SMSocialViewController *social = [[SMSocialViewController alloc]initWithNibName:@"SMSocialViewController" bundle:nil];
    [self.navigationController pushViewController:social animated:YES];
    
}

- (void)goContactSelectVc{
 
    // 1.创建选择联系人的控制器
    CNContactPickerViewController *contactVc = [[CNContactPickerViewController alloc] init];
    
//    [[UINavigationBar appearance] setTranslucent:NO];
//    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
//    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
//                                                           [UIColor blackColor], NSForegroundColorAttributeName,nil]];
    
    // 2.设置代理
    contactVc.delegate = self;
    
    contactVc.displayedPropertyKeys = @[CNContactPhoneNumbersKey];
    
    
    // 设置导航栏title的显示效果
    NSDictionary *TitleDict = @{NSForegroundColorAttributeName:[UIColor blackColor],
                                NSKernAttributeName:@2.46};
    
    [[UINavigationBar appearance]setTitleTextAttributes:TitleDict];
    
    // 3.弹出控制器
    [self presentViewController:contactVc animated:YES completion:nil];
    
    [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.0f];

}

- (void)delayMethod{
    openStartup = sosDescriptionOpened;
}

- (UILabel*)setupNavigationTitle:(NSString *)string{
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0, 200, 44)];
    
    titleLabel.backgroundColor = [UIColor clearColor];
    
    titleLabel.text = string;
    
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    NSRange range = NSMakeRange(0, titleLabel.text.length);
    
    NSMutableAttributedString * attribute = [[NSMutableAttributedString alloc]initWithString:titleLabel.text];
    
    // 设置文字颜色
    [attribute addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:range];
    
    CGFloat floatNum = 2.46f;
    NSNumber *num = [NSNumber numberWithFloat:floatNum];
    
    // 设置文字间距
    [attribute addAttribute:NSKernAttributeName value:num range:range];
    
    titleLabel.attributedText = attribute;
    
    return titleLabel;
}

#pragma mark - <CNContactPickerDelegate>
//// 当选中某一个联系人时会执行该方法
//- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact
//{
//}

// 当选中某一个联系人的某一个属性时会执行该方法
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty
{
    // 1.获取联系人的姓名
    NSString *testName = [NSString stringWithFormat:@"%@%@",contactProperty.contact.familyName,contactProperty.contact.givenName];
    
    if ([self isChinese:testName]) {
        testName = [NSString stringWithFormat:@"%@%@",contactProperty.contact.familyName,contactProperty.contact.givenName];
    }else{
        testName = [NSString stringWithFormat:@"%@ %@",contactProperty.contact.givenName,contactProperty.contact.familyName];
    }
    
//    if ([testName isEqualToString:@""] || [testName isEqualToString:@" "]) {
//        testName = contactProperty.contact.organizationName;
//    }
    
    if ([self isBlankString:testName]) {
        testName = contactProperty.contact.organizationName;
    }
    
    NSLog(@"姓名:(%@)",testName);
    
    self.name.text = testName;
    
    SMContactModel *contact = [[SMContactModel alloc]init];
    
    
    CNPhoneNumber *phoneNumber1 = contactProperty.value;
    NSString *phoneValue = phoneNumber1.stringValue;
    
    NSLog(@"phoneNum%@",phoneValue);
    
    NSArray *array = @[@" ",@"-",@"+86",@"+91",@"+1",@"+852",@"+853",@"+856"];
    
    for (NSString *str in array) {
        phoneValue = [phoneValue stringByReplacingOccurrencesOfString:str withString:@""];
    }

    phoneValue = [[phoneValue componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet]] componentsJoinedByString:@""];
    
    
    if ([self isMobileNumber:phoneValue]) {
        NSLog(@"是中国的号码");

    }else{
        NSLog(@"不是中国的号码");

    }
    
    NSLog(@"选中的号码%@",phoneValue);
    
    self.headPortrait.image = [UIImage imageWithData:contactProperty.contact.imageData];
    
    if (!self.headPortrait.image) {
        self.headPortrait.image = [UIImage imageNamed:@"headImage"];
    }
    
    self.headPortrait.layer.cornerRadius = self.headPortrait.frame.size.width / 2;
    
    self.headPortrait.clipsToBounds = YES;
    
    NSDictionary *defaultCountry = [SKUserDefaults objectForKey:@"defaultCountry"];

    contact.name = testName;
    contact.phoneNum = phoneValue;
    contact.photo = contactProperty.contact.imageData;
    
    if (defaultCountry) {
        contact.countryCode = defaultCountry[@"defaultCountryCode"];
        contact.countriesName = defaultCountry[@"defaultCountryiesName"];
    }else{
        contact.countryCode = @"1";
        contact.countriesName = @"UNITED STATES";
    }

    [SMMessageManager emergencyPower:YES];
    
    NationalListViewController *national = [[NationalListViewController alloc]initWithNibName:@"NationalListViewController" bundle:nil];
    national.contact = contact;
    [self.navigationController pushViewController:national animated:YES];

}

// 点击了取消按钮会执行该方法
- (void)contactPickerDidCancel:(CNContactPickerViewController *)picker
{
}

// 正则判断手机号码地址格式
- (BOOL)isMobileNumber:(NSString *)mobileNum {
    
    //    电信号段:133/153/180/181/189/177
    //    联通号段:130/131/132/155/156/185/186/145/176
    //    移动号段:134/135/136/137/138/139/150/151/152/157/158/159/182/183/184/187/188/147/178
    //    虚拟运营商:170
    
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[06-8])\\d{8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    
    return [regextestmobile evaluateWithObject:mobileNum];
}


-(BOOL)isChinese:(NSString *)phoneNum
{
    // 只需要不是中文即可
    NSString *regex = @".{0,}[\u4E00-\u9FA5].{0,}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self matches %@",regex];
    BOOL res = [predicate evaluateWithObject:phoneNum];
    if (res == TRUE) {
        //NSLog(@"中文");
        return YES;
    }
    else
    {
        //NSLog(@"英文");
        return NO;
    }
}


- (IBAction)addContact:(id)sender {
    [SKUserDefaults setBool:YES forKey:@"addContactBtn"];
    [SKUserDefaults synchronize];
    [self goContactSelectVc];
}



- (IBAction)modifyButton:(id)sender {
    
    [self goContactSelectVc];
}
- (void)sosViewkeyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    /*
     iphone 6:
     中文
     2014-12-31 11:16:23.643 Demo[686:41289] 键盘高度是  258
     2014-12-31 11:16:23.644 Demo[686:41289] 键盘宽度是  375
     英文
     2014-12-31 11:55:21.417 Demo[1102:58972] 键盘高度是  216
     2014-12-31 11:55:21.417 Demo[1102:58972] 键盘宽度是  375
     
     iphone  6 plus：
     英文：
     2014-12-31 11:31:14.669 Demo[928:50593] 键盘高度是  226
     2014-12-31 11:31:14.669 Demo[928:50593] 键盘宽度是  414
     中文：
     2015-01-07 09:22:49.438 Demo[622:14908] 键盘高度是  271
     2015-01-07 09:22:49.439 Demo[622:14908] 键盘宽度是  414
     
     iphone 5 :
     2014-12-31 11:19:36.452 Demo[755:43233] 键盘高度是  216
     2014-12-31 11:19:36.452 Demo[755:43233] 键盘宽度是  320
     
     ipad Air：
     2014-12-31 11:28:32.178 Demo[851:48085] 键盘高度是  264
     2014-12-31 11:28:32.178 Demo[851:48085] 键盘宽度是  768
     
     ipad2 ：
     2014-12-31 11:33:57.258 Demo[1014:53043] 键盘高度是  264
     2014-12-31 11:33:57.258 Demo[1014:53043] 键盘宽度是  768
     */
    
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
        
        CGFloat offset = self.view.frame.size.height - (textHeight + keyboardHeight+100);
        
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
        frame.origin.y = 0.0;
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
    NSString *string = [[NSUserDefaults standardUserDefaults]objectForKey:@"sosTextMessage"];
    
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
        [sosTextMessage setObject:textView.text forKey:@"sosTextMessage"];
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
    [self.textView resignFirstResponder];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)resignFirst{
    [self.textView resignFirstResponder];
}

@end
