//
//  SMStepCounterPage.m
//  Blinq
//
//  Created by zsk on 2017/7/31.
//  Copyright © 2017年 zsk. All rights reserved.
//

#import "SMStepCounterPage.h"
#import "SMStepDB.h"
#import "SMStepSettingPage.h"
#import "SMHistoryPage.h"
#import "SMViewSelectButton.h"
#import "SMBlinqInfo.h"
#import "SMProgress.h"
#import "SMStepsInfoManager.h"

typedef NS_ENUM(NSInteger,progressTypes){
    progressType_steps = 0,
    progressType_calories,
    progressType_distance
};

@interface SMStepCounterPage ()

@property(nonatomic,strong)SMStepsInfoManager *stepManager;

@property(nonatomic,strong)SMViewSelectButton *stepBtn;

@property(nonatomic,strong)SMViewSelectButton *caloriesBtn;

@property(nonatomic,strong)SMViewSelectButton *distanceBtn;

@property(nonatomic,strong)SMProgress *progress;

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UIImageView *okImage;

@property (weak, nonatomic) IBOutlet UILabel *goalLabel;
@property (weak, nonatomic) IBOutlet UILabel *stepsLabel;
@property (weak, nonatomic) IBOutlet UILabel *targetStepsLabel;
@property (weak, nonatomic) IBOutlet UILabel *remainderStepsLabel;

@property(nonatomic,assign)double steps;
@property(nonatomic,assign)double targetSteps;

@property(nonatomic)progressTypes progressType;
@property (weak, nonatomic) IBOutlet UILabel *reachedLabel;

@end

@implementation SMStepCounterPage

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [SKNotificationCenter addObserver:self selector:@selector(someMethod) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    if ([SMBlinqInfo isFirstTimeInStepPage] == NO) {
        SMStepsInfoManager *manager = [[SMStepsInfoManager alloc]init];
        [manager getPedometerPowerState:^(BOOL state) {
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
            }else{
                [SMBlinqInfo setStepCounterPower:YES];
            }
        }];
    }
    
    [self setupStepsData];
    
    [self startPedometer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationController];
    
    [self setupNavigationTitle:NSLocalizedString(@"step_counter", nil) isHiddenBar:YES];
    
    [self setStepCounterRightButton];
    
    if ([SMBlinqInfo isFirstTimeEnter]) {
        [self showSettingVcWithAnimated:NO];
        [SMBlinqInfo setIsFirstTimeEnter:NO];
    }
    
    [self setSelectButtonView];
    
    if ([SMBlinqInfo isHaveHealthAuthorized] == NO) {
        self.steps = 0;
        
        self.targetSteps = 0;
        
        [self updateUI:YES];
        
        return;
    }
}

- (void)setupStepsData{
    
    if ([SMBlinqInfo isHaveHealthAuthorized] == NO) {
        self.steps = 0;
        
        self.targetSteps = 0;
        
        [self updateUI:YES];
        
        return;
    }

    if ([SMBlinqInfo stepCounterPower]) {
        
        [self.stepManager getCurrentSteps:^(SMStepModel *step) {
            self.steps = step.steps;
            
            self.targetSteps = step.targetSteps;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self updateUI:YES];
            });
            
        } error:^(NSError *error) {
            [SMBlinqInfo setStepCounterPower:NO];
            
            SMStepModel *step = [SMStepDB stepInfos].lastObject;
            
            self.steps = step.steps;
            
            self.targetSteps = step.targetSteps;
            
            self.progressType = progressType_steps;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self updateUI:YES];
            });
            
            //PLEASE ALLOW BLINQ TO ACCES YOUR NUMBER OF STEPS ,IN“SETTINGS”->”HEALTH”->”STEPS”.
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:NSLocalizedString(@"step_authorization", nil) preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"ok", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alertController addAction:okAction];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }];
    }else{
        SMStepModel *step = [SMStepDB stepInfos].lastObject;
        
        self.steps = step.steps;
        
        self.targetSteps = step.targetSteps;
        
        self.progressType = progressType_steps;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateUI:YES];
        });
        
    }
}

- (void)startPedometer{
    if ([SMBlinqInfo stepCounterPower]) {
        [self.stepManager startPedometer:^(SMStepModel *step) {
            self.steps = step.steps;
            
            self.targetSteps = step.targetSteps;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self updateUI:NO];
            });
        }];
    }
}

