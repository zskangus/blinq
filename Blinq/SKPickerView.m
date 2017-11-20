//
//  SKPickerView.m
//  demo
//
//  Created by zsk on 2017/8/4.
//  Copyright © 2017年 zsk. All rights reserved.
//

#import "SKPickerView.h"

#define bgViewHeight 260
#define toolHeight 40
#define buttonwidth 65
#define RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]


@interface SKPickerView()<UIPickerViewDelegate,UIPickerViewDataSource>

@property(nonatomic,strong)UIView *maskView;

@property(nonatomic,strong)NSArray *dataList;

@property(nonatomic,copy)NSDictionary *selectContent;

@property(nonatomic,assign)NSInteger row;

@property(nonatomic,assign)NSInteger component;

// 日期选择器
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) NSDateFormatter *formatter;

@end

@implementation SKPickerView

- (instancetype)initPickerViewWithFrame:(CGRect)rect title:(NSString *)title list:(NSArray*)list{
    
    if (self = [super initWithFrame:rect]) {
        
        
        self.maskView = [[UIView alloc]initWithFrame:rect];
        self.maskView.backgroundColor = [UIColor blackColor];
        self.maskView.alpha = 0;
        [self addSubview:self.maskView];
        
        self.backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0,
                                                                      rect.size.height,
                                                                      rect.size.width,
                                                                      bgViewHeight)];
        [self addSubview:self.backgroundView];
        
        
        UIView *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, toolHeight)];
        toolBar.backgroundColor = RGB(237, 236, 234);
        [self.backgroundView addSubview:toolBar];
        
        
        self.leftButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.leftButton.frame = CGRectMake(0, 0, buttonwidth, toolHeight);
        [self.leftButton setTitle:NSLocalizedString(@"cancel", nil) forState:UIControlStateNormal];
        [self.leftButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        self.leftButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        [self.leftButton addTarget:self action:@selector(leftBtnEvent) forControlEvents:UIControlEventTouchUpInside];
        [toolBar addSubview:self.leftButton];
        
        self.rightButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.rightButton.frame = CGRectMake(rect.size.width - buttonwidth ,0,buttonwidth, toolHeight);
        [self.rightButton setTitle:NSLocalizedString(@"upToDate_page_buttonTitle", nil) forState:UIControlStateNormal];
        [self.rightButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        self.rightButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        [self.rightButton addTarget:self action:@selector(rightBtnEvent) forControlEvents:UIControlEventTouchUpInside];
        self.rightButton.enabled = NO;
        [toolBar addSubview:self.rightButton];
        
        
        UILabel *pickerViewTitle = [[UILabel alloc] initWithFrame:CGRectMake(self.leftButton.frame.size.width,
                                                                             0,
                                                                             rect.size.width-(self.leftButton.frame.size.width*2),
                                                                             toolHeight)];
        pickerViewTitle.text = title;
        [pickerViewTitle setFont:[UIFont systemFontOfSize:15]];
        pickerViewTitle.textAlignment = NSTextAlignmentCenter;
        [toolBar addSubview:pickerViewTitle];
        
        self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0,toolHeight, rect.size.width, self.backgroundView.frame.size.height - toolHeight)];
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
        self.pickerView.backgroundColor = RGB(237, 237, 237);
        [self.backgroundView addSubview:self.pickerView];
        
        
        self.dataList = list;
    
    }
    return self;
}

- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated{
    [self.pickerView selectRow:row inComponent:component animated:animated];
}

// 控件有几列
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return self.dataList.count;
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    NSDictionary *dic = self.dataList[row];
    
    if ([NSLocalizedString(@"language", nil)isEqualToString:@"English"]){
        return dic[@"usaUnit"];
    }else{
        return dic[@"otherUnit"];
    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.rightButton.enabled = YES;
    
    self.selectContent = self.dataList[row];
    
    self.row = row;
    
    self.component = component;
    
    NSLog(@"%@----row:%ld----component:%ld",self.dataList[row],row,component);
}

//自定义每个pickview的label
-(UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel* pickerLabel = [UILabel new];
    pickerLabel.numberOfLines = 0;
    pickerLabel.textAlignment = NSTextAlignmentCenter;
    
    if (self.unit.length > 0) {
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:12]];
        
        NSString *string = [NSString stringWithFormat:@"%@ %@",[self pickerView:pickerView titleForRow:row forComponent:component],self.unit];
        pickerLabel.attributedText = [self batteryAttributedText:string textColor:[UIColor blackColor]];
    }else{
        pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    }
    return pickerLabel;
}

- (NSAttributedString*)batteryAttributedText:(NSString*)string textColor:(UIColor*)textColor{
    NSMutableAttributedString * attribute = [[NSMutableAttributedString alloc]initWithString:string];
    
    // 设置文字颜色
    [attribute addAttribute:NSForegroundColorAttributeName value:textColor range:NSMakeRange(0,string.length)];
    
    // 设置字体及字体大小
    [attribute addAttribute: NSFontAttributeName value:[UIFont systemFontOfSize:17]range:NSMakeRange(0,string.length-3)];
    return attribute;
}

