//
//  ManAgeContactAlertsCell.m
//  Blinq
//
//  Created by zsk on 16/3/28.
//  Copyright © 2016年 zsk. All rights reserved.
//

#import "ManAgeContactAlertsCell.h"
#import "SKAttributeString.h"


@interface ManAgeContactAlertsCell()
@property (weak, nonatomic) IBOutlet UIButton *manAgeBtn;

@end

@implementation ManAgeContactAlertsCell

- (void)awakeFromNib {

    [super awakeFromNib];
    
    if ([NSLocalizedString(@"language", nil)isEqualToString:@"German"]) {
        [SKAttributeString setButtonFontContent:self.manAgeBtn title:NSLocalizedString(@"manage_selected_contacts_buttonTitle", nil) font:Avenir_Heavy Size:10 spacing:3.6 color:[UIColor whiteColor] forState:UIControlStateNormal];

    }else{
        [SKAttributeString setButtonFontContent:self.manAgeBtn title:NSLocalizedString(@"manage_selected_contacts_buttonTitle", nil) font:Avenir_Heavy Size:12 spacing:3.6 color:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}
- (IBAction)goContactsVc:(id)sender {

    if (self.button) {
        self.button(self.manButton.titleLabel.text);
    }

}

- (void)handlerButtonAction:(BlockButton)block
{
    self.button = block;
}




@end
