//
//  OrderDetailUserInfoRTVC.m
//  Food
//
//  Created by weiquan zhang on 6/18/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import "OrderDetailUserInfoRTVC.h"

@implementation OrderDetailUserInfoRTVC

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    /*CALayer *imageLayer = self.mEmailLabel.layer;
    [imageLayer setCornerRadius:3];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:[UIColor orangeColor].CGColor];
    
    imageLayer = self.mPhoneLabel.layer;
    [imageLayer setCornerRadius:3];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:[UIColor orangeColor].CGColor];
    
    imageLayer = self.mAddressLabel.layer;
    [imageLayer setCornerRadius:3];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:[UIColor orangeColor].CGColor];
    
    imageLayer = self.mTotalPriceLabel.layer;
    [imageLayer setCornerRadius:3];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:[UIColor orangeColor].CGColor];
    
    imageLayer = self.mDescText.layer;
    [imageLayer setCornerRadius:3];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:[UIColor orangeColor].CGColor];*/
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setLayout:(Order *)o
{
    
    /*if([c.firstName length] == 0) self.mFirstNameLabel.text = c.userName;
    else self.mFirstNameLabel.text = c.firstName;
    if([c.lastName length] == 0) self.mLastNameLabel.text = @"";
    else self.mLastNameLabel.text = c.lastName;
    if([c.email length] == 0) self.mEmailLabel.text = @"";
    else self.mEmailLabel.text = c.email;
    if([c.phone length] == 0 ) self.mPhoneLabel.text = @"";
    else self.mPhoneLabel.text = c.phone;
    if(addr == (id)[NSNull null]) self.mAddressLabel.text = @"";
    else self.mAddressLabel.text = addr;*/
    self.mFirstNameLabel.text = o.tofirst;
    self.mLastNameLabel.text = o.tolast;
    self.mPhoneLabel.text = o.tophone;
    self.mAddressLabel.text = o.address;
    Customer *c = o.user;
    if([c.email length] == 0) self.mEmailLabel.text = @"";
    else self.mEmailLabel.text = c.email;
    
    self.mTotalPriceLabel.text = [NSString stringWithFormat:@" $%@", o.totalPrice];
    [self.mStatusLabel setHidden:YES];
    
    NSAttributedString* desc = [[NSAttributedString alloc] initWithData:[o.comment dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    self.mDescText.attributedText = desc;
    self.mDescText.textAlignment = NSTextAlignmentLeft;
    [self.mDescText setFont:[UIFont systemFontOfSize:13]];

}


@end
