//
//  SMSensitivityView.m
//  integration
//
//  Created by zsk on 2017/5/24.
//  Copyright © 2017年 zsk. All rights reserved.
//

#import "SMSensitivityView.h"
#import "SKAttributeString.h"

@interface SMSensitivityView()

@property(nonatomic,strong)UIImageView *thumb;

@property(nonatomic,strong)UIImageView *niuthumb;

@property(nonatomic,copy)sensitivityLevelBlock sensitivityLevel;

@property(nonatomic,assign)NSInteger countLevel;


@end

@implementation SMSensitivityView

- (instancetype)createWithFrame:(CGRect)frame sensitivity:(sensitivityLevelBlock)sensitivity{
    
    self.sensitivityLevel = sensitivity;
    
    return [self initWithFrame:frame];;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    UIImageView *bgImage = [[UIImageView alloc]initWithFrame:CGRectMake(20.5, 40/2-21.5/2,334, 21.5)];
    [bgImage setImage:[UIImage imageNamed:@"slider_background"]];
    
    [self addSubview:bgImage];
    
    UIButton *removeBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 56, 56)];
    [removeBtn setImage:[UIImage imageNamed:@"slider_remove"] forState:UIControlStateNormal];
    removeBtn.tag = 1;
    [removeBtn addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:removeBtn];
    
    UIButton *addBtn = [[UIButton alloc]initWithFrame:CGRectMake(319, 0, 56, 56)];
    addBtn.tag = 2;
    [addBtn setImage:[UIImage imageNamed:@"slider_add"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
    //addBtn.backgroundColor = [UIColor blackColor];
    [self addSubview:addBtn];
    
    self.thumb = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width/2-40/2, 40/2-40/2, 40, 40)];
    [self.thumb setImage:[UIImage imageNamed:@"slider_button"]];
    self.thumb.userInteractionEnabled = YES;
    [self addSubview:self.thumb];
    
    self.niuthumb = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width/2-40/2, 40/2-40/2, 40, 40)];
    [self.niuthumb setImage:[UIImage imageNamed:@""]];
    self.niuthumb.userInteractionEnabled = YES;
    [self addSubview:self.niuthumb];

    // 创建手势对象
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    // 将手势与视图广联
    [self.niuthumb addGestureRecognizer:pan];
    
    UILabel *low = [[UILabel alloc]initWithFrame:CGRectMake(11, 40, 50, 15)];
    [SKAttributeString setLabelFontContent2:low title:NSLocalizedString(@"easy", nil) font:Avenir_Book Size:8 spacing:1.53 color:[UIColor whiteColor]];
    low.textAlignment = NSTextAlignmentCenter;
    [self addSubview:low];
    
    UILabel *high = [[UILabel alloc]initWithFrame:CGRectMake(314, 40, 50, 15)];
    [SKAttributeString setLabelFontContent2:high title:NSLocalizedString(@"difficult", nil) font:Avenir_Book Size:8 spacing:1 color:[UIColor whiteColor]];
    high.textAlignment = NSTextAlignmentCenter;
    [self addSubview:high];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(99, 40, 180, 15)];
    if ([NSLocalizedString(@"language", nil)isEqualToString:@"German"]) {
        [SKAttributeString setLabelFontContent2:title title:NSLocalizedString(@"alert_sensitivity", nil) font:Avenir_Black Size:11 spacing:2 color:[UIColor whiteColor]];
        
        CGRect frame = title.frame;
        frame.size.width += 40;
        frame.origin.x -= 20;
        title.frame = frame;
    }else{
        [SKAttributeString setLabelFontContent2:title title:NSLocalizedString(@"alert_sensitivity", nil) font:Avenir_Black Size:14 spacing:2.15 color:[UIColor whiteColor]];
    }
    
    title.textAlignment = NSTextAlignmentCenter;
    [self addSubview:title];
    
    return self;
}

- (void)setCount:(NSInteger)countLevel{
    
    self.countLevel = countLevel;
    
    CGPoint center = self.thumb.center;
    
    center.x = 36.5 + countLevel * 30.2;
    
    self.thumb.center = center;
    self.niuthumb.center = center;
}

- (void)pan:(UIPanGestureRecognizer*)yidong{

    switch (yidong.state) {
        case UIGestureRecognizerStateBegan:
            
            
            break;
        case UIGestureRecognizerStateChanged:
        {
            // translationInView:取相对于起点位置的相对坐标
            CGPoint xdzuobiao = [yidong translationInView:self.niuthumb];
        
            // 修改图片的中心点
            CGPoint center = self.thumb.center;
            center.x += xdzuobiao.x;
            //center.y += xdzuobiao.y;
            
            CGPoint niuThumbCenter = self.niuthumb.center;
            niuThumbCenter.x += xdzuobiao.x;
            
            
            if (niuThumbCenter.x < 339 && niuThumbCenter.x > 36) {
                // 把中心点赋给图片
                
                self.niuthumb.center = niuThumbCenter;
                
                NSInteger count = (niuThumbCenter.x - 36.5) / 30.2;
                
                NSLog(@"%ld",(long)count);
                
                center.x = 36.5 + count * 30.2;
                
                self.thumb.center = center;
                
                //NSLog(@"%@---zuobiao%@",NSStringFromCGPoint(center),NSStringFromCGPoint(xdzuobiao));
                
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            CGPoint center = self.niuthumb.center;
            
            NSInteger count = (center.x - 36.5) / 30.2;
            
            NSLog(@"%ldsdsdsd",(long)count);

            
            self.niuthumb.center = self.thumb.center;

            self.countLevel = count;
            
            self.sensitivityLevel(count);
            
        }
            break;
            
        default:
            break;
    }
    
    // 每次移动后,将本次移动的距离置零
    // 那么下一次再移动时,记录的距离就是最后两点间的距离,而不是距离第一个点的距离
    [yidong setTranslation:CGPointZero inView:self.thumb];
    
}

- (void)buttonEvent:(UIButton*)button{
    
    CGPoint center = self.thumb.center;

    switch (button.tag) {
        case 1:
            NSLog(@"减");
            
            if (self.countLevel == 0) {
                return;
            }
            
            self.countLevel--;
            break;
        case 2:
            
            if (self.countLevel == 10) {
                return;
            }
            
            self.countLevel++;
            break;
            
        default:
            break;
    }
    
    NSLog(@"%ld",self.countLevel);
    
    // 把中心点赋给图片
    center.x = 36.5 + self.countLevel * 30.2;
    
    
    self.thumb.center = center;
    
    self.niuthumb.center = center;
    
    self.sensitivityLevel(self.countLevel);
    
    //NSLog(@"}}}}}}%@-----------%@",NSStringFromCGPoint(center),NSStringFromCGRect(self.thumb.frame));

}

@end
