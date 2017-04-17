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
        _labelArray = @[@"NOTIFICATIONS",@"CONTACTS",@"PLAY",@"SOS EMERGENCY",@"SETTINGS",@"HELP"];
    }
    return _labelArray;
}

-(NSArray *)imageArray{
    if (!_imageArray) {
        _imageArray = @[@"icon-shape",@"icon-lists",@"icon-home",@"icon-profile",@"icon-settings",@"icon-form"];
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
}

- (void)SetupNavigationBarColorAndLogo{
    
    // 设置导航栏背景颜色
    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    
    // 设置导航栏为不透明
    self.navigationController.navigationBar.translucent = NO;
    
    // 设置导航栏左边的LOGO显示 注意需要将图片Render AS选项设置为orignal image选项，保证图片是没有经过渲染的原图。在图片管理器的第三选项卡
    UIBarButtonItem *logoItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menuLogo"] style:UIBarButtonItemStyleDone target:nil action:nil];
    logoItem.enabled = NO;
    
    self.navigationItem.leftBarButtonItem = logoItem;

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
    
    NSString *str = @"This operation will unpair your phone and the ring. If you want to pair a new ring, you also need to forget the paired ring in 'Settings - > Bluetooth'. Continue to unpair the ring?";
    
    // 蓝牙的取消
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"WARNING" message:[str uppercaseString] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [SKUserDefaults setBool:NO forKey:isBinding];
        
        // 清除所有保存的数据
        [self clearAllUserDefaultsData];
        
        SMStartupViewController *Startup = [[SMStartupViewController alloc]initWithNibName:@"SMStartupViewController" bundle:nil];
        [self presentViewController:Startup animated:YES completion:nil];

    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
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
    
    [SKAttributeString setLabelFontContent:cell.cellLabel title:self.labelArray[indexPath.row] font:Avenir_Book Size:16 spacing:2.46 color:[UIColor whiteColor]];
    
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
