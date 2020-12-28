//
//  CartTVC.m
//  Food
//
//  Created by weiquan zhang on 6/27/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import "CartTVC.h"
#import "Config.h"
#import "FMDBHelper.h"
#import "AppDelegate.h"
#import <UIImageView+WebCache.h>

extern FMDBHelper* helper;

@implementation CartTVC

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    CALayer *imageLayer = self.mImageView.layer;
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

- (void) setLayout:(OrderGroup*)f{
    self.data = f;
    for(int i = 0; i < g_Restaurants.count; i++)
    {
        Restaurant *one = (Restaurant *)[g_Restaurants objectAtIndex:i];
        if([one.restaurantId isEqualToString:f.mRestId])
        {
            self.orderRest = one;
        }
    }
    if([self.orderRest.img length]!= 0){
        NSString* url = [NSString stringWithFormat:@"%@%@%@", SERVER_URL, RESTAURANT_IMAGE_BASE_URL, self.orderRest.img];
        [self.mImageView sd_setImageWithURL:[NSURL URLWithString:url]];
    }
    self.mAddress.text = self.orderRest.address;
    self.mRestName.text = [NSString stringWithFormat:@"%@-(%@)", f.mRestName, f.mCount];
    
}

- (IBAction)onRemoveClick:(id)sender {
    [helper deleteOrderByRestId:self.data.mRestId];
    
    NSDictionary *dic = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:@"", nil] forKeys:[NSArray arrayWithObjects:@"cellTag", nil]];
    
    NSNotification *msg = [NSNotification notificationWithName:@"DeleteOrderByRestId" object:nil userInfo:dic];
    [[NSNotificationCenter defaultCenter] postNotification:msg];
}
@end
