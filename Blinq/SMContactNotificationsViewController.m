//
//  SMContactNotificationsViewController.m
//  Blinq
//
//  Created by zsk on 16/3/29.
//  Copyright © 2016年 zsk. All rights reserved.
//

#import "SMContactNotificationsViewController.h"
#import "ContactCell.h"
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>
#import "SMContactSosSelectViewController.h"

#import "SMContactModel.h"
#import "SMContactTool.h"

@interface SMContactNotificationsViewController ()<CNContactPickerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,strong)ContactCell *contactCell;

@property (nonatomic,strong)NSMutableArray *contacArray;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UILabel *addContactBtn;

@end

static NSString * const contactCell = @"ContactCell";

@implementation SMContactNotificationsViewController

-(ContactCell *)contactCell{
    if (!_contactCell) {
        _contactCell = [[ContactCell alloc]init];
    }
    return _contactCell;
}

-(NSMutableArray *)contacArray{
    if (!_contacArray) {
        _contacArray = [NSMutableArray array];
    }
    return _contacArray;
}

-(void)viewWillAppear:(BOOL)animated{
    [self SetupContacts];
    [self autoDetectionRingVersion];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(beginEditing) name:@"beginEditing" object:nil];
    
    // 设置导航栏title的显示效果
    NSDictionary *TitleDict = @{NSFontAttributeName:[UIFont fontWithName: @"Avenir" size:16],
                                NSForegroundColorAttributeName:[UIColor whiteColor],
                                NSKernAttributeName:@2.46};
    
    [[UINavigationBar appearance]setTitleTextAttributes:TitleDict];
    
    [SKUserDefaults setBool:YES forKey:@"inContactPage"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"进入VIP联系人界面");
    
    [self setupUI];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ContactCell" bundle:nil] forCellReuseIdentifier:contactCell];

    UIImageView *imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg-other"]];
    
    // 隐藏Cell的分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView setBackgroundColor:[UIColor clearColor]];

}

- (void)setupUI{
    
    NSString *string = NSLocalizedString(@"contacts_page_describe", nil);
    
    if ([NSLocalizedString(@"language", nil)isEqualToString:@"German"]) {
        [SKAttributeString setLabelFontContent:self.label title:[string uppercaseString] font:Avenir_Heavy Size:10 spacing:3 color:[UIColor whiteColor]];
        [SKAttributeString setLabelFontContent:self.addContactBtn title:NSLocalizedString(@"add_contact_buttonTitle", nil) font:Avenir_Book Size:12 spacing:2 color:[UIColor whiteColor]];

    }else if ([NSLocalizedString(@"language", nil)isEqualToString:@"中文"]){
        [SKAttributeString setLabelFontContent:self.label title:[string uppercaseString] font:Avenir_Heavy Size:16 spacing:3.6 color:[UIColor whiteColor]];
        [SKAttributeString setLabelFontContent:self.addContactBtn title:NSLocalizedString(@"add_contact_buttonTitle", nil) font:Avenir_Book Size:16 spacing:2.46 color:[UIColor whiteColor]];
    }else{
        [SKAttributeString setLabelFontContent:self.label title:[string uppercaseString] font:Avenir_Heavy Size:12 spacing:3.6 color:[UIColor whiteColor]];
        [SKAttributeString setLabelFontContent:self.addContactBtn title:NSLocalizedString(@"add_contact_buttonTitle", nil) font:Avenir_Book Size:16 spacing:2.46 color:[UIColor whiteColor]];
    }
}

// 添加联系人
- (IBAction)addContact:(id)sender {
    
    // 1.创建选择联系人的控制器
    CNContactPickerViewController *contactVc = [[CNContactPickerViewController alloc] init];
    
    // 设置导航栏title的显示效果
    NSDictionary *TitleDict = @{NSForegroundColorAttributeName:[UIColor blackColor],
                                NSKernAttributeName:@2.46};
    
    [[UINavigationBar appearance]setTitleTextAttributes:TitleDict];
    
    // 2.设置代理
    contactVc.delegate = self;
    
    // 3.弹出控制器
    [self presentViewController:contactVc animated:YES completion:nil];
    
}

