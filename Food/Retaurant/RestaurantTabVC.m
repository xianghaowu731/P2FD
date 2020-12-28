//
//  RestaurantTabVC.m
//  Food
//
//  Created by weiquan zhang on 6/22/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import "RestaurantTabVC.h"
#import "Config.h"

@interface RestaurantTabVC ()

@end

@implementation RestaurantTabVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.delegate = self;
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] } forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName :  PRIMARY_TEXT_COLOR} forState:UIControlStateSelected];
    
    UITabBarItem *item0 = [self.m_tabBar.items objectAtIndex:0];
    UITabBarItem *item1 = [self.m_tabBar.items objectAtIndex:1];
    UITabBarItem *item2 = [self.m_tabBar.items objectAtIndex:2];
    UITabBarItem *item3 = [self.m_tabBar.items objectAtIndex:3];
    
    item0.image = [[UIImage imageNamed:@"ic_rest.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item1.image = [[UIImage imageNamed:@"ic_order.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item3.image = [[UIImage imageNamed:@"ic_cart_nav.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item2.image = [[UIImage imageNamed:@"ic_person.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    self.m_tabBar.tintColor = PRIMARY_TEXT_COLOR;//[UIColor greenColor];
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

@end