- (void)updateUI:(BOOL)animation{
    
    switch (self.progressType) {
        case progressType_steps:
            self.stepsLabel.text = [NSString stringWithFormat:@"%0.f",self.steps];
            
            self.targetStepsLabel.text = [NSString stringWithFormat:@"%@ %0.f",NSLocalizedString(@"OF", nil),self.targetSteps];
            
            double value = self.targetSteps - self.steps;
            
            if (value<0) {
                value = 0;
            }
            
            self.remainderStepsLabel.text = [NSString stringWithFormat:@"%0.f",value];
            break;
        case progressType_calories:
        {
            //体重（kg）* 距离（km）* 运动系数（k）
            SMPersonalModel *userInfo = [SMBlinqInfo userInfo];
            
            double k = 0.8214;
            
            double kg = userInfo.weight * 0.4532;
            
            double km = self.steps*0.614 / 1000;
            
            double tkm = self.targetSteps*0.614 / 1000;
            
            double calories = kg * km * k;
            
            double tcalories = kg * tkm * k;
            
            self.stepsLabel.text = [NSString stringWithFormat:@"%0.f",calories];
            
            self.targetStepsLabel.text = [NSString stringWithFormat:@"%@ %0.f",NSLocalizedString(@"OF", nil),tcalories];
            
            double value = tcalories - calories;
            
            if (value<0) {
                value = 0;
            }
            
            self.remainderStepsLabel.text = [NSString stringWithFormat:@"%0.f",value];
            
  
        }
            break;
        case progressType_distance:
        {
            self.stepsLabel.text = [NSString stringWithFormat:@"%0.1f",self.steps*0.614 / 1000];
            
            self.targetStepsLabel.text = [NSString stringWithFormat:@"%@ %0.1fKM",NSLocalizedString(@"OF", nil),self.targetSteps*0.614 / 1000];
            
            double value = self.targetSteps*0.614 / 1000 - self.steps*0.614 / 1000;

            if (value<0) {
                value = 0;
            }
            
            self.remainderStepsLabel.text = [NSString stringWithFormat:@"%0.1fKM",value];
        }
            break;
        default:
            break;
    }
    
//    self.stepsLabel.text = [NSString stringWithFormat:@"%0.f",self.steps];
//    
//    self.targetStepsLabel.text = [NSString stringWithFormat:@"OF %0.f",self.targetSteps];
    
    NSInteger remainderStepsValue = self.targetSteps-self.steps;
    
    self.reachedLabel.text = NSLocalizedString(@"goal_reached", nil);
    
    if (remainderStepsValue < 0) {
        remainderStepsValue = 0;
        self.okImage.hidden = NO;
        self.reachedLabel.hidden = NO;
    }else{
        self.okImage.hidden = YES;
        self.reachedLabel.hidden =YES;
    }
    
    //self.remainderStepsLabel.text = [NSString stringWithFormat:@"%ld",remainderStepsValue];
    self.remainderStepsLabel.adjustsFontSizeToFitWidth = YES;
    self.remainderStepsLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    
    
    double value = self.steps/self.targetSteps;
    
    if (value > 1) {
        value = 1;
    }
    
    if (animation) {
        self.progress.progress = value;
    }else{
        [self.progress setProgressWithValue:value];
    }

    [self.stepBtn setProgressWith:self.steps targetSteps:self.targetSteps animation:animation];
    [self.caloriesBtn setProgressWith:self.steps targetSteps:self.targetSteps animation:animation];
    [self.distanceBtn setProgressWith:self.steps targetSteps:self.targetSteps animation:animation];
}

