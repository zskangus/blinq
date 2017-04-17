//
//  NationalListViewController.m
//  Blinq
//
//  Created by zsk on 16/9/28.
//  Copyright © 2016年 zsk. All rights reserved.
//

#import "NationalListViewController.h"
#import "countriesModel.h"
#import "countriesCell.h"
#import "SMSosDescriptionViewController.h"


#import "SMSosContactTool.h"

@interface NationalListViewController ()<UITableViewDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *currentCountres;
@property (weak, nonatomic) IBOutlet UILabel *currentCountryCode;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;

@property (weak, nonatomic) IBOutlet UITextField *phoneNumberField;

@property (strong, nonatomic)UILabel *areaCode;
@property(strong,nonatomic)UIView *lineView;
@property(strong,nonatomic)UITextField *phoneNumber;
@property(strong,nonatomic)NSString *temporaryNumber;
@property (weak, nonatomic) IBOutlet UIView *editView;


@property(nonatomic,strong)NSArray *countresList;

@end

static NSString * const CountriesCell = @"countriesCell";

@implementation NationalListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.countresList = [NSArray arrayWithArray:[self setupCountresData]];
    
    [self.tableView registerNib:[UINib nibWithNibName:CountriesCell bundle:nil] forCellReuseIdentifier:@"countriesCell"];
    
    [self setupPhoneNumberAndCurrentCountresLabel];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg-navBarNil"] forBarMetrics:UIBarMetricsDefault];
    
    
    self.navigationItem.title = @"YOUR COUNTRY";
    
    //[self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    
//    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
//    
//    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    
    self.navigationController.navigationBar.translucent = NO;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor blackColor], NSForegroundColorAttributeName,nil]];
    
}

- (void)setupPhoneNumberAndCurrentCountresLabel{
    
    if (([self.contact.countriesName isEqualToString:@"UNITED STATES"] && [[self.contact.phoneNum substringToIndex:1] isEqualToString:@"1"])
        ||
        ([self.contact.countriesName isEqualToString:@"CANADA"] && [[self.contact.phoneNum substringToIndex:1] isEqualToString:@"1"])) {
        
        [self setupAreaCode:[NSString stringWithFormat:@"+%@",self.contact.countryCode]];
        
        NSString *str = [self.contact.phoneNum substringFromIndex:1];
        
        [self setupCellNumber:str];
        
        self.currentCountres.text = self.contact.countriesName;
        self.currentCountryCode.text = self.contact.countryCode;

    }else{
        [self setupAreaCode:[NSString stringWithFormat:@"+%@",self.contact.countryCode]];
        [self setupCellNumber:self.contact.phoneNum];
        
        self.currentCountres.text = self.contact.countriesName;
        self.currentCountryCode.text = self.contact.countryCode;
    }
    
}

- (NSMutableArray*)setupCountresData{
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"countresList2.plist" ofType:nil];

    //加载数组
    NSArray *dicArray=[NSArray arrayWithContentsOfFile:path];
    
    //将dicArray里面的所有字典转成模型对象，放到新的数组中。
    NSMutableArray *countresList=[NSMutableArray array];
    for (NSDictionary *dict in dicArray) {
        
        countriesModel *countries = [[countriesModel alloc]init];
        
        countries.countriesName = dict[@"Name"];
        
        countries.countriesNumBer = dict[@"Number"];
        
        countries.countryCode = dict[@"CountryCode"];
        
        [countresList addObject:countries];
    }
    
    return countresList;
}

