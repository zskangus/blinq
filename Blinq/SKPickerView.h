//
//  SKPickerView.h
//  demo
//
//  Created by zsk on 2017/8/4.
//  Copyright © 2017年 zsk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^returnsResult)(NSDictionary *content,NSInteger row,NSInteger component);

@interface SKPickerView : UIView

// 背景视图
@property(nonatomic,strong)UIView *backgroundView;

// 左按钮
@property(nonatomic,strong)UIButton *leftButton;

// 右按钮
@property(nonatomic,strong)UIButton *rightButton;

@property(nonatomic,strong)NSString *unit;

// 选择器
@property(nonatomic,strong)UIPickerView *pickerView;

@property(nonatomic,copy)returnsResult returnsResult;



- (instancetype)initPickerViewWithFrame:(CGRect)rect title:(NSString *)title list:(NSArray*)list;

- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated;



// 创建日期选择
@property(nonatomic,copy)void(^getSelectDate)(NSString *dateStr);

- (instancetype)initDatePickerViewWithFrame:(CGRect)rect title:(NSString *)title;

- (void)setSelectDate:(NSString *)selectDate;


// 公共方法
- (void)pushPickerView;



@end
