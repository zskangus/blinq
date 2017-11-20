//
//  SMStepSettingPage.m
//  Blinq
//
//  Created by zsk on 2017/8/2.
//  Copyright © 2017年 zsk. All rights reserved.
//

#import "SMStepSettingPage.h"
#import "SKAttributeString.h"
#import "SMStepTableViewCell.h"
#import "SKPickerView.h"
#import "SMStepDB.h"
//#import "SMHealthmanager.h"
#import "SMStepsInfoManager.h"
#import "MBProgressHUD.h"

@interface SMStepSettingPage ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (strong, nonatomic) IBOutlet UITableViewCell *counterCell;

@property(nonatomic,strong)SKPickerView *agePicker;

@property(nonatomic,strong)SKPickerView *heightPicker;

@property(nonatomic,strong)SKPickerView *weightPicker;

@property(nonatomic,strong)SMPersonalModel *userInfo;

@property(nonatomic,strong)SMStepsInfoManager *health;

@property(nonatomic,strong)MBProgressHUD *hud;

@property(nonatomic,strong)NSMutableArray *heightArray;

@property(nonatomic,strong)NSMutableArray *weightArray;

@end

@implementation SMStepSettingPage

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.userInfo = [SMBlinqInfo userInfo];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(someMethod)
//                                                 name:UIApplicationDidBecomeActiveNotification object:nil];

    if ([SMBlinqInfo isHaveHealthAuthorized] == NO) {
        
        [self.health getSevenSteps:^{
            
            [SMBlinqInfo setStepCounterPower:YES];
            [self.tableView reloadData];
            
        } error:^(NSError *error) {
            [SMBlinqInfo setStepCounterPower:NO];
            [self.tableView reloadData];
            
        }];
        
        [SMBlinqInfo setisHaveHealthAuthorized:YES];

        [self.health authorizeHealthKit:^(BOOL success, NSError *error) {
            
            [self.health getHealthPowerState:^(BOOL power) {
                [SMBlinqInfo setAppleHealthPower:power];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            }];
        }];
        
        
        

        
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setTableView];
    
    [self createPickerListData];
    
    [self setUI];
    
    [self setupNavigationTitle:NSLocalizedString(@"step_settings", nil) isHiddenBar:YES];
}

- (void)setTableView{
    
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    
    // 隐藏Cell的分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 隐藏滚动条
    self.tableView.showsVerticalScrollIndicator = NO;
    
    // 不可滚动
    self.tableView.scrollEnabled = NO;
        
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)setUI{
    

    
//    [SKAttributeString setButtonFontContent:self.doneButton title:NSLocalizedString(@"socicl_page_done", nil) font:Avenir_Light Size:20 spacing:3 color:[UIColor whiteColor] forState:UIControlStateNormal];
//    
//    self.agePicker = [[SKPickerView alloc]initPickerViewWithFrame:CGRectMake(0, 0, 375, 667) title:@"AGE" list:@[@"23",@"24",@"25",@"26",@"27"]];
    
    __weak typeof(self)blockself = self;
    
    self.agePicker = [[SKPickerView alloc]initDatePickerViewWithFrame:[self getScreenSize] title:NSLocalizedString(@"age", nil)];
    
    self.agePicker.getSelectDate = ^(NSString *dateStr) {
        NSLog(@"%@",dateStr);
        //计算年龄
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        //生日
        NSDate *birthDay = [dateFormatter dateFromString:dateStr];
        //当前时间
        NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
        NSDate *currentDate = [dateFormatter dateFromString:currentDateStr];
        NSLog(@"currentDate %@ birthDay %@",currentDateStr,dateStr);
        NSTimeInterval time=[currentDate timeIntervalSinceDate:birthDay];
        int age = ((int)time)/(3600*24*365);
        
        
        blockself.userInfo.age = age;
        blockself.userInfo.birthday = dateStr;
        [SMBlinqInfo setUserInfo:blockself.userInfo];
        [blockself.tableView reloadData];
    };


    
    self.heightPicker = [[SKPickerView alloc]initPickerViewWithFrame:[self getScreenSize] title:NSLocalizedString(@"height", nil) list:self.heightArray];
    
    self.heightPicker.returnsResult = ^(NSDictionary *content, NSInteger row, NSInteger component) {
        blockself.userInfo.heightDic = content;
        blockself.userInfo.heightRow = row;
        blockself.userInfo.heightComponent = component;
        [SMBlinqInfo setUserInfo:blockself.userInfo];
        [blockself.tableView reloadData];
    };
    
    self.weightPicker = [[SKPickerView alloc]initPickerViewWithFrame:[self getScreenSize] title:NSLocalizedString(@"weight", nil) list:self.weightArray];

    self.weightPicker.returnsResult = ^(NSDictionary *content, NSInteger row, NSInteger component) {
        blockself.userInfo.weight = [content[@"usaUnit"]doubleValue];
        blockself.userInfo.weightDic = content;
        blockself.userInfo.weightRow = row;
        blockself.userInfo.weightComponent = component;
        [SMBlinqInfo setUserInfo:blockself.userInfo];
        [blockself.tableView reloadData];
    };
    

    
    // 设置身高体重的单位
    if ([NSLocalizedString(@"language", nil)isEqualToString:@"English"]){
        self.heightPicker.unit = @"";
        
        self.weightPicker.unit = @"LBS";
    }else{
        self.heightPicker.unit = @"CM";
        
        self.weightPicker.unit = @"KG";
    }

    [SKAttributeString setButtonFontContent:self.doneButton title:NSLocalizedString(@"socicl_page_done", nil) font:Avenir_Heavy Size:15 spacing:3.6 color:[UIColor whiteColor] forState:UIControlStateNormal];

}

