//
//  SMPlayViewController.m
//  Blinq
//
//  Created by zsk on 16/3/29.
//  Copyright © 2016年 zsk. All rights reserved.
//

#import "SMPlayViewController.h"
#import "SmartRemindManager.h"

#import "TopPlayManager.h"
#import "AppConstant.h"


@interface SMPlayViewController ()

@property (weak, nonatomic) IBOutlet UIButton *vibrateBtn;

@property (weak, nonatomic) IBOutlet UIButton *pulseBtn;

@property(nonatomic,strong)TopPlayManager *playMgr;

@property(nonatomic,strong)UIButton *currenctButton;

@property(nonatomic,retain)NSMutableArray *colorArray;

@property(nonatomic,strong)NSTimer *vibrate;// 控制震动

@property (weak, nonatomic) IBOutlet UILabel *playTitle;
@property(nonatomic,assign)BOOL isStart;

@end

@implementation SMPlayViewController

- (NSMutableArray *)colorArray{
    if (!_colorArray) {
        _colorArray = [NSMutableArray array];
    }
    return _colorArray;
}

- (TopPlayManager *)playMgr{
    if (!_playMgr) {
        _playMgr = [[TopPlayManager alloc]init];
    }
    return _playMgr;
    
}

-(NSTimer *)vibrate{
    if (!_vibrate) {
        _vibrate = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(setVibrate) userInfo:nil repeats:YES];
    }
    return _vibrate;
}

- (void)viewWillAppear:(BOOL)animated{
    [self autoDetectionRingVersion];

    [self addObserver:self forKeyPath:@"colorArray" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [SKAttributeString setLabelFontContent:self.playTitle title:NSLocalizedString(@"play_page_title", nil) font:Avenir_Light Size:11 spacing:3.3 color:[UIColor whiteColor]];
    
    [SKAttributeString setButtonFontContent:self.vibrateBtn title:NSLocalizedString(@"play_page_vibBtn_title", nil) font:Avenir_Black Size:15 spacing:2.46 color:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [SKAttributeString setButtonFontContent:self.pulseBtn title:NSLocalizedString(@"play_page_pulseBtn_title", nil) font:Avenir_Black Size:15 spacing:2.46 color:[UIColor whiteColor] forState:UIControlStateNormal];
    
    if ([NSLocalizedString(@"language", nil)isEqualToString:@"中文"]) {
        [SKAttributeString setLabelFontContent:self.playTitle title:NSLocalizedString(@"play_page_title", nil) font:Avenir_Heavy Size:16 spacing:2 color:[UIColor whiteColor]];
        self.playTitle.textAlignment = NSTextAlignmentCenter;
        
    }
    
    self.view.transform = CGAffineTransformMakeScale([UIScreen mainScreen].bounds.size.width / 375, [UIScreen mainScreen].bounds.size.width / 375);
    
    [self setupNavigationTitle:NSLocalizedString(@"nav_title_PLAY", nil) isHiddenBar:NO];
    
}


- (IBAction)blueBtn:(id)sender {
    
    UIButton * button = (UIButton*)sender;
    
    if (button.selected) {
        button.selected = NO;
        [[self mutableArrayValueForKey:@"colorArray"]removeObject:@Color_BLUE];
    }else{
        button.selected = YES;
        [[self mutableArrayValueForKey:@"colorArray"]addObject:@Color_BLUE];
        NSLog(@"%@",self.colorArray);
    }
    
}
- (IBAction)greenBtn:(id)sender {
    
    UIButton * button = (UIButton*)sender;
    
    if (button.selected) {
        button.selected = NO;
        [[self mutableArrayValueForKey:@"colorArray"]removeObject:@Color_GREEN];
    }else{
        button.selected = YES;
        [[self mutableArrayValueForKey:@"colorArray"]addObject:@Color_GREEN];
    }
    
}
- (IBAction)purpleBtn:(id)sender {
    
    UIButton * button = (UIButton*)sender;
    
    if (button.selected) {
        button.selected = NO;
        [[self mutableArrayValueForKey:@"colorArray"]removeObject:@Color_PURPLE];
    }else{
        button.selected = YES;
        [[self mutableArrayValueForKey:@"colorArray"]addObject:@Color_PURPLE];
    }
    
}
- (IBAction)redBtn:(id)sender {
    
    UIButton * button = (UIButton*)sender;
    
    if (button.selected) {
        button.selected = NO;
        [[self mutableArrayValueForKey:@"colorArray"]removeObject:@Color_RED];
    }else{
        button.selected = YES;
        [[self mutableArrayValueForKey:@"colorArray"]addObject:@Color_RED];
    }
}
- (IBAction)vibrate:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    
    if (button.selected) {
        [self sendVibInfo:@VIB_LEVEL_OFF];
        button.selected = NO;
        
    }else{
        [self sendVibInfo:@VIB_LEVEL_1];
        button.selected = YES;
        
        if (sender != self.currenctButton) {
            [self.vibrate setFireDate:[NSDate distantFuture]];
            self.currenctButton.selected = NO;
            self.currenctButton = sender;
        }else{
            self.currenctButton.selected = YES;
        }
    }
    
    
    
}
- (IBAction)pulse:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    
    if (button.selected) {
        [self.vibrate setFireDate:[NSDate distantFuture]];
        button.selected = NO;
        
    }else{
        [self.vibrate setFireDate:[NSDate distantPast]];
        button.selected = YES;
        
        if (sender != self.currenctButton) {
            [self sendVibInfo:@VIB_LEVEL_OFF];
            self.currenctButton.selected = NO;
            self.currenctButton = sender;
        }else{
            self.currenctButton.selected = YES;
        }
    }
}

