//
//  SMHistoryPage.m
//  Blinq
//
//  Created by zsk on 2017/8/8.
//  Copyright © 2017年 zsk. All rights reserved.
//

#import "SMHistoryPage.h"
#import "SMMonthView.h"
#import "SMStepDB.h"
#import "SMViewSelectButton.h"
#import "SMStepSettingPage.h"
#import "SMStepsInfoManager.h"
#import "MBProgressHUD.h"

@interface SMHistoryPage ()

@property(nonatomic,strong)SMMonthView *monthView;

@property(nonatomic,strong)SMViewSelectButton *stepBtn;

@property(nonatomic,strong)SMViewSelectButton *caloriesBtn;

@property(nonatomic,strong)SMViewSelectButton *distanceBtn;

@property(nonatomic,strong)SMStepsInfoManager *stepManager;

@property(nonatomic,assign)NSInteger yearIndex;

@property(nonatomic,assign)NSInteger monthIndex;

@property(nonatomic,assign)NSInteger totalSteps;

@property(nonatomic,strong)NSMutableArray *monthSteps;
@property (weak, nonatomic) IBOutlet UILabel *totalStepsLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalStepsValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearAndDayLabel;

@property (weak, nonatomic) IBOutlet UILabel *goalsReachedLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceKms;

@property(nonatomic,strong)MBProgressHUD *hud;
@property (weak, nonatomic) IBOutlet UILabel *goalsReachedTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceKmsTextLabel;

@end

@implementation SMHistoryPage

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNavigationController];
    
    [self setStepCounterRightButton];
    
    [self setupUI];

    //[self setupNavigationTitle:NSLocalizedString(@"STEP COUNTER", nil) isHiddenBar:YES];
    
    [self setupData];
    
    [self.stepManager getPedometerPowerState:^(BOOL state) {
        if (state == NO) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:NSLocalizedString(@"step_authorization", nil) preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *settingAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"setting_title", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    
                    [[UIApplication sharedApplication] openURL:url];
                    
                }
            }];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"update_available_page_buttonTitle2", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }];
            
            [alertController addAction:settingAction];
            [alertController addAction:okAction];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }];

    [self.monthView selectComplete:^(SMStepModel *day) {
       
        NSLog(@"%ld-%ld-%ld --%ld--%ld",day.year,(long)day.month,(long)day.day,(long)day.steps,day.targetSteps);
        
        [SKAttributeString setLabelFontContent:self.yearAndDayLabel title:[NSString stringWithFormat:@"%02ld,%ld",day.day,day.year] font:Avenir_Black Size:14 spacing:4 color:[UIColor whiteColor]];

        
        [self.stepBtn setProgressWith:day.steps targetSteps:day.targetSteps animation:NO];
        [self.caloriesBtn setProgressWith:day.steps targetSteps:day.targetSteps animation:NO];
        [self.distanceBtn setProgressWith:day.steps targetSteps:day.targetSteps animation:NO];

        [SKAttributeString setLabelFontContent:self.totalStepsValueLabel title:[NSString stringWithFormat:@"%ld",self.totalSteps] font:Avenir_Heavy Size:14 spacing:4 color:[UIColor whiteColor]];

        
    }];
    
}

- (void)setNavigationController{
    // 设置背景颜色
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    // 设置导航栏半透明
    self.navigationController.navigationBar.translucent = true;
    // 设置导航栏背景图片
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"stepCounter_nav"] forBarMetrics:UIBarMetricsDefault];
    // 设置导航栏阴影图片
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0, 200, 44)];
    
    titleLabel.backgroundColor = [UIColor clearColor];
    
    titleLabel.text = NSLocalizedString(@"step_counter", nil);
    
    
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

- (void)setStepCounterRightButton{
    
    
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0,25, 25)];
    [leftBtn setImage:[UIImage imageNamed:@"history_backBtnImage"] forState:UIControlStateNormal];
    leftBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [leftBtn setContentMode:UIViewContentModeScaleAspectFill];
    [leftBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0 , 0,25, 25)];
    [rightBtn setImage:[UIImage imageNamed:@"editor"] forState:UIControlStateNormal];
    rightBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [rightBtn setContentMode:UIViewContentModeScaleAspectFill];
    [rightBtn addTarget:self action:@selector(goSetting) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
   // self.navigationItem.rightBarButtonItems  = @[rightBtn,historyBtnItem];
    
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    self.navigationItem.rightBarButtonItem = rightBtnItem;
}

- (void)goBack{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)goSetting{
    SMStepSettingPage *setting = [[SMStepSettingPage alloc]initWithNibName:@"SMStepSettingPage" bundle:nil];
    [self.navigationController pushViewController:setting animated:YES];
}

