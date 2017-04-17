//
//  SMHelpViewController.m
//  Blinq
//
//  Created by zsk on 2016/11/8.
//  Copyright © 2016年 zsk. All rights reserved.
//

#import "SMHelpViewController.h"

@interface SMHelpViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation SMHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView.scalesPageToFit = YES;//自动对页面进行缩放以适应屏幕
    NSURL* url = [NSURL URLWithString:@"http://help.blinqblinq.com"];//创建URL
    NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
    [self.webView loadRequest:request];//加载
}


@end
