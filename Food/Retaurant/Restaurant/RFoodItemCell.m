//
//  RFoodItemCell.m
//  Food
//
//  Created by meixiang wu on 5/13/17.
//  Copyright © 2017 Odelan. All rights reserved.
//

#import "RFoodItemCell.h"

@implementation RFoodItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    CALayer *imageLayer = self.mImageView.layer;
    //[imageLayer setCornerRadius:self.mImageView.frame.size.width/2];
    [imageLayer setCornerRadius:6];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:[UIColor orangeColor].CGColor];
    [self.mImageView setImage:[UIImage imageNamed:@"sample_food.png"]];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.mStatusIV.bounds byRoundingCorners:(UIRectCornerTopLeft) cornerRadii:CGSizeMake(7.0, 7.0)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.mStatusIV.bounds;
    maskLayer.path  = maskPath.CGPath;
    self.mStatusIV.layer.mask = maskLayer;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
