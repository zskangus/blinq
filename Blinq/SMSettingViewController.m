//
//  SMSettingViewController.m
//  Blinq
//
//  Created by zsk on 16/3/29.
//  Copyright © 2016年 zsk. All rights reserved.
//

#import "SMSettingViewController.h"

#import "BTServer.h"

#import "customSwitch.h"

#import "CustomProgress.h"

#import "SettingCell.h"

#import "NotificationConfig.h"

#import "SMMessageManager.h"

#import "otaUpgradeViewController.h"

#import "otaUpdateAvailableViewController.h"

#import "otaUpToDateViewController.h"

#import "SMNetWorkState.h"

typedef NS_ENUM(NSInteger,BleConnectState){
    BleConnected,
    BleDisConnected,
    BleConnecting
};

BleConnectState SMBleConnectState = BleDisConnected;

@interface SMSettingViewController ()<customSwitchDelegate,BTServerDelegate>


@property (weak, nonatomic) IBOutlet customSwitch *outOfRangeAlert;

@property (weak, nonatomic) IBOutlet customSwitch *vibRateAlert;

@property(nonatomic,strong)BTServer *de;

@property(nonatomic,strong)CustomProgress *customProgress;

@property (weak, nonatomic) IBOutlet UIView *batteryView;
@property (weak, nonatomic) IBOutlet UILabel *batteryLabel;
@property (weak, nonatomic) IBOutlet UIImageView *batteryBox;
@property (weak, nonatomic) IBOutlet UIImageView *batteryStatus;
@property (weak, nonatomic) IBOutlet UITableView *settingTableView;
@property (weak, nonatomic) IBOutlet UIImageView *ringImageView;
@property (weak, nonatomic) IBOutlet UILabel *connectStatus;
@property (weak, nonatomic) IBOutlet UIButton *checkUpdateBtn;

@property (weak, nonatomic) IBOutlet UIButton *disConnectButton;

@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UILabel *softwareVersionLabel;
@property (weak, nonatomic) IBOutlet UILabel *batteryLoading;
@property(nonatomic,strong)NSTimer *connectTimer;

@property(nonatomic,strong)UIButton *btn;

@property(nonatomic,strong)NSArray *labelArray;
@end

static NSString * const settingCell = @"SettingCell";

@implementation SMSettingViewController

-(BTServer *)de{
    if (!_de) {
        _de = [BTServer sharedBluetooth];
    }
    return _de;
}

-(CustomProgress *)customProgress{
    if (!_customProgress) {
        _customProgress = [[CustomProgress alloc]init];
    }
    return _customProgress;
}

- (NSArray *)labelArray{
    if (!_labelArray) {
        _labelArray = @[NSLocalizedString(@"vibrate_alert", nil),NSLocalizedString(@"flashing_alert", nil)];
    }
    return _labelArray;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [SKNotificationCenter addObserver:self selector:@selector(receivedNotif:) name:@"ReloadSettingView" object:nil];
    
    [SKNotificationCenter addObserver:self selector:@selector(setupConnectStatus) name:bluetoothConnectState object:nil];
    
    [SKNotificationCenter addObserver:self selector:@selector(batteryLevelUpdated) name:@"batteryLevelUpdated" object:nil];
    
    [SKNotificationCenter addObserver:self selector:@selector(batteryLevelUpdated) name:@"batteryChargerStateChanged" object:nil];
    
    [SKNotificationCenter addObserver:self selector:@selector(setupVersion) name:@"firmwareVersion" object:nil];
    
    [SKNotificationCenter addObserver:self selector:@selector(CBCentralManagerStatePoweredOn) name:@"CBCentralManagerStatePoweredOn" object:nil];
    
    self.outOfRangeAlert.delegate = self;
    
    //[SMMessageManager obtainAntilostInfo];
    
    [self setupConnectStatus];
    [self autoDetectionRingVersion];
    [self batteryLevelUpdated];
    
    [self.de readBatteryState];
    [self.de readFirmwareVersion];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUi];
    
    [self setupVersion];
    
    [self setupBatteryProgressUI];

    self.settingTableView.backgroundColor = [UIColor clearColor];
        
    [self.settingTableView registerNib:[UINib nibWithNibName:@"SettingCell" bundle:nil] forCellReuseIdentifier:settingCell];
    
}

- (void)CBCentralManagerStatePoweredOn{
    SMBleConnectState = BleDisConnected;
}

