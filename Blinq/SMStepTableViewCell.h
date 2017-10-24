//
//  SMStepTableViewCell.h
//  Blinq
//
//  Created by zsk on 2017/8/2.
//  Copyright © 2017年 zsk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "customSwitch.h"

@interface SMStepTableViewCell : UITableViewCell

typedef void(^receiveBlockButton)(void);

typedef void(^receiveBlockSwitch)(NSInteger tag,BOOL power);

- (void)buttonAction:(receiveBlockButton)block;

- (void)switchAction:(receiveBlockSwitch)block;

@property (weak, nonatomic) IBOutlet customSwitch *customSwitch;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) IBOutlet UILabel *Label;

@property (strong, nonatomic) IBOutlet UILabel *contentLabel;

@property (strong, nonatomic) IBOutlet UILabel *targetSteps;

@property (strong, nonatomic) IBOutlet UIButton *leftButton;

@property (strong, nonatomic) IBOutlet UIButton *rightButton;

+ (instancetype)stepTableViewCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

- (void)configStepCellWith:(NSIndexPath *)indexPath;

@end
