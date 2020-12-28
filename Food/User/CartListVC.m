//
//  CartListVC.m
//  Food
//
//  Created by weiquan zhang on 6/27/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import "CartListVC.h"
#import "CartDetailVC.h"
#import "CartTVC.h"
#import "FMDBHelper.h"
#import "OrderGroup.h"
#import "AppDelegate.h"

extern FMDBHelper* helper;

@interface CartListVC ()

@end

@implementation CartListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(delOrderByRestId:) name:@"DeleteOrderByRestId" object:nil];
     self.mTitleLabel.text = @"Cart";
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)delOrderByRestId:(NSNotification*)msg{
    
    //NSDictionary* dic = msg.userInfo;
    self.data = [helper getOrdersGroup];
    [self.mTableView reloadData];
}

- (void) viewWillAppear:(BOOL)animated {
    helper = [FMDBHelper sharedInstance];
    self.data = [[NSMutableArray alloc] init];
    self.data = [helper getOrdersGroup];
    if([self.data count] == 0){
        [self.navigationController popViewControllerAnimated:YES];
    }
    [self.mTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.data count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CartTVC *cell = [self.mTableView dequeueReusableCellWithIdentifier:@"RID_CartTVC" forIndexPath:indexPath];
    OrderGroup* og = self.data[indexPath.row];
    [cell setLayout:og];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CartDetailVC* mVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_CartDetailVC"];
    mVC.navigationController = self.navigationController;
    mVC.restId = ((OrderGroup*)(self.data[indexPath.row])).mRestId;
    for(int i = 0; i < g_Restaurants.count; i++)
    {
        Restaurant *one = (Restaurant *)[g_Restaurants objectAtIndex:i];
        if([one.restaurantId isEqualToString:mVC.restId])
        {
            mVC.mRest = one;
            break;
        }
    }
    [self.navigationController pushViewController:mVC animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onBackClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
