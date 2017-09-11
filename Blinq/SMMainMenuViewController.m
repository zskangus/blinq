//
//  SMMainMenuViewController.m
//  Blinq
//
//  Created by zsk on 16/3/27.
//  Copyright © 2016年 zsk. All rights reserved.
//

#import "SMMainMenuViewController.h"
#import "SMMainMenuCell.h"
#import "SMStartupViewController.h"
#import "SMSSidebarViewController.h"
#import "SKAttributeString.h"
#import "BTServer.h"

#import "SMAppTool.h"
#import "SMContactTool.h"

#import "logMessage.h"

#import "SMBindingViewController.h"

@interface SMMainMenuViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,strong)NSArray *labelArray;
@property(nonatomic,strong)NSArray *imageArray;
@property (weak, nonatomic) IBOutlet UIButton *unpairBtn;

@end

static NSString * const mainMeunCell = @"MainMenuCell";

@implementation SMMainMenuViewController



- (NSArray *)labelArray{
    if (!_labelArray) {
        
        if ([[NSUserDefaults standardUserDefaults]boolForKey:@"openSosFunc"]) {
            _labelArray = @[NSLocalizedString(@"menu_title_notifications", nil),
                            NSLocalizedString(@"menu_title_contacts", nil),
                            NSLocalizedString(@"menu_title_play", nil),
                            NSLocalizedString(@"menu_title_emergency", nil),
                            NSLocalizedString(@"STEP COUNTER", nil),
                            NSLocalizedString(@"menu_title_settings", nil),
                            NSLocalizedString(@"menu_title_help", nil)
                            ];
        }else{
            _labelArray = @[NSLocalizedString(@"menu_title_notifications", nil),
                            NSLocalizedString(@"menu_title_contacts", nil),
                            NSLocalizedString(@"menu_title_play", nil),
                            NSLocalizedString(@"STEP COUNTER", nil),
                            NSLocalizedString(@"menu_title_settings", nil),
                            NSLocalizedString(@"menu_title_help", nil),
                            NSLocalizedString(@"STEP COUNTER", nil)];
        }
        
    }
    return _labelArray;
}

-(NSArray *)imageArray{
    if (!_imageArray) {
        if ([[NSUserDefaults standardUserDefaults]boolForKey:@"openSosFunc"]) {
            _imageArray = @[@"icon-shape",@"icon-lists",@"icon-home",@"icon-profile",@"icon-form",@"icon-settings",@"icon-form"];
        }else{
            _imageArray = @[@"icon-shape",@"icon-lists",@"icon-home",@"icon-form",@"icon-settings",@"icon-form"];
        }
    }
    return _imageArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
     // 设置背景颜色
    self.tableView.backgroundColor = [UIColor blackColor];
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"SMMainMenuCell" bundle:nil] forCellReuseIdentifier:mainMeunCell];
    
    [SKAttributeString setButtonFontContent:self.unpairBtn title:@"UNPAIR MY RING" font:Avenir_Book Size:16 spacing:2.46 color:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self SetupNavigationBarColorAndLogo];
    
    
    if ([NSLocalizedString(@"language", nil)isEqualToString:@"German"]) {
        [SKAttributeString setButtonFontContent:self.unpairBtn title:NSLocalizedString(@"unpairButton_title", nil) font:Avenir_Heavy Size:15 spacing:2.5 color:[UIColor whiteColor] forState:UIControlStateNormal];
        self.unpairBtn.titleLabel.lineBreakMode = 0;

    }else{
        [SKAttributeString setButtonFontContent:self.unpairBtn title:NSLocalizedString(@"unpairButton_title", nil) font:Avenir_Heavy Size:18 spacing:3 color:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

- (void)SetupNavigationBarColorAndLogo{
    
    // 设置背景颜色
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    // 设置导航栏半透明
    self.navigationController.navigationBar.translucent = true;
    // 设置导航栏背景图片
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    // 设置导航栏阴影图片
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    // 设置导航栏左边的LOGO显示 注意需要将图片Render AS选项设置为orignal image选项，保证图片是没有经过渲染的原图。在图片管理器的第三选项卡
//    UIBarButtonItem *logoItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menuLogo"] style:UIBarButtonItemStyleDone target:nil action:nil];
//    logoItem.enabled = NO;
//    
//    self.navigationItem.leftBarButtonItem = logoItem;

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.labelArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

- (IBAction)UNPIRMYRING:(id)sender {
    
    NSString *titleStr = NSLocalizedString(@"warning", nil);
    NSString *str = NSLocalizedString(@"unpairDescribe", nil);
    
    // 蓝牙的取消
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:titleStr message:[str uppercaseString] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"no", nil) style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"yes", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [SKUserDefaults setBool:NO forKey:isBinding];
        
        // 清除所有保存的数据
        [self clearAllUserDefaultsData];
        
        SMStartupViewController *Startup = [[SMStartupViewController alloc]initWithNibName:@"SMStartupViewController" bundle:nil];
        [self presentViewController:Startup animated:YES completion:nil];

    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    //修改title
    NSMutableAttributedString *alertControllerTitleStr = [[NSMutableAttributedString alloc] initWithString:titleStr];
    [alertControllerTitleStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:17] range:NSMakeRange(0, titleStr.length)];
    [alertControllerTitleStr addAttribute:NSKernAttributeName value:@1.85 range:NSMakeRange(0, titleStr.length)];
    
    //修改message
    NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:[str uppercaseString]];
    [alertControllerMessageStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:12] range:NSMakeRange(0, str.length)];
    [alertControllerMessageStr addAttribute:NSKernAttributeName value:@1.85 range:NSMakeRange(0, str.length)];

    [alertController setValue:alertControllerTitleStr forKey:@"attributedTitle"];

    [alertController setValue:alertControllerMessageStr forKey:@"attributedMessage"];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

/**
 *  清除所有的存储本地的数据
 */
- (void)clearAllUserDefaultsData
{
    
    // 断开连接
    BTServer *ble = [BTServer sharedBluetooth];
    
    [ble removeBinding];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    tableView.separatorStyle = NO;
    
    SMMainMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:mainMeunCell];
    
    cell.cellImange.image = [UIImage imageNamed:self.imageArray[indexPath.row]];
    
    
    if ([self.labelArray[indexPath.row] isEqualToString:@"BENACHRICHTIGUNGEN"]) {
        [SKAttributeString setLabelFontContent:cell.cellLabel title:self.labelArray[indexPath.row] font:Avenir_Book Size:14 spacing:2.46 color:[UIColor whiteColor]];
    }else{
        [SKAttributeString setLabelFontContent:cell.cellLabel title:self.labelArray[indexPath.row] font:Avenir_Book Size:16 spacing:2.46 color:[UIColor whiteColor]];
    }
    
    // 设置cell的背景为透明
    cell.backgroundColor=[UIColor clearColor];   
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSNumber *num = [NSNumber numberWithInteger:indexPath.item];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    [center postNotificationName:@"update" object:num];
    
    [center postNotificationName:@"packupSidebar" object:nil];
    
}

@end