- (void)createPickerListData{

    NSMutableArray *usaheight = [NSMutableArray array];
    
    NSMutableArray *usarweight = [NSMutableArray array];
    
    NSMutableArray *ontherheight = [NSMutableArray array];
    
    NSMutableArray *ontherweight = [NSMutableArray array];
    
    NSMutableArray *HFilterArray = [NSMutableArray array];
    
    NSMutableArray *WFilterArray = [NSMutableArray array];

    
    double heightValue = 30;
    double weightValue = 30;
    
    for (int i = 0 ; i<200; i++) {
        heightValue++;
        weightValue++;
        
        NSInteger us = (NSInteger)round(heightValue / 2.54);
        NSInteger inches = us % (12);
        NSInteger feet = us /12;
        
        NSInteger kg = weightValue * 0.4532;
        
        // 厘米
        NSString *cmString = [NSString stringWithFormat:@"%d",(int)heightValue];
        
        // 英寸
        NSString *inchesString = [NSString stringWithFormat:@"%ld'%ld\"",(long)feet,(long)inches];
        
        // LBS
        NSString *lbsString = [NSString stringWithFormat:@"%d",(int)weightValue];
        
        // KG
        NSString *kgString = [NSString stringWithFormat:@"%ld",(long)kg];
        
        
        [usaheight addObject:inchesString];
        
        [usarweight addObject:lbsString];
        
        [ontherheight addObject:cmString];
        
        [ontherweight addObject:kgString];
        
    }
    
    NSLog(@"美国--身高:%@  体重:%@   其他--升高:%@  体重:%@",usaheight,ontherheight,usarweight,ontherweight);
    
    
    if ([NSLocalizedString(@"language", nil)isEqualToString:@"English"]){
        
        // 删除身高中的相同对象
        for (unsigned i = 0; i < [usaheight count]; i++){
            if ([HFilterArray containsObject:[usaheight objectAtIndex:i]] == NO){
                [HFilterArray addObject:[usaheight objectAtIndex:i]];
                
                NSDictionary *dic = @{@"usaUnit":usaheight[i],@"otherUnit":ontherheight[i]};
                
                [self.heightArray addObject:dic];
        }
        }
        
        for (unsigned p = 0; p < [usarweight count]; p++) {
            NSDictionary *dic = @{@"usaUnit":usarweight[p],@"otherUnit":ontherweight[p]};
            
            [self.weightArray addObject:dic];
        }
        
        
    }else{
        
        // 删除体重中的相同对象
        for (unsigned i = 0; i < [usarweight count]; i++){
            if ([WFilterArray containsObject:[usarweight objectAtIndex:i]] == NO){
                [WFilterArray addObject:[usarweight objectAtIndex:i]];
                
                NSDictionary *dic = @{@"usaUnit":usarweight[i],@"otherUnit":ontherweight[i]};
                
                [self.weightArray addObject:dic];
            }
        }
        
        for (unsigned p = 0; p < [usaheight count]; p++) {
            NSDictionary *dic = @{@"usaUnit":usaheight[p],@"otherUnit":ontherheight[p]};
            
            [self.heightArray addObject:dic];
        }
        
    }
    NSLog(@"%@-----%@",self.heightArray,self.weightArray);
}

- (void)dateChange:(id)datePicker {
    
}