-(void)leftBtnEvent{
    [self shutPickerView];
}

-(void)rightBtnEvent{
    // self.returnsResult(self.selectContent, self.row, self.component);
    !self.returnsResult ?: self.returnsResult(self.selectContent, self.row, self.component);
    
    if (self.getSelectDate) {
        self.getSelectDate([self.formatter stringFromDate:_datePicker.date]);
        [self removeFromSuperview];
    }
    
    [self shutPickerView];
}

#pragma mark - 日期选择
- (instancetype)initDatePickerViewWithFrame:(CGRect)rect title:(NSString *)title{
    
    if (self = [super initWithFrame:rect]) {
        
        self.maskView = [[UIView alloc]initWithFrame:rect];
        self.maskView.backgroundColor = [UIColor blackColor];
        self.maskView.alpha = 0;
        [self addSubview:self.maskView];
        
        self.backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0,
                                                                      rect.size.height,
                                                                      rect.size.width,
                                                                      bgViewHeight)];
        self.backgroundView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.backgroundView];
        
        
        UIView *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, toolHeight)];
        toolBar.backgroundColor = RGB(237, 236, 234);
        [self.backgroundView addSubview:toolBar];
        
        self.leftButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.leftButton.frame = CGRectMake(0, 0, buttonwidth, toolHeight);
        [self.leftButton setTitle:NSLocalizedString(@"cancel", nil) forState:UIControlStateNormal];
        [self.leftButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        self.leftButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        [self.leftButton addTarget:self action:@selector(leftBtnEvent) forControlEvents:UIControlEventTouchUpInside];
        [toolBar addSubview:self.leftButton];
        
        self.rightButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.rightButton.frame = CGRectMake(rect.size.width - buttonwidth ,0,buttonwidth, toolHeight);
        [self.rightButton setTitle:NSLocalizedString(@"upToDate_page_buttonTitle", nil) forState:UIControlStateNormal];
        [self.rightButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        self.rightButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        [self.rightButton addTarget:self action:@selector(rightBtnEvent) forControlEvents:UIControlEventTouchUpInside];
        self.rightButton.enabled = NO;
        [toolBar addSubview:self.rightButton];
        
        
        UILabel *pickerViewTitle = [[UILabel alloc] initWithFrame:CGRectMake(self.leftButton.frame.size.width,
                                                                             0,
                                                                             rect.size.width-(self.leftButton.frame.size.width*2),
                                                                             toolHeight)];
        pickerViewTitle.text = title;
        [pickerViewTitle setFont:[UIFont systemFontOfSize:15]];
        pickerViewTitle.textAlignment = NSTextAlignmentCenter;
        [toolBar addSubview:pickerViewTitle];
        
        self.datePicker =  [[UIDatePicker alloc]initWithFrame:CGRectMake(0,toolHeight, rect.size.width, self.backgroundView.frame.size.height - toolHeight)];
        [self.datePicker setDate:[NSDate date] animated:YES];
        [self.datePicker setMaximumDate:[NSDate date]];
        [self.datePicker setDatePickerMode:UIDatePickerModeDate];
        
        [self.datePicker setMinimumDate:[self.formatter dateFromString:@"1900-01-01日"]];
        [self.datePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
        [self.backgroundView addSubview:self.datePicker];
        
    }
    return self;
}
#pragma mark - setter、getter
- (void)setSelectDate:(NSString *)selectDate {
    [_datePicker setDate:[self.formatter dateFromString:selectDate] animated:YES];
}
- (NSDateFormatter *)formatter {
    if (_formatter) {
        return _formatter;
    }
    _formatter =[[NSDateFormatter alloc] init];
    [_formatter setDateFormat:@"yyyy-MM-dd"];
    return _formatter;
    
}
- (void)dateChange:(id)datePicker {
    self.rightButton.enabled = YES;
}


#pragma mark - 视图方法
- (void)pushPickerView{
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    
    self.rightButton.enabled = NO;
    
    __weak typeof(UIView*)blockview = self.backgroundView;
    __block int blockH = self.frame.size.height;;
    __block int bjH = bgViewHeight;
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect bjf = blockview.frame;
        bjf.origin.y = blockH-bjH;
        blockview.frame = bjf;
        self.maskView.alpha = 0.5;
    }];
}

- (void)shutPickerView{
    __weak typeof(UIView*)blockview = self.backgroundView;
    __weak typeof(self)blockself = self;
    __block int blockH = self.frame.size.height;
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect bjf = blockview.frame;
        bjf.origin.y = blockH;
        blockview.frame = bjf;
        self.maskView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [blockself removeFromSuperview];
    }];
}

@end
