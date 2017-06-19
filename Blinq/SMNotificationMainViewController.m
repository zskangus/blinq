//
//  SMNotificationMainViewController.m
//  Blinq
//
//  Created by zsk on 16/10/9.
//  Copyright © 2016年 zsk. All rights reserved.
//

#import "SMNotificationMainViewController.h"
#import "NormalCell.h"
#import "customSwitch.h"

#import "AppConstant.h"

#import "UIView+Extension.h"

#import "SMConnectedSuccessViewController.h"

#import "SMContactNotificationsViewController.h"

#import "ManAgeContactAlertsCell.h"
#import "ReceiveNotificationCell.h"
#import "SMAppTool.h"
#import "SMAppModel.h"
#import "BTServer.h"
#import "SMMessageManager.h"
#import "SMContactsDescriptionViewController.h"

#import "SMContactTool.h"



@interface SMNotificationMainViewController ()<NormalCellDelegate>

@property(nonatomic,strong)NSMutableArray *systemArray;

@property(nonatomic,strong)SMAppModel *info;

@property(nonatomic,strong)NSMutableArray *apps;

@property(nonatomic,strong)BTServer *defaultBTServer;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

static NSString * const normalCell = @"NormalCell";
static NSString * const receiveNotificationCell = @"ReceiveNotificationCell";
static NSString * const manAgeContactAlertsCell = @"ManAgeContactAlertsCell";

@implementation SMNotificationMainViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [self autoDetectionRingVersion];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedNotif:) name:@"ReloadView" object:nil];
    [self setupAppData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg-Bitmap"]];
    
    [self.tableView setBackgroundView:imageView];
    // 设置背景随表滚动
    //[self.tableView insertSubview:imageView atIndex:0];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"NormalCell" bundle:nil] forCellReuseIdentifier:normalCell];
    [self.tableView registerNib:[UINib nibWithNibName:@"ReceiveNotificationCell" bundle:nil] forCellReuseIdentifier:receiveNotificationCell];
    [self.tableView registerNib:[UINib nibWithNibName:@"ManAgeContactAlertsCell" bundle:nil] forCellReuseIdentifier:manAgeContactAlertsCell];
    
}

- (void)setupAppData{
    // 取得 在链接成功页面里获取到的APP配置信息
    NSMutableArray *apps = [NSMutableArray arrayWithArray:[SMAppTool Apps]];
    
    if (apps.count == 0) {
        [SMMessageManager againSetupNotificationInfo];
    }
    
    // 对象排序
    NSArray *sortedArray = [apps sortedArrayUsingComparator:^NSComparisonResult(SMAppModel *p1, SMAppModel *p2){
        return [p1.title compare:p2.title];
    }];
    NSLog(@"排序前的数组%@,排序后的数组%@",apps,sortedArray);
    
    self.apps = [NSMutableArray array];
    
    self.systemArray = [NSMutableArray array];
    
    NSMutableArray *offApp = [NSMutableArray array];
    
    for (SMAppModel *app in sortedArray) {
        
        if (!([app.title isEqualToString:@"PHONE CALLS"] ||
              [app.title isEqualToString:@"TEXT MESSAGES"]
              )) {
                        if (app.flag == YES) {
                            [self.apps addObject:app];
                        }else{
                            [offApp addObject:app];
                        }
            
            //[self.apps addObject:app];
            
        }else{
            [self.systemArray addObject:app];
        }
        
        NSLog(@"名字:%@,颜色:%ld,开关:%@,config:%llu",app.title,app.colorId,app.flag?@"YES":@"NO",app.config);
    }
        [self.apps addObjectsFromArray:offApp];
    
    [self.tableView reloadData];
}

- (void)upDateAppData{
    
    NSArray *temporaryApps = self.apps;
    NSMutableArray *appsData = [NSMutableArray arrayWithArray:[SMAppTool Apps]];
    
    NSMutableArray *newTemporaryApps = [NSMutableArray array];
    
    for (SMAppModel *temporaryApp in temporaryApps) {
        
        for (SMAppModel *app in appsData) {
            
            if ([temporaryApp.title isEqualToString:app.title]) {
                NSLog(@"临时%@",app.title);
                [newTemporaryApps addObject:app];
            }
            
        }
        
    }

    self.apps = newTemporaryApps;
}

