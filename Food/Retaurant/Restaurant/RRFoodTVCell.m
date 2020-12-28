//
//  RRFoodTVCell.m
//  Food
//
//  Created by weiquan zhang on 6/15/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import "RRFoodTVCell.h"
#import "Config.h"
#import "RFoodEditVC.h"
#import <UIImageView+WebCache.h>



@implementation RRFoodTVCell
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    CALayer *imageLayer = self.mImageView.layer;
    //[imageLayer setCornerRadius:self.mImageView.frame.size.width/2];
    [imageLayer setCornerRadius:5];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:[UIColor orangeColor].CGColor];
    [self.mImageView setImage:[UIImage imageNamed:@"sample_food.png"]];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.mStatusBackIV.bounds byRoundingCorners:(UIRectCornerTopLeft) cornerRadii:CGSizeMake(5.0, 5.0)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.mStatusBackIV.bounds;
    maskLayer.path  = maskPath.CGPath;
    self.mStatusBackIV.layer.mask = maskLayer;

    //[self setLayout];
}

- (void) setLayout:(Food*) data {
    self.data = data;
    self.mNameLabel.text = self.data.name;
    NSAttributedString* desc = [[NSAttributedString alloc] initWithData:[self.data.desc dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    self.mDescLabel.attributedText = desc;
    self.mDescLabel.textAlignment = NSTextAlignmentLeft;
    [self.mDescLabel setFont:[UIFont systemFontOfSize:15]];
    self.mPriceLabel.text = [NSString stringWithFormat:@"%@%.2f", @"$", self.data.price.floatValue];
    self.mStatusLabel.text = self.data.status;
    NSString* url = [NSString stringWithFormat:@"%@%@%@", SERVER_URL, FOOD_IMAGE_BASE_URL, self.data.img];
    [self.mImageView sd_setImageWithURL:[NSURL URLWithString:url]];
    if([self.data.status isEqualToString:@"active"]) [self.mStatusBackIV setImage:[UIImage imageNamed:@"ic_active.png"]];
    else if([self.data.status isEqualToString:@"inactive"]) [self.mStatusBackIV setImage:[UIImage imageNamed:@"ic_inactive.png"]];
    //[self.techImg sd_setImageWithURL:[NSURL URLWithString:self.mTech.imgUrl]];
}


- (IBAction)onEditClick:(id)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    RFoodEditVC* mVC = [sb instantiateViewControllerWithIdentifier:@"SID_RFoodEditVC"];
    mVC.data = self.data;
    [self.mNavController pushViewController:mVC animated:YES];
}


@end
