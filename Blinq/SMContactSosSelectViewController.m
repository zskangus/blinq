//
//  SMContactSosSelectViewController.m
//  Blinq
//
//  Created by zsk on 16/4/11.
//  Copyright © 2016年 zsk. All rights reserved.
//

#import "SMContactSosSelectViewController.h"
#import <Contacts/Contacts.h>
#import "SosContactCell.h"
#import "contactModel.h"
#import "NSString+PinYin.h"

#define RGBA_COLOR(R, G, B, A) [UIColor colorWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:(A)]

@interface SMContactSosSelectViewController ()

@property(nonatomic,strong)CNContactStore *contactStore;
@property(nonatomic,strong)NSMutableArray *contactArray;

@property(nonatomic,strong)NSMutableArray * dataArr;

@end

static NSString * const sosContactCell = @"sosContactCell";

@implementation SMContactSosSelectViewController

- (CNContactStore *)contactStore{
    if (!_contactStore) {
        _contactStore = [[CNContactStore alloc]init];
    }
    return _contactStore;
}

-(NSMutableArray *)contactArray{
    if (!_contactArray) {
        _contactArray = [NSMutableArray array];
    }
    return _contactArray;
}

-(BOOL)ExamineGetPhoneBookOfJurisdiction{
    // 获取枚举类型，是否允许获取权限的状态
    CNAuthorizationStatus  AuthorizationStatus = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    if (AuthorizationStatus == CNAuthorizationStatusNotDetermined) {
        return NO;
    }else{
        return YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.transform = CGAffineTransformMakeScale([UIScreen mainScreen].bounds.size.width / 375, [UIScreen mainScreen].bounds.size.width / 375);
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg-navBar"] forBarMetrics:UIBarMetricsDefault];
    
    self.title = @"CHOOSE CONTACT";
    
    UIImage *image = [UIImage imageNamed:@"BackArrow"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIBarButtonItem *logoItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStyleDone target:self action:@selector(goBacktoVc)];
    
    self.navigationItem.leftBarButtonItem = logoItem;
    
    self.tableView.delegate = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SosContactCell" bundle:nil] forCellReuseIdentifier:sosContactCell];
    
    UIImageView *imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg-other"]];
    
    [self.tableView setBackgroundView:imageView];
    
    [self obtainContactData];
    
    [self test];
}

- (void)obtainContactData{
    
    CNContactFetchRequest * request = [[CNContactFetchRequest alloc]initWithKeysToFetch:@[CNContactPhoneticFamilyNameKey,CNContactGivenNameKey,CNContactFamilyNameKey,CNContactPhoneNumbersKey,CNContactImageDataKey,CNContactImageDataAvailableKey]];
    
    [self.contactStore enumerateContactsWithFetchRequest:request error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
                NSLog(@"系统里的名字%@",contact.familyName);
        
        contactModel *contactInfo = [[contactModel alloc]init];
        contactInfo.givenName = contact.givenName;
        contactInfo.TfamilyName = contact.familyName;
        contactInfo.phomeNumber = [[contact.phoneNumbers valueForKey:@"value"]valueForKey:@"digits"][0];
        contactInfo.imageData  = [NSData dataWithData:contact.imageData];
        
        if (contactInfo.phomeNumber) {
            [self.contactArray addObject:contactInfo];
        }

        
        NSLog(@"姓%@--名%@--电话%@",contactInfo.TfamilyName,contactInfo.givenName,contactInfo.phomeNumber);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSDictionary * dic = self.dataArr[section];
    NSArray * arr = dic[@"ContactArray"];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SosContactCell *cell = [tableView dequeueReusableCellWithIdentifier:sosContactCell forIndexPath:indexPath];
    
    tableView.separatorStyle = NO;
    
    //contactModel *info = self.contactArray[indexPath.row];
    
    NSDictionary * dic = _dataArr[indexPath.section];
    
    NSArray * arr = dic[@"ContactArray"];
    
    NSArray *givenArray = dic[@"givenName"];
    
    NSArray * image = dic[@"ImageData"];
    
    NSString *name = [NSString stringWithFormat:@"%@%@",arr[indexPath.row],givenArray[indexPath.row]];
    
    // 判断是否为中文
    if ([self isChinese:name]) {
        cell.name.text = name;
    }else{
        NSString *englishName = [NSString stringWithFormat:@"%@ %@",givenArray[indexPath.row],arr[indexPath.row]];
        cell.name.text = englishName;
    }
    

    
    cell.HeadPortrait.image = [UIImage imageWithData:image[indexPath.row]];
    
    if (!cell.HeadPortrait.image) {
        cell.HeadPortrait.image = [UIImage imageNamed:@"headImage"];
    }
    
    cell.HeadPortrait.layer.cornerRadius = cell.HeadPortrait.frame.size.width / 2;
    
    cell.HeadPortrait.clipsToBounds = YES;
    
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
    
    return cell;
}

- (void)test{
    
    self.dataArr = [NSMutableArray array];
    
    NSMutableArray *contactsName = [NSMutableArray array];
    NSMutableArray *contactsImage = [NSMutableArray array];
    NSMutableArray *contactsGivenNmae = [NSMutableArray array];
    NSMutableArray *contactsPhoneNum = [NSMutableArray array];
    
    for (int i = 0; i<self.contactArray.count; i++) {
        contactModel *info = self.contactArray[i];
        [contactsName addObject:info.TfamilyName];
        [contactsImage addObject:info.imageData];
        [contactsGivenNmae addObject:info.givenName];
        [contactsPhoneNum addObject:info.phomeNumber];
    }
    
    for (char i = 'A'; i <= 'Z'; i++)
    {
        NSString * str = [NSString stringWithFormat:@"%c",i];
        
        NSMutableArray * carMuArr = [[NSMutableArray alloc]init];
        
        NSMutableArray * newImageData = [NSMutableArray array];
        
        NSMutableArray * givenNameArray = [NSMutableArray array];
        
        NSMutableArray * newPhoneNum = [NSMutableArray array];
        
        for (int o = 0; o<contactsName.count; o++) {
            
            NSString *familyNameStr = contactsName[o];
            NSString *givenName = contactsGivenNmae[o];
            
            //NSLog(@"++++++%@,%@,%d",carName,contactsImage[o],o);
            
            NSString *trimedString = [familyNameStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if ([trimedString length] == 0) {// 如果姓为空 用名做索引
                
                if ([[givenName getFirstLetter] isEqualToString:str])
                {
                    
                    [carMuArr addObject:familyNameStr];
                    [givenNameArray addObject:givenName];
                    [newImageData addObject:contactsImage[o]];
                    [newPhoneNum addObject:contactsPhoneNum[o]];
                }
            }else{// 姓做索引
                if ([[familyNameStr getFirstLetter] isEqualToString:str])
                {
                    
                    [carMuArr addObject:familyNameStr];
                    [givenNameArray addObject:givenName];
                    [newImageData addObject:contactsImage[o]];
                    [newPhoneNum addObject:contactsPhoneNum[o]];
                }
            }
        
        }
        
        NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
        [dic setObject:str forKey:@"Title"];
        [dic setObject:carMuArr forKey:@"ContactArray"];
        [dic setObject:givenNameArray forKey:@"givenName"];
        [dic setObject:newImageData forKey:@"ImageData"];
        [dic setObject:newPhoneNum forKey:@"PhoneNum"];
        
        [self.dataArr addObject:dic];
    }
    
}
// block传名字及图片数据到联系人设置界面
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary * dic = _dataArr[indexPath.section];
    
    NSArray *givenName = dic[@"givenName"];
    
    NSArray * familyName = dic[@"ContactArray"];
    
    NSString *testName = [NSString stringWithFormat:@"%@%@",familyName[indexPath.row],givenName[indexPath.row]];
    
    NSString *name = [[NSString alloc]init];
    // 判断是否为中文
    if ([self isChinese:testName]) {
        name = [NSString stringWithFormat:@"%@%@",familyName[indexPath.row],givenName[indexPath.row]];
    }else{
        
        name = [NSString stringWithFormat:@"%@ %@",givenName[indexPath.row],familyName[indexPath.row]];
    }
    
    NSString *phoneNum = dic[@"PhoneNum"][indexPath.row];
    
    NSArray * image = dic[@"ImageData"];
    
    NSData *data = image[indexPath.row];
    
    self.infoBlock(name,data,phoneNum);
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

//设置索引名
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    
    tableView.sectionIndexColor = [UIColor whiteColor];
    
    tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    
    NSMutableArray * arr = [[NSMutableArray alloc]init];
    for (NSDictionary * dic in self.dataArr)
    {
        [arr addObject:dic[@"Title"]];
    }
    return arr;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    tableView.sectionIndexColor = [UIColor blackColor];
    NSDictionary * dic = _dataArr[section];
    NSArray *ary = dic[@"ContactArray"];
    if (ary.count == 0) {
        return nil;
    }
    return dic[@"Title"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width,self.view.frame.size.height)];
    
    [view setBackgroundColor:RGBA_COLOR(180, 180, 205, 1)];
    view.alpha = 0.9;
    
    UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.highlightedTextColor = [UIColor whiteColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:17];
    headerLabel.frame = CGRectMake(15, 0.0, self.view.frame.size.width-15,30);
    //headerLabel.textAlignment = NSTextAlignmentCenter;
    
    
    NSDictionary * dic = _dataArr[section];
    NSArray *ary = dic[@"ContactArray"];
    if (ary.count == 0) {
        return nil;
    }
    headerLabel.text = dic[@"Title"];
    
    
    [view addSubview:headerLabel];
    
    return view;

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

- (void)goBacktoVc{

    [self dismissViewControllerAnimated:YES completion:nil];

}


@end
