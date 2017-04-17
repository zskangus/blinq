//
//  NormalCell.h
//  Blinq
//
//  Created by zsk on 16/3/28.
//  Copyright © 2016年 zsk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "customSwitch.h"
#import "RemindNoticeInfo.h"
#import "SMAppModel.h"

@class NormalCell;

@protocol NormalCellDelegate <NSObject>

- (void)cell:(NormalCell*)cell;

@end

@interface NormalCell : UITableViewCell

@property (weak, nonatomic) IBOutlet customSwitch *customSwitch;

@property (weak, nonatomic) IBOutlet UILabel *normalCellLabel;

@property(nonatomic,assign)BOOL isOn;

@property (weak, nonatomic) IBOutlet UIButton *circle;

@property(nonatomic,weak)id<NormalCellDelegate>delegate;

-(void)setCircleColor:(NSInteger)color;

@property(nonatomic,strong)SMAppModel *app;

@end