- (IBAction)editBtn:(id)sender {
    
    if (![self isBlankString:self.temporaryNumber]) {
        self.contact.phoneNum = self.temporaryNumber;
    }
    
    
    NSString *message = [[NSString alloc]init];
    
    if (([self.currentCountres.text isEqualToString:@"UNITED STATES"] && [[self.contact.phoneNum substringToIndex:1] isEqualToString:@"1"])
        ||
        ([self.currentCountres.text isEqualToString:@"CANADA"] && [[self.contact.phoneNum substringToIndex:1] isEqualToString:@"1"])) {
        
        message = [NSString stringWithFormat:@"+%@ %@",[self.currentCountryCode.text stringByReplacingOccurrencesOfString:@"+" withString:@""],[self.contact.phoneNum substringFromIndex:1]];
        
    }else{
        message = [NSString stringWithFormat:@"+%@ %@",[self.currentCountryCode.text stringByReplacingOccurrencesOfString:@"+" withString:@""],self.contact.phoneNum];
    }
    
    NSMutableAttributedString *alertControllerMessage = [[NSMutableAttributedString alloc] initWithString:message];
    [alertControllerMessage addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, message.length)];


    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"CONFIRM MOBILE NUMBER" message:message preferredStyle:UIAlertControllerStyleAlert];
    
        [alertController setValue:alertControllerMessage forKey:@"attributedMessage"];

    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [SKUserDefaults setBool:YES forKey:@"sosVcTurnedOn"];
        
        //先删除旧数据
        [SMSosContactTool deleteContactData];
        
        if (([self.currentCountres.text isEqualToString:@"UNITED STATES"] && [[self.contact.phoneNum substringToIndex:1] isEqualToString:@"1"])
            ||
            ([self.currentCountres.text isEqualToString:@"CANADA"] && [[self.contact.phoneNum substringToIndex:1] isEqualToString:@"1"])) {
            
            NSLog(@"原本的号码%@",self.contact.phoneNum);
            self.contact.countriesName = self.currentCountres.text;
            self.contact.countryCode = [self.currentCountryCode.text stringByReplacingOccurrencesOfString:@"+" withString:@""];
            
            if (![self isBlankString:self.temporaryNumber]) {
                self.contact.phoneNum = self.temporaryNumber;
            }
        
            self.contact.phoneNum = [self.contact.phoneNum substringFromIndex:1];
    
            NSLog(@"最终保存的号码%@",self.contact.phoneNum);
            [SMSosContactTool addContact:self.contact];
            
        }else{
            
            NSLog(@"原本的号码%@",self.contact.phoneNum);
            self.contact.countriesName = self.currentCountres.text;
            self.contact.countryCode = [self.currentCountryCode.text stringByReplacingOccurrencesOfString:@"+" withString:@""];
            
            if (![self isBlankString:self.temporaryNumber]) {
                self.contact.phoneNum = self.temporaryNumber;
            }
            
            NSLog(@"最终保存的号码%@",self.contact.phoneNum);
            
            [SMSosContactTool addContact:self.contact];
        }
        
        NSLog(@"确定修改的国家名和区号%@,%@",self.contact.countriesName,self.contact.countryCode);
        
        // 更换默认的区号和国家名
        NSMutableDictionary *defaultCountry = [NSMutableDictionary dictionary];
        defaultCountry[@"defaultCountryCode"] = self.contact.countryCode;
        defaultCountry[@"defaultCountryiesName"] = self.contact.countriesName;
        [SKUserDefaults setObject:defaultCountry forKey:@"defaultCountry"];
        
        BOOL isAddContactBtn = [SKUserDefaults boolForKey:@"addContactBtn"];
        
        if (isAddContactBtn) {
            [self isOpenDescription];
        }else{
            
        [self.navigationController popViewControllerAnimated:YES];
            
        }

    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (void)isOpenDescription{
    
    BOOL sosVcAddBtnTurnedOn = [SKUserDefaults boolForKey:@"sosVcAddBtnTurnedOn"];
    if (sosVcAddBtnTurnedOn == NO) {
        
        SMSosDescriptionViewController *description = [[SMSosDescriptionViewController alloc]initWithNibName:@"SMSosDescriptionViewController" bundle:nil];
        
        description.bottomButtonTitle = @"OK";
        
        CATransition * animation = [CATransition animation];
        
        animation.duration = 0.3;    //  时间
        animation.type = kCATransitionPush;
        animation.subtype = kCATransitionFromRight;
        
        [self.view.window.layer addAnimation:animation forKey:nil];
        
        [self presentViewController:description animated:NO completion:nil];
        
        description.returnBlock = ^(){
            [SKUserDefaults setBool:YES forKey:@"sosVcAddBtnTurnedOn"];
            [SKUserDefaults setBool:NO forKey:@"addContactBtn"];
            [self.navigationController popViewControllerAnimated:YES];
        };
    }

}

