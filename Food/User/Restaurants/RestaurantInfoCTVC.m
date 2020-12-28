//
//  RestaurantInfoCTVC.m
//  Food
//
//  Created by weiquan zhang on 6/20/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import "RestaurantInfoCTVC.h"

@implementation RestaurantInfoCTVC

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    CALayer *imageLayer = self.mNameLabel.layer;
    [imageLayer setCornerRadius:5];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:[UIColor orangeColor].CGColor];
        
    imageLayer = self.mEmailLabel.layer;
    [imageLayer setCornerRadius:5];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:[UIColor orangeColor].CGColor];
    
    imageLayer = self.mPhoneLabel.layer;
    [imageLayer setCornerRadius:5];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:[UIColor orangeColor].CGColor];
    
    imageLayer = self.mWorkTimeLabel.layer;
    [imageLayer setCornerRadius:5];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:[UIColor orangeColor].CGColor];
    
    imageLayer = self.mDescText.layer;
    [imageLayer setCornerRadius:5];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:[UIColor orangeColor].CGColor];

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setLayout:(Restaurant*) r {
    self.data = r;
    self.mNameLabel.text = r.name;
    self.mEmailLabel.text = r.email;
    self.mAddress.text = r.address;
    if(![r.phone isEqual:[NSNull null]])
        self.mPhoneLabel.text = r.phone;
    self.mWorkTimeLabel.text = r.worktime;
    if(![r.desc isEqual:[NSNull null]]){
        NSAttributedString* desc = [[NSAttributedString alloc] initWithData:[r.desc dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        self.mDescText.attributedText = desc;
        self.mDescText.textAlignment = NSTextAlignmentLeft;
        [self.mDescText setFont:[UIFont systemFontOfSize:13]];
    }
    //self.mDescText.text = r.desc;
}
@end