- (void)setupUI{
    
    [SKAttributeString setLabelFontContent:self.totalStepsLabel title:NSLocalizedString(@"total_steps", nil) font:Avenir_Heavy Size:14 spacing:4 color:[UIColor whiteColor]];
    
    //self.stepBtn.isbanUserInteraction = YES;
    self.stepBtn = [[SMViewSelectButton alloc]createWithFrame:CGRectMake(0, 113, 375/3, 180) type:btn_steps event:nil];
    [self.stepBtn setUserInteraction:YES];
    [self.view addSubview:self.stepBtn];
    
    //self.caloriesBtn.isbanUserInteraction = YES;
    self.caloriesBtn = [[SMViewSelectButton alloc]createWithFrame:CGRectMake(self.stepBtn.frame.size.width, 113, 375/3, 180) type:btn_calories event:nil];
    [self.caloriesBtn setUserInteraction:YES];
    [self.view addSubview:self.caloriesBtn];
    
    self.distanceBtn = [[SMViewSelectButton alloc]createWithFrame:CGRectMake(self.stepBtn.frame.size.width*2, 113, 375/3, 180) type:btn_distance event:nil];
    [self.distanceBtn setUserInteraction:YES];
    [self.view addSubview:self.distanceBtn];

    
    self.distanceKms.adjustsFontSizeToFitWidth = YES;
    self.distanceKms.textAlignment = NSTextAlignmentCenter;
    
    self.goalsReachedLabel.adjustsFontSizeToFitWidth = YES;
    self.goalsReachedLabel.textAlignment = NSTextAlignmentCenter;
    
    self.goalsReachedTextLabel.text = NSLocalizedString(@"goals_reached", nil);
    self.distanceKmsTextLabel.text = NSLocalizedString(@"distance_kms", nil);
    self.distanceKmsTextLabel.adjustsFontSizeToFitWidth = YES;
}

- (void)setupData{
    
    NSDateComponents *comp = [self getCurrentDate];
    
    self.yearIndex = comp.year;
    
    self.monthIndex = comp.month;
    
    [self setStepDataWithDate:self.yearIndex month:self.monthIndex];
    
    [SKAttributeString setLabelFontContent:self.monthLabel title:[NSString stringWithFormat:@"%@",[[self getMonthStringWith:self.monthIndex]uppercaseString]] font:Avenir_Book Size:20 spacing:4 color:[UIColor whiteColor]];
    
    [SKAttributeString setLabelFontContent:self.yearAndDayLabel title:[NSString stringWithFormat:@"%02ld,%ld",comp.day,comp.year] font:Avenir_Black Size:14 spacing:4 color:[UIColor whiteColor]];

}

- (void)setStepDataWithDate:(NSInteger)year month:(NSInteger)month{
    
    NSArray *infoArray = [SMStepDB stepInfos];
    
    for (SMStepModel *step in infoArray) {
        NSLog(@"%@_---",step.date);
    }
    
    NSInteger coals = 0;
    
    for (SMStepModel *model in infoArray) {
        
        if (model.year == year && model.month == month) {
            [self.monthSteps addObject:model];
            self.totalSteps += model.steps;
            
            if (model.steps >= model.targetSteps) {
                coals++;
            }
        }
    }
    
    SMStepModel *last = [self.monthView setStepData:self.monthSteps];
    
    [SKAttributeString setLabelFontContent:self.yearAndDayLabel title:[NSString stringWithFormat:@"%02ld,%ld",last.day,last.year] font:Avenir_Black Size:14 spacing:4 color:[UIColor whiteColor]];
    
    [self.stepBtn setProgressWith:last.steps targetSteps:last.targetSteps animation:NO];
    [self.caloriesBtn setProgressWith:last.steps targetSteps:last.targetSteps animation:NO];
    [self.distanceBtn setProgressWith:last.steps targetSteps:last.targetSteps animation:NO];
    
    [SKAttributeString setLabelFontContent:self.totalStepsValueLabel title:[NSString stringWithFormat:@"%ld",self.totalSteps] font:Avenir_Heavy Size:14 spacing:4 color:[UIColor whiteColor]];
    
    
    self.goalsReachedLabel.text = [NSString stringWithFormat:@"%ld",coals];
    self.distanceKms.text = [NSString stringWithFormat:@"%0.1f",self.totalSteps*0.614 / 1000];
    
}

- (NSDateComponents*)getCurrentDate{
    // 获取代表公历的NSCalendar对象
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];

    // 获取当前日期
    NSDate* dt = [NSDate date];
    // 定义一个时间字段的旗标，指定将会获取指定年、月、日、时、分、秒的信息
    unsigned unitFlags = NSCalendarUnitYear |
    NSCalendarUnitMonth |  NSCalendarUnitDay |
    NSCalendarUnitHour |  NSCalendarUnitMinute |
    NSCalendarUnitSecond | NSCalendarUnitWeekday;
    // 获取不同时间字段的信息
    NSDateComponents* comp = [gregorian components: unitFlags
                                          fromDate:dt];

    return comp;
}

