//
//  OrderInfoCTVC.m
//  Food
//
//  Created by weiquan zhang on 6/20/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import "OrderInfoCTVC.h"
#import "Config.h"

@implementation OrderInfoCTVC

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    CALayer *imageLayer = self.mDescText.layer;
    //[imageLayer setCornerRadius:self.mImageView.frame.size.width/2];
    [imageLayer setCornerRadius:5];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:[UIColor orangeColor].CGColor];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)onCompleteClick:(id)sender {
    //complete action
    NSNotification *msg = [NSNotification notificationWithName:@"CompleteOrder" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:msg];
}

- (void) setLayout:(Order*) o {
    self.data = o;
    self.mIDLabel.text = o.orderId;
    self.mDateLabel.text = o.orderTime;
    self.mRestNameLabel.text = o.restName;
    NSString *pricetxt = [NSString stringWithFormat:@"$%@",o.totalPrice];
    self.mPriceLabel.text = pricetxt;
    if(![o.description isEqual:[NSNull null]]){
        NSAttributedString* desc = [[NSAttributedString alloc] initWithData:[o.description dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        self.mDescText.attributedText = desc;
        self.mDescText.textAlignment = NSTextAlignmentLeft;
        [self.mDescText setFont:[UIFont systemFontOfSize:15]];
    }
    self.mStatusLabel.text = o.status;
    if([o.status_id isEqualToString:@"1"]) {
        //processing status
        [self.mCompleteBtn setHidden:YES];
        [self.mStatusImage setImage:[UIImage imageNamed:@"ic_state_process.png"]];
    } else if ([o.status_id isEqualToString:@"2"]) {
        //accepted status
        [self.mCompleteBtn setHidden:YES];
        [self.mStatusImage setImage:[UIImage imageNamed:@"ic_state_accept.png"]];
    } else if ([o.status_id isEqualToString:@"3"]) {
        //rejected status
        [self.mCompleteBtn setHidden:YES];
        [self.mStatusImage setImage:[UIImage imageNamed:@"ic_state_reject.png"]];
    } else if ([o.status_id isEqualToString:@"4"]) {
        //canceled status
        [self.mCompleteBtn setHidden:YES];
        [self.mStatusImage setImage:[UIImage imageNamed:@"ic_state_cancel.png"]];
    } else if ([o.status_id isEqualToString:@"5"]) {
        //prepared status
        [self.mCompleteBtn setHidden:YES];
        [self.mStatusImage setImage:[UIImage imageNamed:@"ic_state_process.png"]];
    } else if ([o.status_id isEqualToString:@"6"]) {
        //Delivering status
        [self.mCompleteBtn setHidden:NO];
        [self.mStatusImage setImage:[UIImage imageNamed:@"ic_state_process.png"]];
    } else {
        //completed status
        [self.mCompleteBtn setHidden:YES];
        [self.mStatusImage setImage:[UIImage imageNamed:@"ic_state_complete.png"]];
    }
    if(![o.status_id isEqualToString:@"3"]){
        [self.mReasonLabel setHidden:YES];
        [self.mDescText setHidden:YES];
    } else {
        [self.mReasonLabel setHidden:NO];
        [self.mDescText setHidden:NO];
    }
    self.mAddressLabel.text = o.address;
    self.mSubpriceLabel.text = [NSString stringWithFormat:@"$%@", o.subPrice];
    self.mDeliveryFeeLabel.text = [NSString stringWithFormat:@"$%@", o.deliveryFee];
    float totalp = [o.totalPrice floatValue];
    float subp = [o.subPrice floatValue];
    float delp = [o.deliveryFee floatValue];
    float tax = subp * DELIVERY_TAX;
    self.mTipLabel.text = [NSString stringWithFormat:@"$%.2f", totalp - subp - delp - tax];
    self.mTaxLabel.text = [NSString stringWithFormat:@"$%.2f", tax];
    self.mToFirstLabel.text = o.tofirst;
    self.mToLastLabel.text = o.tolast;
    self.mToPhoneLabel.text = o.tophone;
}

@end
