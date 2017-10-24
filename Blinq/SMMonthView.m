//
//  SMMonthView.m
//  Blinq
//
//  Created by zsk on 2017/8/8.
//  Copyright © 2017年 zsk. All rights reserved.
//

#import "SMMonthView.h"
#import "SKConst.h"

@interface SMMonthView()

@property(nonatomic,strong)NSMutableArray *monthData;

@property(nonatomic,strong)NSMutableArray *locationArray;

@property(nonatomic,strong)NSMutableArray *lineArray;

@property(nonatomic,strong)UIView *lineView;

@property(nonatomic,assign)int days;

@property(nonatomic,assign)double fw;

@property(nonatomic,copy)selectDay selectDay;

@end

@implementation SMMonthView

- (instancetype)initMonthViewWithFrame:(CGRect)frame{

    if ([super initWithFrame:frame]) {
        
        self.locationArray = [NSMutableArray array];
        
        self.lineArray = [NSMutableArray array];
        
        [self addGestureRecognizer];

        
        self.backgroundColor = RGB_COLOR(54, 39, 85);


    }

    return self;
}


- (void)addGestureRecognizer{
    // 滑动手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    
    [self addGestureRecognizer:pan];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSSet *allTouches = [event allTouches];    //返回与当前接收者有关的所有的触摸对象
    UITouch *touch = [allTouches anyObject];   //视图中的所有对象
    CGPoint point = [touch locationInView:[touch view]]; //返回触摸点在视图中的当前坐标
    int x = point.x;
    int y = point.y;
    NSLog(@"touch (x, y) is (%d, %d)", x, y);
    
    [self transformSelectMonthWith:point];
}

- (void)transformSelectMonthWith:(CGPoint)point{
    
    int x = point.x;
    for (NSNumber *num in self.locationArray) {
        double fw = [num doubleValue];
        
        if (x >= fw && x <= fw+self.fw) {
         
            NSInteger index = [self.locationArray indexOfObject:num];
            
            NSLog(@"%ld号",index+1);
            
            CGRect frame;
            
            self.lineView.backgroundColor = RGB_COLOR(91, 79, 114);
            frame = self.lineView.frame;
            frame.size.width -= 2;
            frame.origin.x += 1;
            self.lineView.frame = frame;
            
            self.lineView = self.lineArray[index];
            
            self.lineView.backgroundColor = RGB_COLOR(210, 80, 117);
            
            frame = self.lineView.frame;
            frame.size.width += 2;
            frame.origin.x -= 1;
            self.lineView.frame = frame;

            NSLog(@"%@",self.lineView);
            
            self.selectDay(self.monthData[index]);
        }
    }
}



- (void)pan:(UIPanGestureRecognizer*)yidong{
    
    
    
        switch (yidong.state) {
            case UIGestureRecognizerStateBegan:


                break;
            case UIGestureRecognizerStateChanged:
            {
                CGPoint point = [yidong locationInView:self]; //返回触摸点在视图中的当前坐标
                [self transformSelectMonthWith:point];
            }
                break;
            case UIGestureRecognizerStateEnded:
            {
                NSLog(@"3eeee");

                
            }
                break;
                
            default:
                break;
        }
        

    
}

- (SMStepModel*)setStepData:(NSArray *)stepData{
    
    [self removeArrayDate];
    
    self.monthData = [NSMutableArray arrayWithArray:stepData];

    NSInteger maxStep = [self getMaxStep:stepData];
    
    self.days = (int)stepData.count;
    
    self.fw = self.frame.size.width / self.days;
    
    for (int i = 0; i < self.days; i++) {
        
        [self.locationArray addObject:[NSNumber numberWithDouble:self.fw*i]];
        
        NSLog(@"------ %f ",self.fw*i);
        
        SMStepModel *model = stepData[i];
        
        double percentage = (double)model.steps / (double)maxStep;
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake((self.fw*i)+self.fw/2 -1, 120, 2, -(90 * percentage))];
        line.backgroundColor = RGB_COLOR(91, 79, 114);
        [line setUserInteractionEnabled:NO];
        [self.lineArray addObject:line];
        [self addSubview:line];
    }

    CGRect frame;
    self.lineView = self.lineArray.lastObject;
    self.lineView.backgroundColor = RGB_COLOR(210, 80, 117);
    frame = self.lineView.frame;
    frame.size.width += 2;
    frame.origin.x -= 1;
    self.lineView.frame = frame;
    
    return self.monthData.lastObject;
}


- (NSInteger)getMaxStep:(NSArray*)array{
    NSInteger maxStep = 0;;
    for (SMStepModel *day in array) {
        NSInteger step = day.steps;
        if (step > maxStep) {
            maxStep = step;
        }
    }
    return maxStep;
}

- (void)removeArrayDate{
    
    self.lineView = nil;
    
    for (UIView *view in self.lineArray) {
        [view removeFromSuperview];
    }
    
    [self.locationArray removeAllObjects];
    
    [self.lineArray removeAllObjects];
    
    [self.monthData removeAllObjects];
}

- (void)selectComplete:(selectDay)block{
    self.selectDay = block;
}

@end
