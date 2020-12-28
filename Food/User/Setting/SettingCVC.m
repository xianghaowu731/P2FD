//
//  SettingCVC.m
//  Food
//
//  Created by weiquan zhang on 6/17/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import "SettingCVC.h"
#import "Config.h"
#import "AccountCVC.h"
#import "OtherCVC.h"
#import "SplashVC.h"
#import "Customer.h"
#import "Login.h"

extern Customer* customer;

@implementation SettingCVC {
    NSArray* items;
    NSMutableArray* contents;
}

- (void)viewDidLoad {
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        self.navigationController.navigationBar.tintColor = PRIMARY_COLOR;
        
    } else {// iOS 7.0 or later
        self.navigationController.navigationBar.barTintColor = PRIMARY_COLOR;
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        self.navigationController.navigationBar.translucent = NO;
    }
    self.navigationItem.title = @"Setting";
    items = [[NSMutableArray alloc] init];
    contents = [[NSMutableArray alloc] init];
    [self getData];
}

- (void) viewWillAppear:(BOOL)animated {
        
    [self.mTableView reloadData];
}

- (void) getData {
    if([customer.customerId isEqualToString:@"0"])
        items = @[@"Account", @"Help", @"Login"];
    else
        items = @[@"Account", @"Help", @"Logout"];
    
    NSString* content = @"Join Us for P2FoodDelivery App \n\n  1.This App is App that customers find nearby restaurants and order foods. \n  2.Owners can register them restaurants and serve foods to customers. \n  3.App support several payments such as Apple Pay and Credit Card.  \n\nContact manager at p2fooddelivery.com or phone number: 5207953400 ";
    for(int i=0;i< items.count;i++){
        [contents addObject:content];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return items.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [self.mTableView dequeueReusableCellWithIdentifier:@"RID_SettingCell" forIndexPath:indexPath];
    UILabel* label = [cell viewWithTag:1];
    label.text = items[indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row == 0) {
        if([customer.customerId isEqualToString:@"0"]){
            Login *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_Login"];
            g_appDelegate.mViewState = 5;// @"account";
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            AccountCVC* mVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_AccountCVC"];
            [self.navigationController pushViewController:mVC animated:YES];
        }
    } else if (indexPath.row == items.count-1) {
        if([customer.customerId isEqualToString:@"0"]){
            Login *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_Login"];
            g_appDelegate.mViewState = 6;// @"setting";
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UINavigationController* mVC = [sb instantiateViewControllerWithIdentifier:@"SID_InitNC"];
            //mVC.modalTransitionStyle = UIModalPresentationNone;
            [self presentViewController:mVC animated:YES completion:NULL];
        }
    } else {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        OtherCVC* mVC = [sb instantiateViewControllerWithIdentifier:@"SID_OtherCVC"];
        mVC.mTitle = items[indexPath.row];
        mVC.mContent = contents[indexPath.row];
        [self.navigationController pushViewController:mVC animated:YES];
    }
}

- (IBAction)onBackClick:(id)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController* mVC = [sb instantiateViewControllerWithIdentifier:@"SID_InitNC"];
    [self presentViewController:mVC animated:YES completion:NULL];
}
@end