- (void)setupNavigationTitle:(NSString *)string isHiddenBar:(BOOL)hidden{
    
    if (hidden == NO) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg-navBar"] forBarMetrics:UIBarMetricsDefault];
    }else{
        // 设置背景颜色
        [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
        // 设置导航栏半透明
        self.navigationController.navigationBar.translucent = true;
        // 设置导航栏背景图片
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        // 设置导航栏阴影图片
        self.navigationController.navigationBar.shadowImage = [UIImage new];
    }
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0, 200, 44)];
    
    titleLabel.backgroundColor = [UIColor clearColor];
    
    titleLabel.text = string;
    
    if (![string isEqualToString:@"CONTACT NOTIFICATIONS"]) {
        titleLabel.font = [UIFont fontWithName: @"Avenir-Book" size:16];
    }else{
        
        if (self.view.frame.size.width == 320) {
            titleLabel.font = [UIFont fontWithName: @"Avenir-Book" size:12];
        }else{
            titleLabel.font = [UIFont fontWithName: @"Avenir-Book" size:15];
        }
        
        
        NSLog(@"pingmukuandu%@",NSStringFromCGRect(self.view.frame));
    }
    
    if ([string isEqualToString:@"APP-BENACHRICHTIGUNGEN"]) {
        titleLabel.font = [UIFont fontWithName: @"Avenir-Book" size:14];
    }
    
    if ([string isEqualToString:@"KONTAKT-BENACHRICHTIGUNGEN"]) {
        titleLabel.font = [UIFont fontWithName: @"Avenir-Book" size:11];
    }
    
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
- (IBAction)doneAction:(id)sender {
    [SMBlinqInfo setIsFirstTimeInStepPage:NO];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 6;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    SMStepTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SMStepTableViewCell"];
//    
//    cell.titleLabel.text = @"asdasd";
    
    SMStepTableViewCell *cell = [SMStepTableViewCell stepTableViewCellWith:tableView indexPath:indexPath];
    [cell configStepCellWith:indexPath];
    
    [cell buttonAction:^{
        [self.tableView reloadData];
    }];
    
    [cell switchAction:^(NSInteger tag, BOOL power) {
        switch (tag) {
            case 1:
            {
                [SMBlinqInfo setStepCounterPower:power];
                
                if (power == YES) {
                    
                    [self.health getSevenSteps:^{
                        if ([SMBlinqInfo isHaveHealthAuthorized] == NO) {
                            [SMBlinqInfo setisHaveHealthAuthorized:YES];
                        }
                    } error:^(NSError *error) {
                        [SMBlinqInfo setStepCounterPower:NO];
                        
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:NSLocalizedString(@"step_authorization", nil) preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction *settingAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"setting_title", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                            
                            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                                
                                [[UIApplication sharedApplication] openURL:url];
                                
                            }
                        }];
                        
                        UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"update_available_page_buttonTitle2", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            [self.tableView reloadData];
                        }];
                        
                        [alertController addAction:settingAction];
                        [alertController addAction:okAction];
                        
                        [self presentViewController:alertController animated:YES completion:nil];
                    }];
                    
//                    [self.health getSteps:^(SMStepModel *stepInfo) {
//
//                        
//                    } error:^(NSError *error) {
//
//
//                    }];
                }
            }
                break;
            case 2:
            {
                [SMBlinqInfo setAppleHealthPower:power];
                
                if (power == YES) {
                    
                    [self.health authorizeHealthKit:^(BOOL success, NSError *error) {
                        
                    }];
                    
//                    if ([SMBlinqInfo isHaveHealthAuthorized] == NO) {
//                        [SMBlinqInfo setisHaveHealthAuthorized:YES];
//                    }
//                    [self.health setupAllHealthData:^{
//
//                        dispatch_async(dispatch_get_main_queue(), ^{
//                            [self.hud removeFromSuperview];
//                        });
//                    } error:^(NSError *error) {
//                        
//                    }];
//                    
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
//                        
//                        self.hud.mode = MBProgressHUDModeIndeterminate;
//                        self.hud.label.text = NSLocalizedString(@"Loading...", @"HUD loading title");
//                    });
                }
                

            }
                break;
                
            default:
                break;
        }
        
    }];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSLog(@"%ld--",(long)indexPath.row);
    
    SMPersonalModel *user = [SMBlinqInfo userInfo];
    
    if (indexPath.row == 3) {
        
        if (![self isBlankString:user.birthday]) {
            [self.agePicker setSelectDate:user.birthday];
        }
        [self.agePicker pushPickerView];
    }
    

    NSInteger heightRow = [self.heightArray indexOfObject:user.heightDic];
    
    NSInteger weightRow = [self.weightArray indexOfObject:user.weightDic];
    
    
    if (indexPath.row == 4) {
        [self.heightPicker selectRow:heightRow inComponent:user.heightComponent animated:NO];
        [self.heightPicker pushPickerView];
    }
    if (indexPath.row == 5) {
        [self.weightPicker selectRow:weightRow inComponent:user.weightComponent animated:NO];
        [self.weightPicker pushPickerView];
    }
    
    

}

- (NSMutableArray *)heightArray{
    if (!_heightArray) {
        _heightArray = [NSMutableArray array];
    }
    return _heightArray;
}

- (NSMutableArray *)weightArray{
    if (!_weightArray) {
        _weightArray = [NSMutableArray array];
    }
    return _weightArray;
}

// 设置行的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 2) {
        return 175;
    }else{
        return 50;
        
    }
}

                
- (SMStepsInfoManager *)health{
    if (!_health) {
        _health = [[SMStepsInfoManager alloc]init];
    }
    return _health;
}

@end