- (void)setStepCounterRightButton{
    
    
    UIButton *historyBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0,25, 25)];
    [historyBtn setImage:[UIImage imageNamed:@"histogram"] forState:UIControlStateNormal];
    historyBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [historyBtn setContentMode:UIViewContentModeScaleAspectFill];
    [historyBtn addTarget:self action:@selector(goHistory) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *historyBtnItem = [[UIBarButtonItem alloc] initWithCustomView:historyBtn];

    
    UIButton *settingBtn = [[UIButton alloc]initWithFrame:CGRectMake(0 , 0,25, 25)];
    [settingBtn setImage:[UIImage imageNamed:@"editor"] forState:UIControlStateNormal];
    settingBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [settingBtn setContentMode:UIViewContentModeScaleAspectFill];
    [settingBtn addTarget:self action:@selector(goSetting) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *settingBtnItem = [[UIBarButtonItem alloc] initWithCustomView:settingBtn];
    
    self.navigationItem.rightBarButtonItems  = @[settingBtnItem,historyBtnItem];
}

- (void)setSelectButtonView{
    
    self.goalLabel.adjustsFontSizeToFitWidth = YES;

    self.stepBtn = [[SMViewSelectButton alloc]createWithFrame:CGRectMake(0, 487, 375/3, 180) type:btn_steps event:^(UIColor *pathBackColor, UIColor *pathFillColor, UIColor *pointColor, NSString *valueString, NSString *targetValueString, NSString *remainderValueString) {
        
        self.progressType = progressType_steps;
        [self.caloriesBtn cancelClick];
        [self.distanceBtn cancelClick];
        self.progress.pointColor = pointColor;
        self.progress.pathFillColor = pathFillColor;
        self.progress.pathBackColor = pathBackColor;
        self.stepsLabel.textColor = pathFillColor;
        self.stepsLabel.text = valueString;
        self.targetStepsLabel.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"OF", nil),targetValueString];
        self.remainderStepsLabel.text = remainderValueString;
        [self.iconImage setImage:[UIImage imageNamed:@"icon_shape"]];
        [SKAttributeString setLabelFontContent:self.goalLabel title:NSLocalizedString(@"steps_to_goal", nil) font:Avenir_Heavy Size:14 spacing:4 color:[UIColor whiteColor]];
    }];
    [self.view addSubview:self.stepBtn];
    
    self.caloriesBtn = [[SMViewSelectButton alloc]createWithFrame:CGRectMake(self.stepBtn.frame.size.width, 487, 375/3, 180) type:btn_calories event:^(UIColor *pathBackColor, UIColor *pathFillColor, UIColor *pointColor, NSString *valueString, NSString *targetValueString, NSString *remainderValueString) {
        self.progressType = progressType_calories;
        [self.stepBtn cancelClick];
        [self.distanceBtn cancelClick];
        self.progress.pointColor = pointColor;
        self.progress.pathFillColor = pathFillColor;
        self.progress.pathBackColor = pathBackColor;
        self.stepsLabel.textColor = pathFillColor;
        self.stepsLabel.text = valueString;
        self.targetStepsLabel.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"OF", nil),targetValueString];
        self.remainderStepsLabel.text = remainderValueString;
        [self.iconImage setImage:[UIImage imageNamed:@"icon_calories"]];
        [SKAttributeString setLabelFontContent:self.goalLabel title:NSLocalizedString(@"calories_to_goal", nil) font:Avenir_Heavy Size:14 spacing:4 color:[UIColor whiteColor]];
    }];
    
    [self.view addSubview:self.caloriesBtn];
    
    self.distanceBtn = [[SMViewSelectButton alloc]createWithFrame:CGRectMake(self.stepBtn.frame.size.width*2, 487, 375/3, 180) type:btn_distance event:^(UIColor *pathBackColor, UIColor *pathFillColor, UIColor *pointColor, NSString *valueString, NSString *targetValueString, NSString *remainderValueString) {
        self.progressType = progressType_distance;
        [self.caloriesBtn cancelClick];
        [self.stepBtn cancelClick];
        self.progress.pointColor = pointColor;
        self.progress.pathFillColor = pathFillColor;
        self.progress.pathBackColor = pathBackColor;
        self.stepsLabel.textColor = pathFillColor;
        self.stepsLabel.text = valueString;
        self.targetStepsLabel.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"OF", nil),targetValueString];
        self.remainderStepsLabel.text = [NSString stringWithFormat:@"%@KM",remainderValueString];
        [self.iconImage setImage:[UIImage imageNamed:@"icon_distance"]];
        [SKAttributeString setLabelFontContent:self.goalLabel title:NSLocalizedString(@"distance_to_goal", nil) font:Avenir_Heavy Size:14 spacing:4 color:[UIColor whiteColor]];
    }];
    [self.view addSubview:self.distanceBtn];
}

- (void)showSettingVcWithAnimated:(BOOL)animated{
    SMStepSettingPage *setting = [[SMStepSettingPage alloc]initWithNibName:@"SMStepSettingPage" bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:setting];
    
    [self presentViewController:nav animated:animated completion:nil];
}

- (void)goHistory{
    SMHistoryPage *history = [[SMHistoryPage alloc]initWithNibName:@"SMHistoryPage" bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:history];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)goSetting{
    [self showSettingVcWithAnimated:YES];
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
}

- (void)someMethod{
    [self setupStepsData];
}

- (void)viewWillDisappear:(BOOL)animated{
    //[self.stepManager stopPedometer];
    [super viewWillDisappear:animated];
    [SKNotificationCenter removeObserver:self];
}

#pragma mark - 懒加载

- (SMStepsInfoManager *)stepManager{
    if (!_stepManager) {
        _stepManager = [[SMStepsInfoManager alloc]init];
    }
    return _stepManager;
}

- (SMProgress *)progress{
    if (!_progress) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 60,375, 375)];
        view.transform = CGAffineTransformMakeRotation(M_PI+M_PI_2);
        [self.view insertSubview:view atIndex:2];
        
        //默认状态
        self.progress = [[SMProgress alloc] initWithFrame:CGRectMake(0, 0,375, 375) pathBackColor:[UIColor redColor] pathFillColor:[UIColor blueColor] startAngle:0 strokeWidth:10];
        self.progress.pointColor = RGB_COLOR(35, 191, 255);
        self.progress.pathFillColor = RGB_COLOR(74, 144, 226);
        self.progress.pathBackColor = RGB_COLORA(74, 144, 226,0.2);
        self.progress.strokeWidth = 10;
        self.progress.showProgressText = NO;
        
        [SKAttributeString setLabelFontContent:self.goalLabel title:NSLocalizedString(@"steps_to_goal", nil) font:Avenir_Heavy Size:14 spacing:4 color:[UIColor whiteColor]];
        self.progress.progress = 0.6;
        
        [view addSubview:self.progress];
    }
    return _progress;
}

@end
