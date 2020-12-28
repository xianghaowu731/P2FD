//
//  OrderFoodCTVC.m
//  Food
//
//  Created by weiquan zhang on 6/20/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import "OrderFoodCTVC.h"
#import "Config.h"
#import <UIImageView+WebCache.h>

@implementation OrderFoodCTVC

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    CALayer *imageLayer = self.mImageView.layer;
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

- (void)setLayout:(OrderedFood*) of{
    self.data = of;
    self.mNameLabel.text = of.name;
    if(![of.img isEqual:nil] && ![of.img isEqualToString:@""]){
        NSString* url = [NSString stringWithFormat:@"%@%@%@", SERVER_URL, FOOD_IMAGE_BASE_URL, of.img];
        [self.mImageView sd_setImageWithURL:[NSURL URLWithString:url]];
    } else {
        [self.mImageView setImage:[UIImage imageNamed:@"sample_rest.png"]];
    }
    self.mPriceLabel.text = [NSString stringWithFormat:@"%.2f", of.price.floatValue];
    if(![of.desc isEqual:[NSNull null]]){
        NSAttributedString* desc = [[NSAttributedString alloc] initWithData:[of.desc dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        self.mDescLabel.attributedText = desc;
        self.mDescLabel.textAlignment = NSTextAlignmentLeft;
        [self.mDescLabel setFont:[UIFont systemFontOfSize:13]];
    }
    self.mCountLabel.text = of.count;
    
}

@end
