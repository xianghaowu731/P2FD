//
//  RFoodDetailVC.m
//  Food
//
//  Created by weiquan zhang on 6/15/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import "RFoodDetailVC.h"
#import "Config.h"
#import <UIImageView+WebCache.h>
#import "SVProgressHUD.h"
#import "HttpApi.h"


@implementation RFoodDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Food Detail";
    [self setLayout:self.data];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setLayout:(Food*) f{
    self.data = f;
    self.mNameLabel.text = self.data.name;
    NSAttributedString* desc = [[NSAttributedString alloc] initWithData:[self.data.desc dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    self.mDescTV.attributedText = desc;
    self.mDescTV.textAlignment = NSTextAlignmentLeft;
    [self.mDescTV setFont:[UIFont systemFontOfSize:13]];
    self.mPriceLabel.text = [NSString stringWithFormat:@"%@%.2f", @"$", self.data.price.floatValue];
    self.mStatusLabel.text = self.data.status;
    NSString* url = [NSString stringWithFormat:@"%@%@%@", SERVER_URL, FOOD_IMAGE_BASE_URL, self.data.img];
    [self.mImageView sd_setImageWithURL:[NSURL URLWithString:url]];
    
    if(![self.mType isEqualToString:@"rest"]){
        [self.mDelBtn setHidden:YES];
        [self.mQuickBtn setTitle:@"Delete From QuickMeals" forState:UIControlStateNormal];
    } else {
        [self.mDelBtn setHidden:NO];
        [self.mQuickBtn setTitle:@"Add To QuickMeals" forState:UIControlStateNormal];
    }
}

- (IBAction)onClickDelete:(id)sender {
    
    [SVProgressHUD show];
    
    [[HttpApi sharedInstance] delFoodByFoodId:self.data.foodId Completed:^(NSString *array){
        [SVProgressHUD dismiss];
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Success"
                                      message:@"Successfully removed."
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"Ok"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        [self.navigationController popViewControllerAnimated:YES];
                                        
                                    }];
        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }Failed:^(NSString *strError) {
        [SVProgressHUD showErrorWithStatus:strError];
    }];
}

- (IBAction)onClickQuick:(id)sender {
    if([self.mType isEqualToString:@"rest"]){
        [SVProgressHUD show];

        [[HttpApi sharedInstance] addToQuickMealsByFoodId:self.data.foodId Completed:^(NSString *array){
            [SVProgressHUD dismiss];
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@"Success"
                                          message:@"Successfully added to QuickMeals"
                                          preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* yesButton = [UIAlertAction
                                        actionWithTitle:@"Ok"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action)
                                        {
                                            //Handel your yes please button action here
                                            
                                        }];
            [alert addAction:yesButton];
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }Failed:^(NSString *strError) {
            [SVProgressHUD showErrorWithStatus:strError];
        }];

    } else {
        [SVProgressHUD show];
        
        [[HttpApi sharedInstance] delFromQuickMealsByFoodId:self.data.foodId Completed:^(NSString *array){
            [SVProgressHUD dismiss];
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@"Success"
                                          message:@"Successfully removed from QuickMeals"
                                          preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* yesButton = [UIAlertAction
                                        actionWithTitle:@"Ok"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action)
                                        {
                                            [self.navigationController popViewControllerAnimated:YES];
                                            
                                        }];
            [alert addAction:yesButton];
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }Failed:^(NSString *strError) {
            [SVProgressHUD showErrorWithStatus:strError];
        }];
    }
}
@end
