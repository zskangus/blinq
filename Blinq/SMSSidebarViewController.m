//
//  SMSSidebarViewController.m
//  Blinq
//
//  Created by zsk on 16/3/25.
//  Copyright © 2016年 zsk. All rights reserved.
//

#import "SMSSidebarViewController.h"

static const CGFloat DrawerLeftViewOffset = -60;
static CGFloat DrawerLeftViewWidth = 292.0f;    //左边的图层的宽度
static const NSTimeInterval DrawerAnimationDuration = 0.3f;  //动画时间
static const NSTimeInterval DrawerAnimationOpenSpringDamping = 1.0f; //打开的弹簧时间
static const CGFloat DrawerAnimationOpenSpringInitialVelocity = 0.05f; //打开的弹簧初始速度
static const CGFloat DrawerAnimationCloseSpringDamping = 1.0; //关闭的弹簧时间
static const CGFloat DrawerAnimationCloseSpringInitialVelocity = 0.2f; //关闭的弹簧初始速度

typedef NS_ENUM(NSInteger,DrawerState){
    DrawerStateClose = 0,
    DrawerStateOpen,
    DrawerStateClosing,
    DrawerStateOpening
};


@interface SMSSidebarViewController ()

@property(nonatomic,weak)UIView *leftView;
@property(nonatomic,weak)UIView *centerView;
@property(nonatomic,assign)DrawerState drawerState;
@property(nonatomic,assign)CGPoint locationStart;

@end

@implementation SMSSidebarViewController

-(instancetype)initWithCenterController:(UIViewController *)centerController leftController:(UIViewController *)leftController{
    self = [super init];
    if (self) {
        _centerController = centerController;
        _leftController = leftController;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"sidebar";
    
    DrawerLeftViewWidth = self.view.frame.size.width / 1.28;
    
    UIView *centerV = [[UIView alloc]initWithFrame:self.view.bounds];
    _centerView = centerV;
    [self.view addSubview:_centerView];
    
    UIView *leftView = [[UIView alloc] initWithFrame:self.view.bounds];
    _leftView = leftView;
    [self.view insertSubview:_leftView belowSubview:_centerView];
    
    [self addChildViewController:_centerController];
    _centerController.view.frame = self.view.bounds;
    [_centerView addSubview:_centerController.view];
    
    UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(tapMoive:)];
    
    gesture.delegate = (id<UIGestureRecognizerDelegate>)self;;
    
    [_centerView addGestureRecognizer:gesture];
    
    [self registeredObservers];
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    
    BOOL inContactPage = [[NSUserDefaults standardUserDefaults]boolForKey:@"inContactPage"];
    
    NSLog(@"%@", NSStringFromClass([touch.view class]));
    
        // 获取当前的触摸点
    
        CGPoint curP = [touch locationInView:touch.view];
    
        if (curP.x < touch.view.bounds.size.width * 0.5) {
    
            NSLog(@"右滑");
    
        }else{
    
            NSLog(@"左滑");
            
            if (inContactPage) {
                
                if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
                    
                    return NO;
                }
                
            }
    
        }
    
    if (_drawerState == DrawerStateOpen) {
        [self close];
    }
    
    return  YES;
}

// 注册观察者
- (void)registeredObservers{
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(postSiderbar) name:@"popupSidebar" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(packupSidebar) name:@"packupSidebar" object:nil];
    
    
    
}
// 推出侧边栏
- (void)postSiderbar{
    
    if (_drawerState != DrawerStateOpen) {
        [self open];
    }
}

// 收起侧边栏
- (void)packupSidebar{
    if (_drawerState != DrawerStateClose) {
        [self close];
    }
}

-(void)tapMoive:(UIPanGestureRecognizer *)gesture
{
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"socialView"]) {
        return;
    }

    
    CGPoint location = [gesture locationInView:self.view];
    
    switch (gesture.state) {
            
        case UIGestureRecognizerStateBegan:
            _locationStart = location;  //记录最开始的位置
            if (_drawerState == DrawerStateClose) {
                [self willOpen];
            }else{
                [self willClose];
            }
            break;
        case UIGestureRecognizerStateChanged:   //当手势滑动
        {
            CGFloat delta = 0;
            if (_drawerState == DrawerStateOpening) {
                delta = location.x - self.locationStart.x;
            }else if (_drawerState == DrawerStateClosing){
                delta = DrawerLeftViewWidth - (self.locationStart.x - location.x);
            }
            
            CGRect l = _leftView.frame;
            CGRect c = _centerView.frame;
            
            if (delta > DrawerLeftViewWidth) {
                l.origin.x = 0;
                c.origin.x = DrawerLeftViewWidth;
            }else if (delta < 0){
                l.origin.x = DrawerLeftViewOffset;
                c.origin.x = 0;
            }else{
                l.origin.x = DrawerLeftViewOffset - (delta * DrawerLeftViewOffset) / DrawerLeftViewWidth;
                
                c.origin.x = delta;
            }
            _leftView.frame = l;
            _centerView.frame = c;
            break;
        }
        case UIGestureRecognizerStateEnded:   //当手势结束
        {
            if (self.centerView.frame.origin.x >= self.view.frame.size.width /
                4) {
                [self animateOpening];
            }else{
                [self animateCloseing];
            }
        }
            break;
        default:
            break;
    }
}

-(void)willOpen
{
    _drawerState = DrawerStateOpening;
    CGRect f = self.view.bounds;
    f.origin.x = DrawerLeftViewOffset;
    _leftView.frame = f;
    _centerView.userInteractionEnabled = NO;
    
    _leftController.view.frame = _leftView.bounds;
    [self addChildViewController:_leftController];
    [_leftView addSubview:_leftController.view];
}

-(void)willClose
{
    _drawerState = DrawerStateClosing;
}

-(void)animateOpening
{
    CGRect centerViewFinelFrame = self.view.bounds;
    centerViewFinelFrame.origin.x = DrawerLeftViewWidth;
    [UIView animateWithDuration:DrawerAnimationDuration delay:0 usingSpringWithDamping:DrawerAnimationOpenSpringDamping initialSpringVelocity:DrawerAnimationOpenSpringInitialVelocity options:UIViewAnimationOptionCurveLinear  animations:^{
        _centerView.frame = centerViewFinelFrame;
        _leftView.frame = self.view.bounds;
    } completion:^(BOOL finished) {
        [self didOpen];
    }];
}

-(void)animateCloseing
{
    CGRect leftViewFinalFrame = self.leftView.frame;
    leftViewFinalFrame.origin.x = - 60;
    [UIView animateWithDuration:DrawerAnimationDuration delay:0 usingSpringWithDamping:DrawerAnimationCloseSpringDamping initialSpringVelocity:DrawerAnimationCloseSpringInitialVelocity options:UIViewAnimationOptionCurveLinear animations:^{
        _centerView.frame = self.view.bounds;
        _leftView.frame = leftViewFinalFrame;
    } completion:^(BOOL finished) {
        [self didClose];
    }];
}

-(void)didOpen
{
    _drawerState = DrawerStateOpen;
    _centerView.userInteractionEnabled = YES;
}

-(void)didClose
{
    _drawerState = DrawerStateClose;
    _centerView.userInteractionEnabled = YES;
}


-(void)open
{
    [self willOpen];
    [self animateOpening];
}

-(void)close
{
    [self willClose];
    [self animateCloseing];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


@end
