//
//  RFoodTVCell.m
//  Food
//
//  Created by weiquan zhang on 6/15/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import "RFoodTVCell.h"
#import "Config.h"
#import "HttpApi.h"
#import <UIImageView+WebCache.h>

@implementation RFoodTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    CALayer *imageLayer = self.mImageView.layer;
    //[imageLayer setCornerRadius:self.mImageView.frame.size.width/2];
    [imageLayer setCornerRadius:3];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:[UIColor orangeColor].CGColor];
    [self.mImageView setImage:[UIImage imageNamed:@"sample_food.png"]];
}

- (void)setLayout:(Food *)f {
    self.data = f;
    self.mNameLabel.text = f.name;
    if(![f.img isEqual:nil] && ![f.img isEqualToString:@""]){
        NSString* url = [NSString stringWithFormat:@"%@%@%@", SERVER_URL, FOOD_IMAGE_BASE_URL, f.img];
        [self.mImageView sd_setImageWithURL:[NSURL URLWithString:url]];
    } else {
        [self.mImageView setImage:[UIImage imageNamed:@"sample_rest.png"]];
    }
    self.mPriceLabel.text = [NSString stringWithFormat:@"$%.2f", f.price.floatValue];
    if(![f.desc isEqual:[NSNull null]]){
        NSAttributedString* desc = [[NSAttributedString alloc] initWithData:[f.desc dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        self.mDescLabel.attributedText = desc;
        self.mDescLabel.textAlignment = NSTextAlignmentLeft;
        [self.mDescLabel setFont:[UIFont systemFontOfSize:13]];
    }
    self.mCountLabel.text = [NSString stringWithFormat:@"%@",f.count];
    /*NSInteger cateId = [f.categoryId integerValue];
    if(cateId == 1) self.mCategory.text = @"APPETIZERS";
    else if(cateId == 2) self.mCategory.text = @"SOUPS, SALADS & MORE";
    else if(cateId == 3) self.mCategory.text = @"ENTREES";
    else if(cateId == 4) self.mCategory.text = @"DESSERTS";
    else if(cateId == 5) self.mCategory.text = @"DRINKS";*/
    
}
@end
