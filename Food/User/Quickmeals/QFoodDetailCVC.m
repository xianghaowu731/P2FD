//
//  QFoodDetailCVC.m
//  Food
//
//  Created by weiquan zhang on 6/20/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import "QFoodDetailCVC.h"
#import "Config.h"
#import "HttpAPI.h"
#import <UIImageView+WebCache.h>
#import "SVProgressHUD.h"
#import "Customer.h"

extern Customer* customer;

@interface QFoodDetailCVC ()

@end

@implementation QFoodDetailCVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Food Detail";
    self.mDescLabel.editable = false;
    [self setLayout:self.data];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setLayout:(Food*)f {
    self.mNameLabel.text = f.name;
    if(![f.img isEqual:nil] && ![f.img isEqualToString:@""]){
        NSString* url = [NSString stringWithFormat:@"%@%@%@", SERVER_URL, FOOD_IMAGE_BASE_URL, f.img];
        [self.mImageView sd_setImageWithURL:[NSURL URLWithString:url]];
    } else {
        [self.mImageView setImage:[UIImage imageNamed:@"sample_rest.png"]];
    }
    self.mPriceLabel.text = [NSString stringWithFormat:@"%.1f", f.price.floatValue];
    if(![f.desc isEqual:[NSNull null]]){
        NSAttributedString* desc = [[NSAttributedString alloc] initWithData:[f.desc dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        self.mDescLabel.attributedText = desc;
        self.mDescLabel.textAlignment = NSTextAlignmentRight;
        [self.mDescLabel setFont:[UIFont systemFontOfSize:15]];
    }
    
    if(f.is_favorite.intValue == 1){
        [self.mFavoIcon setImage:[UIImage imageNamed:@"hart.png"] forState:UIControlStateNormal];
    } else {
        [self.mFavoIcon setImage:[UIImage imageNamed:@"hart_line.png"] forState:UIControlStateNormal];
    }
    
    self.mByLabel.text = f.restName;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onFavoIconClick:(id)sender {
    [SVProgressHUD show];
    [[HttpApi sharedInstance] updateFoodFavoriteByCustomerId:customer.customerId
                                                      FoodId:self.data.foodId
                                                   Completed:^(long is_favorite){
                                                       [SVProgressHUD dismiss];
                                                       
                                                       if(is_favorite) {
                                                           [self.mFavoIcon setImage:[UIImage imageNamed:@"hart.png"] forState:UIControlStateNormal];
                                                           
                                                       } else {
                                                           [self.mFavoIcon setImage:[UIImage imageNamed:@"hart_line.png"] forState:UIControlStateNormal];
                                                       }
                                                       self.data.is_favorite = [NSNumber numberWithLong:is_favorite];
                                                   }Failed:^(NSString *strError) {
                                                       [SVProgressHUD showErrorWithStatus:strError];
                                                   }];
}
@end
