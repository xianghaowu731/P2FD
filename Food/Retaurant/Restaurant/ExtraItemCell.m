//
//  ExtraItemCell.m
//  Food
//
//  Created by meixiang wu on 18/08/2017.
//  Copyright © 2017 Odelan. All rights reserved.
//

#import "ExtraItemCell.h"
#import "Config.h"

@implementation ExtraItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.mCheckBox = [[BEMCheckBox alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
    [self.mCheckView addSubview:self.mCheckBox];
    self.mCheckBox.on = YES;
    self.mCheckBox.onFillColor = PRIMARY_COLOR;
    self.mCheckBox.onTintColor = PRIMARY_COLOR;
    self.mCheckBox.tintColor = PRIMARY_COLOR;
    self.mCheckBox.onCheckColor = WHITE_COLOR;
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(check:)];
    [self.mCheckBox addGestureRecognizer:singleFingerTap];
    
    self.mCheckBox.onAnimationType = BEMAnimationTypeBounce;
    self.mCheckBox.offAnimationType = BEMAnimationTypeBounce;
    self.mCheckBox.boxType = BEMBoxTypeSquare;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)check:(UITapGestureRecognizer *)recognizer {
    //CGPoint location = [recognizer locationInView:[recognizer.view superview]];
    
    /*if(self.mCheckBox.on){
        [self.mCheckBox setOn:NO animated:YES];
        
    } else {
        [self.mCheckBox setOn:YES animated:YES];
    }*/
}

@end