- (void)setupAreaCode:(NSString*)string{
    
    [self.areaCode removeFromSuperview];
    [self.lineView removeFromSuperview];
    self.areaCode = [[UILabel alloc]init];
    
    self.areaCode.numberOfLines =1;
    
    UIFont * tfont = [UIFont systemFontOfSize:17];
    
    self.areaCode.font = tfont;
    
    self.areaCode.lineBreakMode =NSLineBreakByTruncatingTail;
    
    self.areaCode.text = string;
    //[self.cellName setBackgroundColor:[UIColor redColor]];
    
    
    //高度估计文本大概要显示几行，宽度根据需求自己定义。 MAXFLOAT 可以算出具体要多高
    
    CGSize size =CGSizeMake(300,MAXFLOAT);
    
    // label可设置的最大高度和宽度
    //    CGSize size = CGSizeMake(300.f, MAXFLOAT);
    
    //    获取当前文本的属性
    
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:tfont,NSFontAttributeName,nil];
    
    //ios7方法，获取文本需要的size，限制宽度
    
    CGSize nameSize =[string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin  attributes:tdic context:nil].size;
    
    // ios7之前使用方法获取文本需要的size，7.0已弃用下面的方法。此方法要求font，与breakmode与之前设置的完全一致
    //    CGSize actualsize = [tstring sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
    //   更新UILabel的frame
    
    
    self.areaCode.frame =CGRectMake(15,11,nameSize.width, nameSize.height);
    
    NSLog(@"%@",NSStringFromCGRect(self.areaCode.frame));
    
    [self.editView addSubview:self.areaCode];
    
    self.lineView = [[UIView alloc]initWithFrame:CGRectMake(self.areaCode.frame.origin.x + self.areaCode.frame.size.width + 5, 14, 1.5, 17)];
    self.lineView.backgroundColor = RGB_COLOR(168, 168, 168);
    [self.editView addSubview:self.lineView];
    
}

- (void)setupCellNumber:(NSString *)string{
    
    [self.phoneNumber removeFromSuperview];
    self.phoneNumber = [[UITextField alloc]init];
    
    UIFont * tfont = [UIFont systemFontOfSize:17];
    
    self.phoneNumber.font = tfont;
    
    self.phoneNumber.text = string;
    
    self.phoneNumber.textAlignment = NSTextAlignmentLeft;
    
    //[self.phoneNumber setBackgroundColor:[UIColor redColor]];
    
    CGPoint point = CGPointMake(self.lineView.frame.origin.x + self.lineView.frame.size.width + 5, 11);
    
    //    CGFloat width = self.view.frame.size.width - point.x - 70;
    //
    //    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:tfont,NSFontAttributeName,nil];
    //
    //    //ios7方法，获取文本需要的size，限制宽度
    //
    //    CGSize size =CGSizeMake(300,MAXFLOAT);
    //
    //    CGSize Size =[string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin  attributes:tdic context:nil].size;
    //
    //    self.phoneNumber.frame =CGRectMake(point.x,point.y,Size.width,21);
    
    //    if (self.phoneNumber.frame.size.width > width) {
    self.phoneNumber.frame =CGRectMake(point.x,point.y,320 - point.x -70,21);
    //    }
    
    NSLog(@"[%@]",NSStringFromCGRect(self.phoneNumber.frame));
    
    self.phoneNumber.keyboardType = UIKeyboardTypePhonePad;
    
    [self.phoneNumber addTarget:self action:@selector(phoneNumberDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self.editView addSubview:self.phoneNumber];
}

- (void)phoneNumberDidChange:(id) sender {
    
    //self.editBtn.enabled = YES;
    
    UITextField *field = (UITextField *)sender;
    
    NSLog(@"当前输入的%@",field.text);
    self.temporaryNumber = field.text;
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return self.countresList.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //tableView.separatorStyle = NO;
    
    countriesCell *cell = [tableView dequeueReusableCellWithIdentifier:CountriesCell forIndexPath:indexPath];
    
    countriesModel *countries = self.countresList[indexPath.row];
    
    NSString *areaCode = [NSString stringWithFormat:@"+%@",countries.countriesNumBer];
    
    cell.countriesName.text = countries.countriesName;
    cell.areaCode.text = areaCode;
    return cell;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    countriesModel *countries = self.countresList[indexPath.row];
    
    if (([countries.countriesName isEqualToString:@"UNITED STATES"] && [[self.contact.phoneNum substringToIndex:1] isEqualToString:@"1"])
        ||
        ([countries.countriesName isEqualToString:@"CANADA"] && [[self.contact.phoneNum substringToIndex:1] isEqualToString:@"1"])) {
        self.currentCountres.text = countries.countriesName;
        self.currentCountryCode.text = [NSString stringWithFormat:@"+%@",countries.countriesNumBer];
        [self setupAreaCode:[NSString stringWithFormat:@"+%@",countries.countriesNumBer]];
        NSString *string = [self.contact.phoneNum substringFromIndex:1];
        [self setupCellNumber:string];
        
        
        
    }else{
        self.currentCountres.text = countries.countriesName;
        self.currentCountryCode.text = [NSString stringWithFormat:@"+%@",countries.countriesNumBer];
        [self setupAreaCode:[NSString stringWithFormat:@"+%@",countries.countriesNumBer]];
        [self setupCellNumber:self.contact.phoneNum];
    }
    

}


@end
