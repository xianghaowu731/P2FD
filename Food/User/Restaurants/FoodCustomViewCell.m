//
//  FoodCustomViewCell.m
//  Food
//
//  Created by meixiang wu on 6/2/17.
//  Copyright © 2017 Odelan. All rights reserved.
//

#import "FoodCustomViewCell.h"
#import "SVProgressHUD.h"
#import "HttpApi.h"
#import "Customer.h"
#import "Food.h"
#import "Config.h"
#import <UIImageView+WebCache.h>
#import "FMDBHelper.h"
#import "Customer.h"

extern Customer* customer;
extern FMDBHelper *helper;

@implementation FoodCustomViewCell

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
    helper = [FMDBHelper sharedInstance];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void) setLayout:(Food*)f {
    self.data = f;
    self.mNameLabel.text = f.name;
    if(![f.img isEqual:nil] && ![f.img isEqualToString:@""]){
        NSString* url = [NSString stringWithFormat:@"%@%@%@", SERVER_URL, FOOD_IMAGE_BASE_URL, f.img];
        [self.mImageView sd_setImageWithURL:[NSURL URLWithString:url]];
    } else {
        [self.mImageView setImage:[UIImage imageNamed:@"sample_food.png"]];
    }
    self.mPriceLabel.text = [NSString stringWithFormat:@"$%.2f", f.price.floatValue];
    if(![f.desc isEqual:[NSNull null]]){
        /*NSAttributedString* desc = [[NSAttributedString alloc] initWithData:[f.desc dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];*/
        self.mDescription.text = f.desc;
    }
    self.mCountLabel.text = @"";
    if(f.is_favorite != nil){
        if(f.is_favorite.intValue == 1){
            [self.mFavIcon setImage:[UIImage imageNamed:@"hart.png"] forState:UIControlStateNormal];
        } else {
            [self.mFavIcon setImage:[UIImage imageNamed:@"hart_line.png"] forState:UIControlStateNormal];
        }
    } else {
        [self.mFavIcon setImage:[UIImage imageNamed:@"hart.png"] forState:UIControlStateNormal];
    }
    
}

- (IBAction)onFavIconClick:(id)sender {
    [SVProgressHUD show];
    [[HttpApi sharedInstance] updateFoodFavoriteByCustomerId:customer.customerId
                                                      FoodId:self.data.foodId
                                                   Completed:^(long is_favorite){
                                                       [SVProgressHUD dismiss];
                                                       
                                                       if(is_favorite) {
                                                           [self.mFavIcon setImage:[UIImage imageNamed:@"hart.png"] forState:UIControlStateNormal];
                                                           
                                                       } else {
                                                           [self.mFavIcon setImage:[UIImage imageNamed:@"hart_line.png"] forState:UIControlStateNormal];
                                                       }
                                                       self.data.is_favorite = [NSNumber numberWithLong:is_favorite];
                                                       NSNumber* nTag = [NSNumber numberWithInteger:[self.data.cID integerValue]];
                                                       
                                                       NSDictionary *dic = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:nTag, self.data.is_favorite, nil] forKeys:[NSArray arrayWithObjects:@"cellTag", @"isfavorite", nil]];
                                                       
                                                       NSNotification *msg = [NSNotification notificationWithName:@"ChangedFavorite" object:nil userInfo:dic];
                                                       [[NSNotificationCenter defaultCenter] postNotification:msg];
                                                   }Failed:^(NSString *strError) {
                                                       [SVProgressHUD showErrorWithStatus:strError];
                                                   }];
}

- (IBAction)onPlusIconClick:(id)sender {
    [helper updateFood:self.data Quantity:1];
    NSNotification *msg = [NSNotification notificationWithName:@"PlusOrder" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:msg];
}

- (IBAction)onFoodDetailClick:(id)sender {
    Food *one = self.data;
    NSNotification *msg = [NSNotification notificationWithName:@"FoodDetailView" object:nil userInfo:(NSDictionary*)one];
    [[NSNotificationCenter defaultCenter] postNotification:msg];
}

@end