- (void)setVibrate{
    
    [self sendVibInfo:@VIB_LEVEL_1];
    
    [NSThread sleepForTimeInterval:0.5];
    
    [self sendVibInfo:VIB_LEVEL_OFF];
    
}

- (void)setVibrate1{
    
    [self sendVibInfo:@VIB_LEVEL_1];
    
    [NSThread sleepForTimeInterval:2];
    
    [self sendVibInfo:VIB_LEVEL_OFF];
    
}

//第二步 处理变化
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"colorArray"]) {
        [self changeColor];
    }
}


- (void)changeColor{
    
    if (!self.isStart) {
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
        dispatch_async(queue, ^{
            
            while (self.colorArray.count > 0) {
                
                for (int i = 0; i<self.colorArray.count; i++) {
                    self.isStart = YES;
                    [self sendColorInfo:self.colorArray[i]];
                    [NSThread sleepForTimeInterval:1.5];
//                    [self sendColorInfo:@Color_CLOSE];
//                    [NSThread sleepForTimeInterval:0.5];
                }
                
                if (self.colorArray.count == 0) {
                    self.isStart = NO;
                    return;
                }
            }
            
        });
    }
}


- (void)changColorAtATime:(NSNumber*)color{
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        
        [self sendColorInfo:color];
        [NSThread sleepForTimeInterval:0.5];
        [self sendColorInfo:@Color_CLOSE];
    });
    
}

- (void)sendColorInfo:(NSNumber*)color{
    Byte byte[] = {[color integerValue],50};
    NSData *colorData =  [[NSData alloc] initWithBytes:byte length:sizeof(byte)];
    [self.playMgr writerMsgDataTopPlayColor:ModID_Play data:colorData];
}

- (void)sendVibInfo:(NSNumber*)vib{
    Byte byte[] = {[vib integerValue]};
    NSData *vibrateData =  [[NSData alloc] initWithBytes:byte length:sizeof(byte)];
    [self.playMgr writerMsgDataTopPlayVibrate:ModID_Play data:vibrateData];
}

//呼吸灯
- (void)sendBreathingLamp:(NSNumber*)color time:(NSInteger)time{
    Byte byte[] = {[color integerValue],time};
    NSData *colorData =  [[NSData alloc] initWithBytes:byte length:sizeof(byte)];
    [self.playMgr writerMsgDataTopPlayColor:ModID_Play data:colorData];
}

//+ (void)notificationAlertInstruction:(Indication)indication{
//    Byte delay = 0;
//    Byte color = 0xff;
//    Byte Count = 1;
//    
//    Byte type;
//    
//    switch (indication) {
//        case INDICATION_TYPE_ANTILOST:
//            type = 0;
//            break;
//        case INDICATION_TYPE_NORMAL_CALL:
//            type = 1;
//            break;
//        case INDICATION_TYPE_SOS_WARMING:
//            type = 2;
//            break;
//        case INDICATION_TYPE_SOS_CONFIRM:
//            type = 3;
//            break;
//        case INDICATION_TYPE_NORMAL_SOCIAL:
//            type = 4;
//            break;
//        case INDICATION_TYPE_SPECIAL_CALL:
//            type = 0x21;
//            break;
//        case INDICATION_TYPE_SPECIAL_SOCIAL:
//            type = 0x24;
//            break;
//        case INDICATION_TYPE_NORMAL_VF_ALL:
//            type = 0x80;
//            break;
//        case INDICATION_TYPE_NORMAL_V_HALF_SEC:
//            type = 0x81;
//            break;
//        case INDICATION_TYPE_NORMAL_F_HALF_SEC:
//            type = 0x82;
//            break;
//        case INDICATION_TYPE_NORMAL_V_ONE_SEC:
//            type = 0x83;
//            break;
//        case INDICATION_TYPE_NORMAL_F_ONE_SEC:
//            type = 0x84;
//            break;
//        case INDICATION_TYPE_NORMAL_V_TWO_SEC:
//            type = 0x85;
//            break;
//        case INDICATION_TYPE_NORMAL_F_TWO_SEC:
//            type = 0x86;
//            break;
//        case INDICATION_NONE:
//            type = 0xff;
//            break;
//        default:
//            break;
//    }
//    
//    Byte configs[]= {COMMAND_ID_NTF_ADDED,TYPE_TAG_NOTIFICATIONS, CONFIG_ERR_CODE_OK, delay,type,color,Count};
//    
//    //发送一条通知
//    SmartRemindManager *manager = [[SmartRemindManager alloc]init];
//    [manager writerData:ModID_Remind reqData:configs length:7];
//}

- (void)stopFlashAndVib{
    
    NSLog(@"停止闪烁及震动");
    
    [self sendVibInfo:@VIB_LEVEL_OFF];
    [NSThread sleepForTimeInterval:0.3];
    [self sendColorInfo:@Color_CLOSE];
}


//页面消失，进入后台不显示该页面
-(void)viewDidDisappear:(BOOL)animated
{
    
    NSLog(@"玩一玩界面触发%s",__FUNCTION__);
    [self.colorArray removeAllObjects];
    
    [self stopFlashAndVib];
    
    [self.vibrate setFireDate:[NSDate distantFuture]];
    
    
      for (UIButton *btn in self.view.subviews) {
          if ([btn isKindOfClass:[UIButton class]]) {
              NSLog(@"btn==%@",btn);
              
              btn.selected = NO;
          }
      }
}

- (void)dealloc{
}


@end