- (void)setupUi{
    
    [SKAttributeString setButtonFontContent:self.checkUpdateBtn title:NSLocalizedString(@"setting_page_check", nil) font:Avenir_Heavy Size:12 spacing:3.6 color:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)setupConnectStatus{
    
    BOOL status = [[NSUserDefaults standardUserDefaults]boolForKey:@"connectStatus"];
    
    NSLog(@"设置界面-展示连接状态:%@",status?@"YES":@"NO");
    
    if (status) {
        
        SMBleConnectState = BleConnected;
        
        [self.connectTimer invalidate];
        self.connectTimer = nil;
        
        self.versionLabel.hidden = NO;
        
        [self.ringImageView setImage:[UIImage imageNamed:@"settings-ring-image"]];
        
        [SKAttributeString setLabelFontContent:self.connectStatus title:NSLocalizedString(@"setting_page_connect", nil) font:Avenir_Heavy Size:20 spacing:3 color:[UIColor whiteColor]];
        
        [SKAttributeString setButtonFontContent:self.disConnectButton title:NSLocalizedString(@"setting_page_disconnect_buttonTitle", nil) font:Avenir_Heavy Size:12 spacing:3.6 color:[UIColor whiteColor] forState:UIControlStateNormal];

    }else{
        
        SMBleConnectState = BleDisConnected;
        
        self.batteryView.hidden = YES;
        self.batteryLabel.hidden = YES;
        self.versionLabel.hidden = YES;
        self.batteryStatus.hidden = YES;
        //self.softwareVersionLabel.hidden = YES;
        self.batteryLoading.hidden = YES;
        
        [self.ringImageView setImage:[UIImage imageNamed:@"ringImageTwo"]];

        [SKAttributeString setLabelFontContent:self.connectStatus title:NSLocalizedString(@"setting_page_disconnect", nil) font:Avenir_Heavy Size:20 spacing:3 color:[UIColor whiteColor]];
        
        //[self.disConnectButton setSelected:YES];
        
        [SKAttributeString setButtonFontContent:self.disConnectButton title:NSLocalizedString(@"setting_page_connect_buttonTitle", nil) font:Avenir_Heavy Size:12 spacing:3.6 color:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

-(void)receivedNotif:(NSNotification *)notification {
    
    NSLog(@"执行设置界面的更细");
    [self.settingTableView reloadData];
    
}

- (void)clickSwitch:(customSwitch *)Switch withBOOL:(BOOL)isOn{


}

- (IBAction)checkUpdateButton:(id)sender {
    
    BOOL status = [[NSUserDefaults standardUserDefaults]boolForKey:@"connectStatus"];

    if (status == NO) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"tip", nil) message:NSLocalizedString(@"setting_page_disconnect", nil) preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        
        [alertController addAction:okAction];
        
        [alertController setValue:[self setAlertControllerWithStrring:NSLocalizedString(@"tip", nil) fontSize:17 spacing:1.85] forKey:@"attributedTitle"];
        
        [alertController setValue:[self setAlertControllerWithStrring:NSLocalizedString(@"setting_page_disconnect", nil) fontSize:14 spacing:1.85]  forKey:@"attributedMessage"];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        return;
    }

    
    if ([SMNetWorkState state] == NO) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"tip", nil) message:NSLocalizedString(@"tip_network", nil) preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        
        [alertController addAction:okAction];
        
        [alertController setValue:[self setAlertControllerWithStrring:NSLocalizedString(@"tip", nil) fontSize:17 spacing:1.85] forKey:@"attributedTitle"];
        
        [alertController setValue:[self setAlertControllerWithStrring:NSLocalizedString(@"tip_network", nil) fontSize:14 spacing:1.85]  forKey:@"attributedMessage"];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        return;
    }
    
    if ([otaUpgradeViewController detectionRingVersion]) {
        
        otaUpdateAvailableViewController *updateAvailableView = [[otaUpdateAvailableViewController alloc]initWithNibName:@"otaUpdateAvailableViewController" bundle:nil];
        
        [self presentViewController:updateAvailableView animated:YES completion:nil];
        
    }else{
    
        otaUpToDateViewController *upToDate = [[otaUpToDateViewController alloc]initWithNibName:@"otaUpToDateViewController" bundle:nil];
        
        [self presentViewController:upToDate animated:YES completion:nil];

    }
}

- (IBAction)disConnect:(id)sender {
    
    self.btn = (UIButton *)sender;
    BOOL status = [[NSUserDefaults standardUserDefaults]boolForKey:@"connectStatus"];
    
    if (status) {
        [self.de disConnect];
        
    }else{
        if (SMBleConnectState != BleConnecting) {
            SMBleConnectState = BleConnecting;
            [self.de ConnectPeripheral];
            
            if (self.connectTimer == nil) {
                self.connectTimer = [NSTimer scheduledTimerWithTimeInterval:10.0f target:self selector:@selector(timeout) userInfo:nil repeats:NO];
                [[NSRunLoop mainRunLoop] addTimer:_connectTimer forMode:NSDefaultRunLoopMode];
            }
        }
    }
}

