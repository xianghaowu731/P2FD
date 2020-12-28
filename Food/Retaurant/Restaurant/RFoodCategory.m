//
//  RFoodCategory.m
//  Food
//
//  Created by meixiang wu on 5/13/17.
//  Copyright © 2017 Odelan. All rights reserved.
//

#import "RFoodCategory.h"
#import "Config.h"
#import <RATreeView.h>
#import "RFoodCategoryCell.h"
#import "RFoodItemCell.h"
#import "SVProgressHUD.h"
#import "HttpApi.h"
#import "Restaurant.h"
#import "Food.h"
#import <UIImageView+WebCache.h>
#import "RFoodAddVC.h"
#import "RFoodEditVC.h"

@interface RFoodCategory () <RATreeViewDelegate, RATreeViewDataSource>
{
    NSArray *m_categories;
    RATreeView *m_treeView;
    UIRefreshControl *m_refreshControl;
}
@property (strong, nonatomic) NSString* restName;
@end

extern Restaurant *owner;

@implementation RFoodCategory

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    [m_treeView registerNib:[UINib nibWithNibName:NSStringFromClass([RFoodItemCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([RFoodItemCell class])];
    
    m_refreshControl = [[UIRefreshControl alloc] init];
    [m_refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    [m_treeView.scrollView addSubview:m_refreshControl];
    
    [self refreshTable];
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

- (void)onFoodAddClick:(id)sender
{
    UIButton *btnCategory = (UIButton *)sender;
    
    NSString *cateId = [NSString stringWithFormat:@"%ld", (long)btnCategory.tag];
    //NSString *cateName = btnCategory.titleLabel.text;
    
     Food *oneFood = [[Food alloc] init];
     UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
     RFoodAddVC* mVC = [sb instantiateViewControllerWithIdentifier:@"SID_RFoodAddVC"];
     oneFood.restId = owner.restaurantId;
     oneFood.name = @"food";
     oneFood.desc = @"";
     oneFood.img = @"";
     oneFood.price = 0;
     mVC.data = oneFood;
     mVC.categoryId = cateId;
     mVC.m_data = self.m_data;
     [self.navigationController pushViewController:mVC animated:YES];
}

- (void)onFoodEditClick:(id)sender
{
    [SVProgressHUD showWithStatus:@"Loading..."];
    UIButton *btnCategory = (UIButton *)sender;
    NSString *foodId = [NSString stringWithFormat:@"%ld", (long)btnCategory.tag];
    [[HttpApi sharedInstance] getFoodById:foodId Completed:^(NSDictionary *dic){
        [SVProgressHUD dismiss];
        NSArray *foodArray = [[NSArray alloc] init];
        foodArray = (NSArray*)dic;
        Food* food = [[Food alloc] initWithDictionary:foodArray[0]];
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        RFoodEditVC* mVC = [sb instantiateViewControllerWithIdentifier:@"SID_RFoodEditVC"];
        mVC.data = food;
        mVC.m_data = self.m_data;
        [self.navigationController pushViewController:mVC animated:YES];
    }Failed:^(NSString *strError){
        [SVProgressHUD showErrorWithStatus:strError];
    }];
}

- (void)refreshTable
{
    [self loadData];
}

- (void)loadData
{
    [SVProgressHUD showWithStatus:@"Loading..."];
    //[SVProgressHUD show];
    [[HttpApi sharedInstance] getRestMenuByRestId:owner.restaurantId Completed:^(NSString* array){
        NSDictionary* data = (NSDictionary*) array;
        self.m_category = [[NSMutableArray alloc] init];
        self.m_category = (NSMutableArray *)data;
        [[HttpApi sharedInstance] getAdminFoodsByRestId:owner.restaurantId Completed:^(NSString *array){
            [SVProgressHUD dismiss];
            NSDictionary* data1 = (NSDictionary*) array;
            self.restName = [data1 objectForKey:@"rest_name"];
            NSMutableArray* mArray = [[NSMutableArray alloc] init];
            mArray = [data1 objectForKey:@"foods"];
            self.m_data = [[NSMutableArray alloc] init];
            for(int i=0;i< mArray.count;i++){
                Food* food = [[Food alloc] initWithDictionary:mArray[i]];
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
        [cell.mAddBtn addTarget:self action:@selector(onFoodAddClick:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
    else {
        Food *subItem = (Food *)item;
        
        RFoodItemCell *cell = [treeView dequeueReusableCellWithIdentifier:NSStringFromClass([RFoodItemCell class])];
        cell.mNameLabel.text = subItem.name;
        NSString *foodDesc = subItem.desc;
        NSAttributedString* desc = [[NSAttributedString alloc] initWithData:[foodDesc dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        cell.mDescLabel.attributedText = desc;
        cell.mDescLabel.textAlignment = NSTextAlignmentLeft;
        [cell.mDescLabel setFont:[UIFont systemFontOfSize:12]];
        cell.mDescLabel.textColor = [UIColor darkGrayColor];
        cell.mPriceLabel.text = [NSString stringWithFormat:@"%@%.2f", @"$", subItem.price.floatValue];
        NSString *status = subItem.status;
        NSString* url = [NSString stringWithFormat:@"%@%@%@", SERVER_URL, FOOD_IMAGE_BASE_URL, subItem.img];
        [cell.mImageView sd_setImageWithURL:[NSURL URLWithString:url]];
        if([status isEqualToString:@"active"]) [cell.mStatusIV setImage:[UIImage imageNamed:@"ic_active.png"]];
        else if([status isEqualToString:@"inactive"]) [cell.mStatusIV setImage:[UIImage imageNamed:@"ic_inactive.png"]];
        cell.mEditBtn.tag = [subItem.foodId intValue];
        [cell.mEditBtn addTarget:self action:@selector(onFoodEditClick:) forControlEvents:UIControlEventTouchUpInside];
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