#pragma mark - <CNContactPickerDelegate>
// 当选中某一个联系人时会执行该方法
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact
{
    
    SMContactModel *contactInfo = [[SMContactModel alloc]init];
    
    NSLog(@"%@",contact);
    
    // 1.获取联系人的姓名
    NSString *testName = [NSString stringWithFormat:@"%@%@",contact.familyName,contact.givenName];
    
    if ([self isChinese:testName]) {
        testName = [NSString stringWithFormat:@"%@%@",contact.familyName,contact.givenName];
    }else{
        
        if ([contact.familyName isEqualToString:@""] || [contact.givenName isEqualToString:@""]) {
            testName = [NSString stringWithFormat:@"%@%@",contact.givenName,contact.familyName];
        }else{
            testName = [NSString stringWithFormat:@"%@ %@",contact.givenName,contact.familyName];
        }
    }

    
    if ([testName isEqualToString:@""] || [testName isEqualToString:@" "]) {
        testName = contact.organizationName;
    }
    
    NSLog(@"姓名:(%@)",testName);
    
    contactInfo.name = testName;
    
    contactInfo.familyName = contact.familyName;
    
    contactInfo.givenName = contact.givenName;
    
    contactInfo.organizationName = contact.organizationName;
    
    // 2.获取联系人的电话号码
    NSArray *phoneNums = contact.phoneNumbers;
    for (CNLabeledValue *labeledValue in phoneNums) {
        // 2.1.获取电话号码的KEY
        NSString *phoneLabel = labeledValue.label;
        
        // 2.2.获取电话号码
        CNPhoneNumber *phoneNumer = labeledValue.value;
        NSString *phoneValue = phoneNumer.stringValue;
    
        contactInfo.phoneNum = phoneValue;
        
        NSLog(@"%@ 电话:(%@)", phoneLabel, phoneValue);
    }
    
    contactInfo.photo = contact.imageData;
    
    contactInfo.circleColor = @"circleRedBig";

    [SMContactTool addContact:contactInfo];
    
    self.contacArray = [NSMutableArray arrayWithArray:[SMContactTool contacts]];
    
    [self.tableView reloadData];

}

// 当选中某一个联系人的某一个属性时会执行该方法
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty
{
}

// 点击了取消按钮会执行该方法
- (void)contactPickerDidCancel:(CNContactPickerViewController *)picker
{  
}

-(BOOL)isChinese:(NSString *)phoneNum
{
    // 只需要不是中文即可
    NSString *regex = @".{0,}[\u4E00-\u9FA5].{0,}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self matches %@",regex];
    BOOL res = [predicate evaluateWithObject:phoneNum];
    if (res == TRUE) {
        //NSLog(@"中文");
        return YES;
    }
    else
    {
        //NSLog(@"英文");
        return NO;
    }
}

- (void)SetupContacts{
    
    self.contacArray = [NSMutableArray arrayWithArray:[SMContactTool contacts]];
    
    [self.tableView reloadData];
}

- (void)beginEditing{//导航栏的编辑按钮
    
    // 开启表视图的编辑功能
    [self.tableView setEditing:!self.tableView.editing animated:YES];// 编辑功能图标   及   是否显示动画

}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.contacArray.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ContactCell *cell = [tableView dequeueReusableCellWithIdentifier:contactCell forIndexPath:indexPath];
    
    // 选中后颜色不变
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    SMContactModel *contact = self.contacArray[indexPath.row];
    
    cell.contactImage.image = [UIImage imageWithData:contact.photo];
    
    if (!cell.contactImage.image) {
        cell.contactImage.image = [UIImage imageNamed:@"headImage"];
    }
    
    cell.contactImage.layer.cornerRadius = cell.contactImage.frame.size.width / 2;
    
    cell.contactImage.clipsToBounds = YES;
    
    cell.contactName.text = [contact.name uppercaseString];
    
    cell.contact = contact;
    
    [cell setpuCirleButton:contact.circleColor];
    
    NSLog(@"contact%@",contact.circleColor);
    
    cell.tag = indexPath.row;
    
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
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

#pragma mark - 表格编辑模式的两问一答(增加删除)    //增加和删除是共用两问一答的
// 问1:行是否可以编辑
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (tableView.editing) {
        NSLog(@"编辑");

    }else{
        NSLog(@"取消编辑");
    }
    

    return YES;

}

// 问2:行是什么编辑样式
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewCellEditingStyleDelete;//删除样式
    

}


// 答1:确认提交编辑动作
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{// 响应动作
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {//如果点击的是删除按钮
        // 1. 修改数据模型中的数据
        // 修改数据库
        SMContactModel *contact = self.contacArray[indexPath.row];
        [SMContactTool deleteContact:contact.name];
        
        // 修改数组
        [self.contacArray removeObjectAtIndex:indexPath.row];//按照行号删除
        
        NSLog(@"contacArray数组数量%ld",self.contacArray.count);
        
        // 2. 更新界面
        //[tableView reloadData];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
        
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"hang %ld",indexPath.row);
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [SKNotificationCenter removeObserver:self];
    [SKUserDefaults setBool:NO forKey:@"inContactPage"];

    NSLog(@"退出VIP联系人界面");
}



@end
