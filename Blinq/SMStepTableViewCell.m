//
//  SMStepTableViewCell.m
//  Blinq
//
//  Created by zsk on 2017/8/2.
//  Copyright © 2017年 zsk. All rights reserved.
//

#import "SMStepTableViewCell.h"
#import "SKAttributeString.h"
#import "SMBlinqInfo.h"
#import "SMStepDB.h"

@interface SMStepTableViewCell()<customSwitchDelegate>

@property (nonatomic, copy)receiveBlockButton button;

@property (nonatomic, copy)receiveBlockSwitch switchs;
@end

@implementation SMStepTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.customSwitch.delegate = self;

}

+ (instancetype)stepTableViewCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"";//对应xib中设置的identifier
    NSInteger index = 0; //xib中第几个Cell
    switch (indexPath.row) {
        case 0:
            identifier = @"stepCounterCell";
            index = 0;
            break;
        case 1:
            identifier = @"appleHealthCell";
            index = 1;
            break;
        case 2:
            identifier = @"targetStepsCell";
            index = 2;
            break;
        case 3:
            identifier = @"ageCell";
            index = 3;
            break;
        case 4:
            identifier = @"heightCell";
            index = 4;
            break;
        case 5:
            identifier = @"weightCell";
            index = 5;
            break;
            
        default:
            break;
    }
    SMStepTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SMStepTableViewCell" owner:self options:nil] objectAtIndex:index];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
    
}

- (void)configStepCellWith:(NSIndexPath *)indexPath{
    
    SMPersonalModel *userInfo = [SMBlinqInfo userInfo];

    switch (indexPath.row) {
        case 0: {
            [SKAttributeString setLabelFontContent:self.titleLabel title:NSLocalizedString(@"step_counter", nil) font:Avenir_Book Size:17 spacing:5 color:[UIColor whiteColor]];
            self.customSwitch.tag = 1;
            [self.customSwitch setOn:[SMBlinqInfo stepCounterPower]];
            
            break;
        }
        case 1: {
            [SKAttributeString setLabelFontContent:self.titleLabel title:NSLocalizedString(@"apple_health", nil) font:Avenir_Book Size:17 spacing:5 color:[UIColor whiteColor]];
            self.customSwitch.tag = 2;
            [self.customSwitch setOn:[SMBlinqInfo appleHealthPower]];

            break;
        }
        case 2: {
            [SKAttributeString setLabelFontContent:self.titleLabel title:NSLocalizedString(@"step_counter", nil) font:Avenir_Heavy Size:17 spacing:5 color:[UIColor whiteColor]];
            
            [SKAttributeString setLabelFontContent:self.targetSteps title:[NSString stringWithFormat:@"%ld",(long)[SMBlinqInfo targetSteps]] font:Avenir_Heavy Size:53 spacing:5 color:[UIColor whiteColor]];
            
            [SKAttributeString setLabelFontContent:self.Label title:NSLocalizedString(@"daily_step_goal", nil) font:Avenir_Book Size:17 spacing:5 color:[UIColor whiteColor]];
            
            [self.leftButton addTarget:self action:@selector(setTargetStepsValue:) forControlEvents:UIControlEventTouchUpInside];
            self.leftButton.tag = 1;
            
            [self.rightButton addTarget:self action:@selector(setTargetStepsValue:) forControlEvents:UIControlEventTouchUpInside];
            self.rightButton.tag = 2;

            break;
        }
        case 3: {
            [SKAttributeString setLabelFontContent:self.titleLabel title:NSLocalizedString(@"age", nil) font:Avenir_Book Size:17 spacing:5 color:[UIColor whiteColor]];
            [SKAttributeString setLabelFontContent:self.contentLabel title:[NSString stringWithFormat:@"%ld %@",(long)userInfo.age,NSLocalizedString(@"years_old", nil)] font:Avenir_Book Size:17 spacing:5 color:[UIColor whiteColor]];

            break;
        }
        case 4: {
            [SKAttributeString setLabelFontContent:self.titleLabel title:NSLocalizedString(@"height", nil) font:Avenir_Book Size:17 spacing:5 color:[UIColor whiteColor]];
            //[SKAttributeString setLabelFontContent:self.contentLabel title:[NSString stringWithFormat:@"%.0f CM",userInfo.height] font:Avenir_Book Size:17 spacing:5 color:[UIColor whiteColor]];
            
            if (userInfo.heightString.length <= 0) {
                userInfo.heightString = @"0'0\"";
            }
            [SKAttributeString setLabelFontContent:self.contentLabel title:userInfo.heightString font:Avenir_Book Size:17 spacing:5 color:[UIColor whiteColor]];


            break;
        }
        case 5: {
            [SKAttributeString setLabelFontContent:self.titleLabel title:NSLocalizedString(@"weight", nil) font:Avenir_Book Size:17 spacing:5 color:[UIColor whiteColor]];
            [SKAttributeString setLabelFontContent:self.contentLabel title:[NSString stringWithFormat:@"%.0f LBS",userInfo.weight] font:Avenir_Book Size:17 spacing:5 color:[UIColor whiteColor]];

            break;
        }
        default:
            break;
    }

    
    // 设置cell 之间的间隔颜色
    UIView *interval = [[UIView alloc] initWithFrame:self.frame];
    if(indexPath.row % 2 ){
        UIColor *backgroundColor = [UIColor colorWithRed:(255.0/255.0) green:(255.0/255) blue:(255.0/255) alpha:0.1];
        interval.backgroundColor = backgroundColor;
    }else{
        interval.backgroundColor = [UIColor clearColor];
    }
    self.backgroundView = interval;
    
    self.backgroundColor = [UIColor clearColor];
}

- (void)clickSwitch:(customSwitch *)Switch withBOOL:(BOOL)isOn{
    self.switchs(Switch.tag,isOn);
}

- (void)setTargetStepsValue:(UIButton*)button{
    
    NSInteger steps = [SMBlinqInfo targetSteps];
    
    switch (button.tag) {
        case 1:
            steps -= 100;
            break;
        case 2:
            steps += 100;
            break;
            
        default:
            break;
    }
    if (steps < 2000) {
        steps = 2000;
    }
    
    if (steps > 30000) {
        steps = 30000;
    }
    
    [SKAttributeString setLabelFontContent:self.targetSteps title:[NSString stringWithFormat:@"%ld",(long)steps] font:Avenir_Heavy Size:53 spacing:5 color:[UIColor whiteColor]];
    [SMBlinqInfo setTargetSteps:steps];
    
    SMStepModel *sd = [SMStepDB stepInfos].lastObject;
    
    sd.targetSteps = steps;
    
    [SMStepDB updataStepsInfo:sd];
    //self.button();
}

- (void)buttonAction:(receiveBlockButton)block{
    self.button = block;
}

- (void)switchAction:(receiveBlockSwitch)block{
    self.switchs = block;
}

@end