- (NSString*)getMonthStringWith:(NSInteger)index{
    
    NSString *string = @"";
    
    switch (index) {
        case 1:
            string = NSLocalizedString(@"January", nil);
            break;
        case 2:
            string = NSLocalizedString(@"February", nil);
            break;
        case 3:
            string = NSLocalizedString(@"March", nil);
            break;
        case 4:
            string = NSLocalizedString(@"April", nil);
            break;
        case 5:
            string = NSLocalizedString(@"May", nil);
            break;
        case 6:
            string = NSLocalizedString(@"June", nil);
            break;
        case 7:
            string = NSLocalizedString(@"July", nil);
            break;
        case 8:
            string = NSLocalizedString(@"August", nil);
            break;
        case 9:
            string = NSLocalizedString(@"September", nil);
            break;
        case 10:
            string = NSLocalizedString(@"October", nil);
            break;
        case 11:
            string = NSLocalizedString(@"November", nil);
            break;
        case 12:
            string = NSLocalizedString(@"December", nil);
            break;
            
        default:
            break;
    }
    
    return string;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    NSMutableArray *array = [NSMutableArray array];
//    
//    for (int i =0; i<30; i++) {
//        SMStepModel *model = [[SMStepModel alloc]init];
//        model.year = 2017;
//        model.month = 7;
//        model.day = i;
//        int y =1000 +  (arc4random() % 3000);
//        model.steps = y;
//        
//        [array addObject:model];
//    }
//    
//    [self.monthView  setStepData:array];
}
- (IBAction)leftButton:(id)sender {
    
    if ([SMBlinqInfo isloadedAllData] == NO && [SMBlinqInfo appleHealthPower] == YES && [SMBlinqInfo stepCounterPower] == YES) {
        [self.monthSteps removeAllObjects];
        [self.stepManager getAllStepDataStart:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                self.hud.mode = MBProgressHUDModeIndeterminate;
                self.hud.label.text = NSLocalizedString(@"Loading", @"HUD loading title");
            });
        } completion:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setupData];
                [SMBlinqInfo setIsloadedAllData:YES];
                [self.hud removeFromSuperview];
            });
        } error:^(NSError *error) {
            
        }];
    }
    
    SMStepModel *one = [[SMStepDB stepInfos]firstObject];
    
    if (self.yearIndex == one.year && self.monthIndex == one.month) {
        return;
    }
    
    if (self.monthIndex == 1) {
        self.monthIndex = 13;
        self.yearIndex--;
        return;
    }
    
    
    self.totalSteps = 0;
    [self.monthSteps removeAllObjects];
    self.monthIndex --;
    [self setStepDataWithDate:self.yearIndex month:self.monthIndex];
    
    [SKAttributeString setLabelFontContent:self.monthLabel title:[NSString stringWithFormat:@"%@",[[self getMonthStringWith:self.monthIndex]uppercaseString]] font:Avenir_Book Size:20 spacing:4 color:[UIColor whiteColor]];

    
    [SKAttributeString setLabelFontContent:self.totalStepsValueLabel title:[NSString stringWithFormat:@"%ld",self.totalSteps] font:Avenir_Heavy Size:14 spacing:4 color:[UIColor whiteColor]];
}

- (IBAction)rightButton:(id)sender {
    
    SMStepModel *one = [[SMStepDB stepInfos]lastObject];
    
    if (self.yearIndex == one.year && self.monthIndex == one.month) {
        return;
    }
    
    if (self.monthIndex == 12) {
        self.monthIndex = 0;
        self.yearIndex++;
        return;
    }
    
    self.totalSteps = 0;
    [self.monthSteps removeAllObjects];
    self.monthIndex ++;
    
    [self setStepDataWithDate:self.yearIndex month:self.monthIndex];
    
    [SKAttributeString setLabelFontContent:self.monthLabel title:[NSString stringWithFormat:@"%@",[[self getMonthStringWith:self.monthIndex]uppercaseString]] font:Avenir_Book Size:20 spacing:4 color:[UIColor whiteColor]];
    
    
    [SKAttributeString setLabelFontContent:self.totalStepsValueLabel title:[NSString stringWithFormat:@"%ld",self.totalSteps] font:Avenir_Heavy Size:14 spacing:4 color:[UIColor whiteColor]];

    
}

#pragma mark - 懒加载

- (SMStepsInfoManager *)stepManager{
    if (!_stepManager) {
        _stepManager = [[SMStepsInfoManager alloc]init];
    }
    return _stepManager;
}

- (NSMutableArray *)monthSteps{
    if (!_monthSteps) {
        _monthSteps = [NSMutableArray array];
    }
    return _monthSteps;
}

- (SMMonthView *)monthView{
    if (!_monthView) {
        self.monthView = [[SMMonthView alloc]initMonthViewWithFrame:CGRectMake(18, 293, 339, 120)];
        [self.view addSubview:self.monthView];
    }
    return _monthView;
}

@end
