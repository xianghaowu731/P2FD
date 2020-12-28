//
//  OrderListCTVC.m
//  Food
//
//  Created by weiquan zhang on 6/20/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import "OrderListCTVC.h"
#import "Config.h"
#import <UIImageView+WebCache.h>

@implementation OrderListCTVC

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    CALayer *imageLayer = self.mImageView.layer;
    //[imageLayer setCornerRadius:self.mImageView.frame.size.width/2];
    [imageLayer setCornerRadius:5];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:[UIColor orangeColor].CGColor];
    [self.mImageView setImage:[UIImage imageNamed:@"sample_rest.png"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void) setLayout:(Order*)o {
    if(![self.mRest.img isEqual:nil] && ![self.mRest.img isEqualToString:@""]){
        NSString* url = [NSString stringWithFormat:@"%@%@%@", SERVER_URL, RESTAURANT_IMAGE_BASE_URL, self.mRest.img];
        [self.mImageView sd_setImageWithURL:[NSURL URLWithString:url]];
    } else [self.mImageView setImage:[UIImage imageNamed:@"sample_rest.png"]];
    
    self.data = o;
    self.mIDLabel.text = o.orderId;
    self.mDateLabel.text = [NSString stringWithFormat:@"order: %@", o.orderTime];
    self.mStatusLabel.text = o.status;
    self.mRestNameLabel.text = o.restName;
    self.mDeliverTime.text = o.fromtime;
    self.mPriceLabel.text = [NSString stringWithFormat:@"$%@", o.totalPrice];
}
@end