// 代理方法刷新数据源
-(void)cell:(NormalCell *)cell{
    [self upDateAppData];
    NSLog(@"cell代理方法触发");
}

-(void)receivedNotif:(NSNotification *)notification {
    
    [self setupAppData];
    
    [self.tableView reloadData];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
            return 4;
        case 1:
            return self.apps.count;
        default:
            return 0;
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    tableView.separatorStyle = NO;
    
    if (indexPath.section == 0 && (indexPath.row == 0 || indexPath.row == 1)) {
        NormalCell *cell = [tableView dequeueReusableCellWithIdentifier:normalCell forIndexPath:indexPath];
        
        self.info = self.systemArray[indexPath.row];
        
        cell.delegate = self;
        
        cell.circle.hidden = !self.info.flag;
        
        [cell.customSwitch setOn:self.info.flag];
        
        [cell setCircleColor:self.info.colorId];
        
        cell.app = self.info;
        
        [self cellIntervalColor:cell indexPath:indexPath];
        
        
        NSString *titleString = [[NSString alloc]init];
        
        if ([NSLocalizedString(@"language", nil)isEqualToString:@"German"]) {
            
            if ([self.info.title isEqualToString:@"PHONE CALLS"]) {
                titleString = @"TELEFON";
            }
            
            if ([self.info.title isEqualToString:@"TEXT MESSAGES"]) {
                titleString = @"NACHRICHTEN";
            }
            [SKAttributeString setLabelFontContent:cell.normalCellLabel title:titleString font:Avenir_Book Size:16 spacing:2.46 color:[UIColor whiteColor]];

        }else{
            [SKAttributeString setLabelFontContent:cell.normalCellLabel title:self.info.title font:Avenir_Book Size:16 spacing:2.46 color:[UIColor whiteColor]];

        }
        
        
        
        return cell;
    }
    
    if (indexPath.section == 0 && indexPath.row == 2) {
        ReceiveNotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:receiveNotificationCell forIndexPath:indexPath];
        
        if ([SMContactTool contacts].count == 0) {
            [cell.customSmallSwitch setOn:NO];
            [SKUserDefaults setBool:NO forKey:@"contactPower"];
        }
        
        [cell handlerButtonAction:^{
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:[NSLocalizedString(@"tip_manager_contact", nil) uppercaseString] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alertController addAction:okAction];
            
            [alertController setValue:[self setAlertControllerWithStrring:NSLocalizedString(@"tip_manager_contact", nil) fontSize:14 spacing:1.85]  forKey:@"attributedMessage"];
            
            [self presentViewController:alertController animated:YES completion:nil];
            
        }];
        
        [self cellIntervalColor:cell indexPath:indexPath];
        
        return cell;
    }
    
    if (indexPath.section == 0 && indexPath.row == 3) {
        ManAgeContactAlertsCell *cell = [tableView dequeueReusableCellWithIdentifier:manAgeContactAlertsCell forIndexPath:indexPath];
        
        [cell handlerButtonAction:^(NSString *str) {
            
            SMContactNotificationsViewController *contactView = [[SMContactNotificationsViewController alloc]init];
            
            contactView.title = NSLocalizedString(@"nav_title_CONTACT_NOTIFICATIONS", nil);
            
            //            // 避免内容被导航条遮挡
            //            contactView.edgesForExtendedLayout = UIRectEdgeNone;
            //            contactView.extendedLayoutIncludesOpaqueBars = NO;
            //            contactView.modalPresentationCapturesStatusBarAppearance = NO;
            
            UINavigationController *nvc = [[UINavigationController alloc]initWithRootViewController:contactView];
            
            [contactView.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg-navBar"] forBarMetrics:UIBarMetricsDefault];
            
            // 注意需要将图片Render AS选项设置为orignal image选项，保证图片是没有经过渲染的原图。在图片管理器的第三选项卡
            UIBarButtonItem *backArrow = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"BackArrow"] style:UIBarButtonItemStyleDone target:self action:@selector(packupContactView)];
            
            contactView.navigationItem.leftBarButtonItem = backArrow;
            
            BOOL notification_contactVcTurnedOn = [SKUserDefaults boolForKey:@"notification_contactVcTurnedOn"];
            
            if (notification_contactVcTurnedOn == NO) {
                SMContactsDescriptionViewController *description = [[SMContactsDescriptionViewController alloc]initWithNibName:@"SMContactsDescriptionViewController" bundle:nil];
                description.entrance = @"notification";
                
                [SKViewTransitionManager presentModalViewControllerFrom:self to:description duration:0.3 transitionType:TransitionPush directionType:TransitionFromRight];
                
                description.returnBlock = ^(){
                    
                    [self presentViewController:nvc animated:NO completion:nil];
                };
            }else{
                [self presentViewController:nvc animated:YES completion:nil];
            }
            
            
        }];
        
        [self cellIntervalColor:cell indexPath:indexPath];
        
        return cell;
    }
    
    
    NormalCell *cell = [tableView dequeueReusableCellWithIdentifier:normalCell forIndexPath:indexPath];
    
    cell.delegate = self;
    
    self.info = self.apps[indexPath.row];
    
    NSLog(@"---当前%@",self.info.title);
    
    [SKAttributeString setLabelFontContent:cell.normalCellLabel title:[self.info.title uppercaseString] font:Avenir_Book Size:16 spacing:2.46 color:[UIColor whiteColor]];
    
    cell.circle.hidden = !self.info.flag;
    
    cell.circle.tag = indexPath.row;
    
    [cell.customSwitch setOn:self.info.flag];
    
    [cell setCircleColor:self.info.colorId];
    
    cell.app = self.info;
    
    [self cellIntervalColor:cell indexPath:indexPath];
    
    return cell;

    
}

