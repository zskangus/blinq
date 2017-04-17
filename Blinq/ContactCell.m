//
//  ContactCell.m
//  Blinq
//
//  Created by zsk on 16/3/29.
//  Copyright © 2016年 zsk. All rights reserved.
//

#import "ContactCell.h"
#import "MessageMacro.h"
#import "SMContactTool.h"

#import "SMPlayViewController.h"

#import "SMInstructionsClass.h"

@interface ContactCell()

@property(nonatomic,strong)SMPlayViewController *changColor;

@end

@implementation ContactCell

- (SMPlayViewController *)changColor{
    if (!_changColor) {
        _changColor = [[SMPlayViewController alloc]init];
    }
    
    return _changColor;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    if (!self.colorStr) {
        self.colorStr = @"circleRedBig";
    }
    //[self setpuCirleButton];
    
}

- (IBAction)clickCircleButton:(id)sender {
    
    Byte colorByte;
    
    NSArray *colorArray = @[@"circleChingBig",@"circleBlueBig",@"circlePurpleBig",@"circleRedBig"];
    
    NSUInteger typeNO = [colorArray indexOfObject:self.colorStr];
    
    typeNO++;
    
    if (typeNO > 3) {
        typeNO = 0;
    }
    
    switch (typeNO) {
        case 0:
            colorByte = Color_GREEN;
            break;
        case 1:
            colorByte = Color_BLUE;
            break;
        case 2:
            colorByte = Color_PURPLE;
            break;
        case 3:
            colorByte = Color_RED;
            break;
        default:
            break;
    }
    
    // 点击换色
    [SMInstructionsClass notificationChangeColor:colorByte];
    
    self.colorStr = colorArray[typeNO];
    
    [self.circleButton setImage:[UIImage imageNamed:self.colorStr] forState:UIControlStateNormal];
    
    [SMContactTool updataContact:self.contact.name color:self.colorStr];
    
    NSLog(@"--名字%@--颜色%@",self.contact.name,self.colorStr);
    
}


- (void)setpuCirleButton:(NSString *)color{
    
    self.colorStr = color;

    
    [self.circleButton setImage:[UIImage imageNamed:color] forState:UIControlStateNormal];
}



@end
