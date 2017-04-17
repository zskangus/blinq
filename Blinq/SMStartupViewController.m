//
//  SMStartupViewController.m
//  Blinq
//
//  Created by zsk on 16/3/25.
//  Copyright © 2016年 zsk. All rights reserved.
//

#import "SMStartupViewController.h"
#import "SMNotificationBewriteViewController.h"
#import "SMBindingViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface SMStartupViewController ()
@property (weak, nonatomic) IBOutlet UIButton *getStarted;

@property (nonatomic,strong) MPMoviePlayerController *moviePlayer;//视频播放控制器
@property (weak, nonatomic) IBOutlet UILabel *copyrightLabel;

@end

@implementation SMStartupViewController

/**
 *  创建媒体播放控制器
 *
 *  @return 媒体播放控制器
 */
-(MPMoviePlayerController *)moviePlayer{
    if (!_moviePlayer) {
        
        
        NSString *urlStr=[[NSBundle mainBundle] pathForResource:@"blinq-welcome.mp4" ofType:nil];
        NSURL *url=[NSURL fileURLWithPath:urlStr];
        
        _moviePlayer=[[MPMoviePlayerController alloc]initWithContentURL:url];
        _moviePlayer.controlStyle = MPMovieControlStyleNone;
        
        if (screenHeight == 480) {
            _moviePlayer.scalingMode = MPMovieScalingModeAspectFill;
        }
        
        _moviePlayer.view.frame=self.view.bounds;
        _moviePlayer.view.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self.view addSubview:_moviePlayer.view];
        [self.view sendSubviewToBack:_moviePlayer.view];
    }
    return _moviePlayer;
}

- (void)viewWillAppear:(BOOL)animated{
//    //添加通知
    [self addNotification];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [SKAttributeString setButtonFontContent:self.getStarted title:@"GET STARTED" font:Avenir_Light Size:20 spacing:3 color:[UIColor whiteColor] forState:UIControlStateNormal];
    
    if (screenHeight == 480) {
        [SKAttributeString setLabelFontContent:self.copyrightLabel title:@"COPYRIGHT 2017 BLINQ | PATENT PENDING" font:Avenir_Heavy Size:9 spacing:3 color:[UIColor whiteColor]];
    }else{
        [SKAttributeString setLabelFontContent:self.copyrightLabel title:@"COPYRIGHT 2017 BLINQ | PATENT PENDING" font:Avenir_Heavy Size:10 spacing:3 color:[UIColor whiteColor]];
    }
    
    [self playMovie];
}

//播放
- (void)playMovie{
    [self.moviePlayer play];
}
//停止
- (void)stopMovie{
    [self.moviePlayer stop];
}

/**
 *  添加通知监控媒体播放控制器状态
 */
-(void)addNotification{
    NSNotificationCenter *notificationCenter=[NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(mediaPlayerPlaybackFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayer];
    
    
//    UIApplicationDidEnterBackgroundNotification  //进入后台
//    UIApplicationWillEnterForegroundNotification //回到程序
    
    [notificationCenter addObserver:self selector:@selector(stopMovie) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    [notificationCenter addObserver:self selector:@selector(playMovie) name:UIApplicationWillEnterForegroundNotification object:nil];
}


/**
 *  播放完成
 *
 *  @param notification 通知对象
 */
-(void)mediaPlayerPlaybackFinished:(NSNotification *)notification{
    NSLog(@"播放完成.%li",self.moviePlayer.playbackState);
    [self.moviePlayer play];
}


- (IBAction)getStarted:(id)sender {
    
    BOOL isHaveBeenBound = [SKUserDefaults boolForKey:@"isHaveBeenBound"];

    if (isHaveBeenBound) {
        SMBindingViewController *bind = [[SMBindingViewController alloc]initWithNibName:@"SMBindingViewController" bundle:nil];
        [self presentViewController:bind animated:YES completion:nil];
    }else{
        
        if (screenHeight == 480) {
            SMNotificationBewriteViewController *notification = [[SMNotificationBewriteViewController alloc]initWithNibName:@"SMNotificationBewriteViewController_ip4" bundle:nil];
            [self presentViewController:notification animated:YES completion:nil];
            
        }else{
            SMNotificationBewriteViewController *notification = [[SMNotificationBewriteViewController alloc]initWithNibName:@"SMNotificationBewriteViewController" bundle:nil];
            [self presentViewController:notification animated:YES completion:nil];
        }

    }
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
