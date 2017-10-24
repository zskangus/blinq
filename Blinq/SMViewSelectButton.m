//
//  SMViewSelectButton.m
//  Blinq
//
//  Created by zsk on 2017/8/2.
//  Copyright © 2017年 zsk. All rights reserved.
//

#import "SMViewSelectButton.h"
#import "SKConst.h"
#import "ZZCircleProgress.h"
#import "SMBlinqInfo.h"

@interface SMViewSelectButton()

@property(nonatomic,strong)UIButton *responseButton;

@property(nonatomic,strong)UIImageView *bgImage;

@property(nonatomic,assign)btnType btnType;

@property(nonatomic,copy)clickEventBlock event;

@property(nonatomic,strong)ZZCircleProgress *progressLevel;

@property (nonatomic, strong) UIColor *pathBackColor;/**<线条背景色*/
@property (nonatomic, strong) UIColor *pathFillColor;/**<线条填充色*/
@property (nonatomic, strong) UIImage *pointImage;/**<小圆点图片*/
@property(nonatomic,strong)UIColor *pointColor;

@property(nonatomic,assign)BOOL isbanUserInteraction;

@property(nonatomic,strong)UILabel *stepsLabel;

@property(nonatomic,strong)UILabel *targetStepsLabel;

@property(nonatomic,copy)NSString *remainderString;

@end

@implementation SMViewSelectButton

- (instancetype)createWithFrame:(CGRect)frame type:(btnType)type  event:(clickEventBlock)event{
    
    self.btnType = type;
    
    self.event = event;
    
    return [self initWithFrame:frame];;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    self.bgImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    
    
    if (self.btnType == btn_steps) {
        [self.bgImage setImage:[UIImage imageNamed:@"buttonBg_select"]];
    }else{
        [self.bgImage setImage:[UIImage imageNamed:@"buttonBg"]];
    }

    [self addSubview:self.bgImage];
    
    [self creatrUI];

    
    self.responseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.responseButton.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    [self.responseButton addTarget:self action:@selector(clickEvent) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.responseButton];
    
    
    
    return self;
}

- (void)creatrUI{
    
    CGRect frame = CGRectMake(0, 0, self.frame.size.width - 40, self.frame.size.width- 40);

    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(20,30 , frame.size.width, frame.size.height)];
    view.transform = CGAffineTransformMakeRotation(M_PI+M_PI_2);
    [self addSubview:view];
    
    NSString *iconString = @"";
    NSString *text = @"";
    
    switch (self.btnType) {
        case btn_steps:
            self.pointColor = RGB_COLOR(35, 191, 255);
            self.pathFillColor = RGB_COLOR(74, 144, 226);
            self.pathBackColor = RGB_COLORA(74, 144, 226,0.2);
            iconString = @"icon_shape";
            text = NSLocalizedString(@"steps", nil);
            break;
        case btn_calories:
            self.pointColor = RGB_COLOR(171, 243, 223);
            self.pathFillColor = RGB_COLOR(113, 206, 192);
            self.pathBackColor = RGB_COLORA(113, 206, 192,0.2);
            iconString = @"icon_calories";
            text = NSLocalizedString(@"calories", nil);

            break;
        case btn_distance:
            self.pointColor = RGB_COLOR(239, 69, 60);
            self.pathFillColor = RGB_COLOR(210, 80, 117);
            self.pathBackColor = RGB_COLORA(210, 80, 117,0.2);
            iconString = @"icon_distance";
            text = NSLocalizedString(@"distance", nil);

            break;
        default:
            break;
    }
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(12, 135, 25, 25)];
    [image setImage:[UIImage imageNamed:iconString]];
    [self addSubview:image];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(40, 135, 83, 25)];
    label.adjustsFontSizeToFitWidth = YES;
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor whiteColor];
    label.text = text;
    [self addSubview:label];

    //默认状态
    self.progressLevel = [[ZZCircleProgress alloc] initWithFrame:CGRectMake(0, 0  , frame.size.width, frame.size.width) pathBackColor:self.pathBackColor pathFillColor:self.pathFillColor startAngle:0 strokeWidth:10];
    self.progressLevel.pointColor = self.pointColor;
    self.progressLevel.strokeWidth = 6;
    self.progressLevel.showProgressText = NO;
    self.progressLevel.progress = 0.6;
    [view addSubview:self.progressLevel];
    
    self.stepsLabel = [[UILabel alloc]initWithFrame:view.frame];
    self.stepsLabel.textColor = self.pathFillColor;
    self.stepsLabel.font = [UIFont boldSystemFontOfSize:19];
    self.stepsLabel.adjustsFontSizeToFitWidth = YES;
    self.stepsLabel.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:self.stepsLabel];
    
    self.targetStepsLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 70, view.frame.size.width - 20, view.frame.size.height - 40)];
    self.targetStepsLabel.textColor = [UIColor whiteColor];
    self.targetStepsLabel.font = [UIFont systemFontOfSize:14];
    self.targetStepsLabel.adjustsFontSizeToFitWidth = YES;
    self.targetStepsLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.targetStepsLabel];
}

