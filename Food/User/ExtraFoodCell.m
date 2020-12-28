//
//  ExtraFoodCell.m
//  Food
//
//  Created by meixiang wu on 07/03/2018.
//  Copyright © 2018 Odelan. All rights reserved.
//

#import "ExtraFoodCell.h"
#import "Config.h"

@implementation ExtraFoodCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.mCheckBox = [[BEMCheckBox alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
    [self.mCheckView addSubview:self.mCheckBox];
    self.mCheckBox.on = NO;
    self.mCheckBox.onFillColor = CONTROLL_EDGE_COLOR;
    self.mCheckBox.onTintColor = CONTROLL_EDGE_COLOR;
    self.mCheckBox.tintColor = CONTROLL_EDGE_COLOR;
    self.mCheckBox.onCheckColor = PRIMARY_COLOR;
    
    /*UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(check:)];
    [self.mCheckBox addGestureRecognizer:singleFingerTap];*/
    
    self.mCheckBox.onAnimationType = BEMAnimationTypeBounce;
    self.mCheckBox.offAnimationType = BEMAnimationTypeBounce;
    self.mCheckBox.boxType = BEMBoxTypeSquare;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
