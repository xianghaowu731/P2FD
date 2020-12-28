//
//  UserCategoryView.m
//  Food
//
//  Created by meixiang wu on 6/2/17.
//  Copyright © 2017 Odelan. All rights reserved.
//

#import "UserCategoryView.h"
#import "Config.h"
#import <RATreeView.h>
#import "RFoodCategoryCell.h"
#import "FoodCustomViewCell.h"
#import <SVProgressHUD.h>
#import "HttpApi.h"
#import "Customer.h"
#import "Common.h"
#import <UIImageView+WebCache.h>
#import "FoodDetailCVC.h"

extern Customer *customer;

@interface UserCategoryView () <RATreeViewDelegate, RATreeViewDataSource>
{
    NSArray *m_categories;
    RATreeView *m_treeView;
    UIRefreshControl *m_refreshControl;
}

@end

@implementation UserCategoryView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showFoodDetailView:) name:@"FoodDetailView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeFavorite:) name:@"ChangedFavorite" object:nil];
    
    RATreeView *treeView = [[RATreeView alloc] initWithFrame:self.view.bounds];
    
    treeView.delegate = self;
    treeView.dataSource = self;
    treeView.treeFooterView = [UIView new];
    treeView.separatorStyle = RATreeViewCellSeparatorStyleNone;
    
    [treeView reloadData];
    [treeView setBackgroundColor:[UIColor colorWithWhite:0.97 alpha:1.0]];
    
    m_treeView = treeView;
    m_treeView.frame = self.view.bounds;
    m_treeView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view insertSubview:treeView atIndex:0];
    [m_treeView setEditing:NO animated:YES];
    
    [m_treeView registerNib:[UINib nibWithNibName:NSStringFromClass([RFoodCategoryCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([RFoodCategoryCell class])];
    [m_treeView registerNib:[UINib nibWithNibName:NSStringFromClass([FoodCustomViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([FoodCustomViewCell class])];
    
    m_refreshControl = [[UIRefreshControl alloc] init];
    [m_refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    [m_treeView.scrollView addSubview:m_refreshControl];
    
    [self refreshTable];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshTable];
}

- (void)changeFavorite:(NSNotification*)msg{
    
    NSDictionary* dic = msg.userInfo;
    NSNumber* objectID = dic[@"cellTag"];
    NSNumber* isfavorite = dic[@"isfavorite"];
    ((Food*)(self.m_data[[objectID longValue]])).is_favorite = isfavorite;
    
}


-(void) showFoodDetailView:(NSNotification *)msg{
    Food *one = (Food*)msg.userInfo;
    UIStoryboard *mainstory = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FoodDetailCVC* mVC = [mainstory instantiateViewControllerWithIdentifier:@"SID_FoodDetailCVC"];
    mVC.data = one;
    mVC.restId = self.mRestaurant.restaurantId;
    mVC.restaurant = self.mRestaurant;
    [self.navigationController pushViewController:mVC animated:YES];
}

- (void)refreshTable
{
    [self loadData];
}

- (void)loadData
{
    [SVProgressHUD showWithStatus:@"Loading..."];
    //[SVProgressHUD show];
    [[HttpApi sharedInstance] getRestMenuByRestId:self.mRestaurant.restaurantId Completed:^(NSString *array){
        NSDictionary* data = (NSDictionary*) array;
        self.m_category = [[NSMutableArray alloc] init];
        self.m_category = (NSMutableArray *)data;
        [[HttpApi sharedInstance] getRestAndFoodInfoByRestId:(NSString *)self.mRestaurant.restaurantId
                                           CustomerId:(NSString *)customer.customerId
                                            Completed:^(NSDictionary *dic){
                                                [SVProgressHUD dismiss];
                                                self.m_data = [[NSMutableArray alloc] init];
                                                self.mRestaurant = [[Restaurant alloc] initWithDictionary:dic[@"rest"]];
                                                NSMutableArray* array = dic[@"foods"];
                                                for(int i=0;i<array.count;i++){
                                                    Food* food = [[Food alloc] initWithDictionary:array[i]];
                                                    [self.m_data addObject:food];
                                                }
                                                //====Configure Categories===========================================
                                                NSMutableArray *categories = [[NSMutableArray alloc] init];
                                                for(int i =0 ; i < [self.m_category count] ; i++)
                                                {
                                                    NSDictionary *catedic = (NSDictionary *)self.m_category[i];
                                                    NSString *cateId = [catedic objectForKey:@"id"];
                                                    NSString *cateName = [catedic objectForKey:@"title"];
                                                    NSMutableArray *subItems = [[NSMutableArray alloc] init];
                                                    for(int j=0 ; j < [self.m_data count] ; j++ )
                                                    {
                                                        Food *food = self.m_data[j];
                                                        NSString *itemCateId = food.categoryId;
                                                        if([cateId isEqualToString:itemCateId])
                                                            [subItems addObject:self.m_data[j]];
                                                    }
                                                    [categories addObject:@{@"id":cateId, @"value":cateName, @"children":subItems}];
                                                }
                                                m_categories = [[NSArray alloc] initWithArray:categories];
                                                [m_treeView reloadData];
                                            }Failed:^(NSString *strError) {
                                                [SVProgressHUD showErrorWithStatus:strError];
                                                [m_refreshControl endRefreshing];
                                            }];
        //[m_treeView reloadData];
    }Failed:^(NSString *strError) {
        [SVProgressHUD showErrorWithStatus:strError];
        [m_refreshControl endRefreshing];
    }];
        
}

#pragma mark TreeView Delegate methods

- (CGFloat)treeView:(RATreeView *)treeView heightForRowForItem:(id)item
{
    NSInteger level = [treeView levelForCellForItem:item];
    NSInteger height = 33;
    if(level == 0) {
        height = 33;
    } else{
        height = 92;
    }
    return height;
}

- (void)treeView:(RATreeView *)treeView willExpandRowForItem:(id)item
{
    NSDictionary *dicCategory = item;
    NSInteger level = [treeView levelForCellForItem:item];
    if(level != 0) return;
    if([dicCategory[@"id"] integerValue] != 0) {
        RFoodCategoryCell *cell = (RFoodCategoryCell *)[treeView cellForItem:item];
        cell.mStatusImg.image = [UIImage imageNamed:@"category_collapse.png"];
    }
}

- (BOOL)treeView:(RATreeView *)treeView canEditRowForItem:(id)item
{
    return NO;
}

- (void)treeView:(RATreeView *)treeView willCollapseRowForItem:(id)item
{
    NSDictionary *dicCategory = item;
    NSInteger level = [treeView levelForCellForItem:item];
    if(level != 0) return;
    if([dicCategory[@"id"] integerValue] != 0 ) {
        RFoodCategoryCell *cell = (RFoodCategoryCell *)[treeView cellForItem:item];
        cell.mStatusImg.image = [UIImage imageNamed:@"category_expand.png"];
    }
}
- (BOOL)treeView:(RATreeView *)treeView shouldExpandItem:(id)item
{
    NSInteger level = [treeView levelForCellForItem:item];
    if(level == 0)
        return YES;
    return NO;
}

- (void)treeView:(RATreeView *)treeView didSelectRowForItem:(id)item{
    NSInteger level = [treeView levelForCellForItem:item];
    if(level != 0){
        Food *one = (Food *)item;
        NSNotification *msg = [NSNotification notificationWithName:@"FoodDetailView" object:nil userInfo:(NSDictionary*)one];
        [[NSNotificationCenter defaultCenter] postNotification:msg];
    }
}

- (BOOL)treeView:(RATreeView *)treeView shouldItemBeExpandedAfterDataReload:(id)item treeDepthLevel:(NSInteger)treeDepthLevel
{
    NSInteger level = [treeView levelForCellForItem:item];
    if(level == 0)
        return YES;
    return NO;
}


#pragma mark TreeView Data Source

- (UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(id)item
{
    //if(item == nil) return nil;
    NSInteger level = [treeView levelForCellForItem:item];
    
    if(level == 0) {
        NSDictionary *dicCategory = item;
        
        RFoodCategoryCell *cell = [treeView dequeueReusableCellWithIdentifier:NSStringFromClass([RFoodCategoryCell class])];
        cell.mTitle.text = dicCategory[@"value"];
        
        cell.mAddBtn.tag = [dicCategory[@"id"] integerValue];
        cell.mAddBtn.hidden = YES;
        
        return cell;
    }
    else {
        Food *subItem = (Food *)item;
        
        FoodCustomViewCell *cell = [treeView dequeueReusableCellWithIdentifier:NSStringFromClass([FoodCustomViewCell class])];
        [cell setLayout:subItem];
        return cell;
    }
}

- (NSInteger)treeView:(RATreeView *)treeView numberOfChildrenOfItem:(id)item
{
    if (item == nil) {
        return m_categories.count;
    }
    
    NSInteger level = [treeView levelForCellForItem:item];
    
    if(level == 0) {
        NSDictionary *dicCategory = item;
        NSMutableArray *subarray = [dicCategory objectForKey:@"children"];
        return subarray.count;
    }
    
    return 0;
}

- (id)treeView:(RATreeView *)treeView child:(NSInteger)index ofItem:(id)item
{
    if (item == nil) {
        return m_categories[index];
    }
    
    NSDictionary *dicCategory = item;
    return dicCategory[@"children"][index];
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
