//
//  ContactCell.h
//  Blinq
//
//  Created by zsk on 16/3/29.
//  Copyright © 2016年 zsk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMContactModel.h"

@interface ContactCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *contactImage;

@property (weak, nonatomic) IBOutlet UILabel *contactName;

@property (weak, nonatomic) IBOutlet UIButton *circleButton;

@property(nonatomic,strong)SMContactModel *contact;

@property(nonatomic,copy)NSString *colorStr;

- (void)setpuCirleButton:(NSString *)color;

@end