- (void)timeout{
    
    NSString *titleStr = NSLocalizedString(@"tip", nil);
    NSString *messageStr = NSLocalizedString(@"connect_failed", nil);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"tip", nil) message:NSLocalizedString(@"connect_failed", nil) preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    
    [alertController addAction:okAction];
    
    //修改title
    NSMutableAttributedString *alertControllerTitleStr = [[NSMutableAttributedString alloc] initWithString:titleStr];
    [alertControllerTitleStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:17] range:NSMakeRange(0, titleStr.length)];
    [alertControllerTitleStr addAttribute:NSKernAttributeName value:@1.85 range:NSMakeRange(0, titleStr.length)];
    
    //修改message
    NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:[messageStr uppercaseString]];
    [alertControllerMessageStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:14] range:NSMakeRange(0, messageStr.length)];
    [alertControllerMessageStr addAttribute:NSKernAttributeName value:@1.85 range:NSMakeRange(0, messageStr.length)];
    
    [alertController setValue:alertControllerTitleStr forKey:@"attributedTitle"];
    
    [alertController setValue:alertControllerMessageStr forKey:@"attributedMessage"];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
    SMBleConnectState = BleDisConnected;
    [self.connectTimer invalidate];
    self.connectTimer = nil;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BOOL power;
    switch (indexPath.row) {
        case 0:
            power = [SKUserDefaults boolForKey:@"vib"];
            
            NSLog(@"取出保存的震动值%@",power?@"YES":@"NO");
            break;
        case 1:
            power = [SKUserDefaults boolForKey:@"flash"];
            NSLog(@"取出保存的闪烁值%@",power?@"YES":@"NO");
            break;
        default:
            break;
    }
    
    tableView.separatorStyle = NO;
    
    SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:settingCell forIndexPath:indexPath];
    
    [SKAttributeString setLabelFontContent:cell.settingCellLabel title:self.labelArray[indexPath.row] font:Avenir_Book Size:16 spacing:2.46 color:[UIColor whiteColor]];
    
    cell.tag = indexPath.row;
    
    [cell.customSwitch setOn:power];
    
    // 设置cell 之间的间隔颜色
    UIView *interval = [[UIView alloc] initWithFrame:cell.frame];
    if(indexPath.row % 2 ){
        UIColor *backgroundColor = [UIColor colorWithRed:(29.0/255.0) green:(29.0/255) blue:(38.0/255) alpha:0.07];
        interval.backgroundColor = backgroundColor;
    }else{
        interval.backgroundColor = [UIColor clearColor];
    }
    cell.backgroundView = interval;
    
    cell.backgroundColor=[UIColor clearColor];
    
    // 设置cell 不被选中
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 65;
}

// 显示版本
- (void)setupVersion{
    // 固件版本
    NSString *versionStr = [SKUserDefaults objectForKey:@"version"];
    
    versionStr = [versionStr substringFromIndex:2];
    
    // 软件版本
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    NSString * localVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    [SKAttributeString setLabelFontContent:self.versionLabel title:[NSString stringWithFormat:@"FIRMWARE %@",versionStr] font:Avenir_Heavy Size:12 spacing:3.6 color:[UIColor whiteColor]];
    
    [SKAttributeString setLabelFontContent:self.softwareVersionLabel title:[NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"software_label", nil),localVersion] font:Avenir_Heavy Size:12 spacing:3.6 color:[UIColor whiteColor]];

    
}

- (void)batteryLevelUpdated{
    
    BOOL status = [[NSUserDefaults standardUserDefaults]boolForKey:@"connectStatus"];

    BOOL batteryCheckState = [SKUserDefaults boolForKey:@"batteryCheckState"];
    
    NSLog(@"电池的检测状态是否通过%@",batteryCheckState?@"yes":@"no");
    
    // 是否是充电状态
    BOOL batteryState = [SKUserDefaults boolForKey:@"batteryStatus"];
    
    NSNumber *battery = [SKUserDefaults objectForKey:@"defaultBattery"];
    
    NSInteger batteryLevel = [battery integerValue];
    
    if (batteryCheckState == NO) {// 如果在电量检查没通过还在检查中
        self.batteryView.hidden = YES;
        self.batteryLabel.hidden = YES;
        self.batteryStatus.hidden = YES;
        
        if (status == YES) {
            self.batteryLoading.hidden = NO;
            
            [SKAttributeString setLabelFontContent:self.batteryLoading title:@"LOADING" font:Avenir_Heavy Size:12 spacing:3.6 color:[UIColor whiteColor]];
        }

    }else{
        
        
        self.batteryView.hidden = NO;
        self.batteryLabel.hidden = NO;
        self.batteryLoading.hidden = YES;
        
        self.batteryBox.image =[self.batteryBox.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        
        if (batteryLevel <= 5) {
            self.batteryBox.tintColor = [UIColor redColor];
        }else{
            self.batteryBox.tintColor = [UIColor whiteColor];
        }
        
        self.batteryLabel.text = [NSString stringWithFormat: @"%ld%%", batteryLevel];
        
        self.batteryStatus.hidden = !batteryState;
        
        [self.customProgress setProgressValue:batteryLevel];
    }

}

- (void)setupBatteryProgressUI{
    
    self.customProgress = [[CustomProgress alloc] initWithFrame:CGRectMake(0.75f, 0.75f, 21, 8)];
    
    self.customProgress.maxValue = 100;
    
    [self.batteryView addSubview:self.customProgress];

}

- (void)dealloc{
    

}

- (void)viewWillDisappear:(BOOL)animated{
    // 注销广播   有注册就要有注销
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