- (void)cellIntervalColor:(UITableViewCell*)cell indexPath:(NSIndexPath *)indexPath{
    // 设置cell 之间的间隔颜色
    UIView *interval = [[UIView alloc] initWithFrame:cell.frame];
    if(indexPath.row % 2 ){
        interval.backgroundColor = [UIColor clearColor];
    }else{
        UIColor *backgroundColor = [UIColor colorWithRed:(29.0/255.0) green:(29.0/255) blue:(38.0/255) alpha:0.07];
        interval.backgroundColor = backgroundColor;
    }
    cell.backgroundView = interval;
    
    cell.backgroundColor=[UIColor clearColor];
    
    
    // 设置cell 不被选中
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)packupContactView{
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.width, 44.0)];
    
    UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0,self.view.width, 44.0)];
    
    headerLabel.opaque = NO;
    headerLabel.textAlignment = NSTextAlignmentCenter;
    headerLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    headerLabel.numberOfLines = 0;
    
    if (section == 0) {
        if ([NSLocalizedString(@"language", nil)isEqualToString:@"German"]) {
            [SKAttributeString setLabelFontContent:headerLabel title:NSLocalizedString(@"notifications_page_headerTitle", nil) font:Avenir_Black Size:14 spacing:4.2 color:[UIColor whiteColor]];
        }else{
            [SKAttributeString setLabelFontContent:headerLabel title:NSLocalizedString(@"notifications_page_headerTitle", nil) font:Avenir_Black Size:14 spacing:4.2 color:[UIColor whiteColor]];
        }
    }else{
        if ([NSLocalizedString(@"language", nil)isEqualToString:@"German"]) {
        [SKAttributeString setLabelFontContent:headerLabel title:NSLocalizedString(@"nav_title_APP_NOTIFICATIONS", nil) font:Avenir_Black Size:14 spacing:4.2 color:[UIColor whiteColor]];
        }else{
        [SKAttributeString setLabelFontContent:headerLabel title:NSLocalizedString(@"nav_title_APP_NOTIFICATIONS", nil) font:Avenir_Black Size:14 spacing:4.2 color:[UIColor whiteColor]];
        }
    }
    
    
    [customView addSubview:headerLabel];
    
    return customView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}


- (void)viewWillDisappear:(BOOL)animated{
    // 注销广播   有注册就要有注销
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
    NSLog(@"触发");
}




@end
