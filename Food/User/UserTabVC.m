//
//  UserTabVC.m
//  Food
//
//  Created by weiquan zhang on 6/23/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import "UserTabVC.h"
#import "Config.h"
#import "Customer.h"
#import "Login.h"
#import "FMDBHelper.h"

@interface UserTabVC ()
//@property(strong, nonatomic) UIViewController* mPreVC;
@end
extern Customer* customer;
extern FMDBHelper* helper;

@implementation UserTabVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.delegate = self;
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] } forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : PRIMARY_TEXT_COLOR } forState:UIControlStateSelected];
    
    UITabBarItem *item1 = [self.m_tabBar.items objectAtIndex:0];
    UITabBarItem *item2 = [self.m_tabBar.items objectAtIndex:1];
    UITabBarItem *item3 = [self.m_tabBar.items objectAtIndex:2];
    UITabBarItem *item4 = [self.m_tabBar.items objectAtIndex:3];
    //UITabBarItem *item5 = [self.m_tabBar.items objectAtIndex:4];
    
    item1.image = [[UIImage imageNamed:@"ic_rest.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //item2.image = [[UIImage imageNamed:@"ic_quick1.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item2.image = [[UIImage imageNamed:@"ic_order.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item3.image = [[UIImage imageNamed:@"ic_setting.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item4.image = [[UIImage imageNamed:@"ic_fav.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    self.m_tabBar.tintColor = PRIMARY_TEXT_COLOR;//[UIColor greenColor];
    
    g_appDelegate.mViewState = 0;
    g_appDelegate.mTabVC = self;
    /*
    helper = [FMDBHelper sharedInstance];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    array = [helper getAllOrders];
    int count = 0;
    for(int i=0;i<array.count; i++){
        Food* f = [[Food alloc] init];
        f = array[i];
        count += [f.count intValue];
    }
    
    UIButton* customButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [customButton setImage:[UIImage imageNamed:@"ic_cart"] forState:UIControlStateNormal];
    [customButton setTitle:[NSString stringWithFormat:@"(%d)", count] forState:UIControlStateNormal];
    [customButton sizeToFit];
    UIBarButtonItem* customBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customButton];
    self.navigationItem.rightBarButtonItem = customBarButtonItem;
    
    [self.navigationItem.rightBarButtonItem setTarget:self];
    [self.navigationItem.rightBarButtonItem setAction:@selector(onCartClick:)];
     */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tabBarController:(UITabBarController *)tabBarController
 didSelectViewController:(UIViewController *)viewController
{
    int index = -1;
    for(int i=0; i<self.viewControllers.count; i++) {
        UIViewController *vc = [self.viewControllers objectAtIndex:i];
        if(vc == viewController) {
            index = i;
            break;
        }
    }
    
    if(g_appDelegate.mViewState != 0){
        UINavigationController *nc = (UINavigationController *)viewController;
        [nc popViewControllerAnimated:NO];
    }
    
    if(index != 0 && [customer.customerId isEqualToString:@"0"]) {
        UINavigationController *nc = (UINavigationController *)viewController;
        Login *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_Login"];
        g_appDelegate.mViewState = index;
        [nc pushViewController:vc animated:YES];
    }
    //self.mPreVC = viewController;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