- (void)setUserInteraction:(BOOL)boolValue{
    self.isbanUserInteraction = boolValue;
    
    if (boolValue == YES) {
        [self.bgImage removeFromSuperview];
    }
}

- (void)setProgressWith:(double)steps targetSteps:(double)targetSteps animation:(BOOL)animation{
    

    
    switch (self.btnType) {
        case btn_steps:
            self.stepsLabel.text = [NSString stringWithFormat:@"%0.f",steps];
            
            self.targetStepsLabel.text = [NSString stringWithFormat:@"%0.f",targetSteps];
            
            double value = targetSteps - steps;
            
            if (value<0) {
                value = 0;
            }
            
            self.remainderString = [NSString stringWithFormat:@"%0.f",value];
            break;
        case btn_calories:
        {
                //体重（kg）* 距离（km）* 运动系数（k）
            SMPersonalModel *userInfo = [SMBlinqInfo userInfo];
            
            double k = 0.8214;
            
            double kg = userInfo.weight * 0.4532;
            
            double km = steps*0.614 / 1000;
            
            double tkm = targetSteps*0.614 / 1000;
            
            double calories = kg * km * k;
            
            double tcalories = kg * tkm * k;

            self.stepsLabel.text = [NSString stringWithFormat:@"%0.f",calories];
            
            self.targetStepsLabel.text = [NSString stringWithFormat:@"%0.f",tcalories];
            
            double value = tcalories - calories;
            
            if (value<0) {
                value = 0;
            }
            
            self.remainderString = [NSString stringWithFormat:@"%0.f",value];

        }
            break;
        case btn_distance:
        {
            self.stepsLabel.text = [NSString stringWithFormat:@"%0.1f",steps*0.614 / 1000];
            
            self.targetStepsLabel.text = [NSString stringWithFormat:@"%0.1fKM",targetSteps*0.614 / 1000];
            
            double value = targetSteps*0.614 / 1000 - steps*0.614 / 1000;
            
            if (value<0) {
                value = 0;
            }
            
            self.remainderString = [NSString stringWithFormat:@"%0.1f",value];
        }
            break;
        default:
            break;
    }
    
    double value =steps/targetSteps;
    
    if (value > 1) {
        value = 1;
    }
    
    if (animation) {
        self.progressLevel.progress = value;
    }else{
        
        [self.progressLevel setProgressWithValue:value];
    }
    
}

- (void)clickEvent{
    
    if (self.event) {
        self.event(self.pathBackColor,self.pathFillColor,self.pointColor,self.stepsLabel.text,self.targetStepsLabel.text,self.remainderString);
    }
    
    if (self.isbanUserInteraction == YES) {
        return;
    }
    
    [self.bgImage setImage:[UIImage imageNamed:@"buttonBg_select"]];
    
}

- (void)cancelClick{
    [self.bgImage setImage:[UIImage imageNamed:@"buttonBg"]];
}



@end
