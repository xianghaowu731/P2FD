//
//  SkipVC.m
//  Food
//
//  Created by weiquan zhang on 6/20/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import "SkipVC.h"
#import "Login.h"
#import "Restaurant.h"
#import "Customer.h"
#import "GuestSelectView.h"
#import "Deliver.h"

@interface SkipVC ()

@end

Restaurant* owner;
Customer* customer;
Deliver* deliver;

@implementation SkipVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated{
    customer = [[Customer alloc] init];
    customer.customerId = @"0";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onSkipClick:(id)sender {
    /*UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITabBarController* mVC = [sb instantiateViewControllerWithIdentifier:@"SID_CustomerTabBar"];
    mVC.modalTransitionStyle = UIModalPresentationNone;
    [self presentViewController:mVC animated:YES completion:NULL];*/
    GuestSelectView* mVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_GuestSelectView"];
    [self.navigationController pushViewController:mVC animated:YES];
}

- (IBAction)onLoginClick:(id)sender {
    Login* mVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_Login"];
    [self.navigationController pushViewController:mVC animated:YES];
}
@end
