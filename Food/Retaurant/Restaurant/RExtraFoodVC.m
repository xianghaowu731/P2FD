//
//  RExtraFoodVC.m
//  Food
//
//  Created by meixiang wu on 06/03/2018.
//  Copyright © 2018 Odelan. All rights reserved.
//

#import "RExtraFoodVC.h"
#import <RATreeView.h>
#import "Config.h"
#import "AppDelegate.h"
#import "Restaurant.h"
#import "RExtraCategoryCell.h"
#import "RExtraFoodCell.h"
#import "ExtraMenu.h"
#import "ExtraFood.h"


extern Restaurant *owner;

@interface RExtraFoodVC ()<RATreeViewDelegate, RATreeViewDataSource>
{
    NSArray *m_categories;
    RATreeView *m_treeView;
    UIRefreshControl *m_refreshControl;
    NSString* sel_menuID;
}
@end

@implementation RExtraFoodVC

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
    
    [m_treeView registerNib:[UINib nibWithNibName:NSStringFromClass([RExtraCategoryCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([RExtraCategoryCell class])];
    [m_treeView registerNib:[UINib nibWithNibName:NSStringFromClass([RExtraFoodCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([RExtraFoodCell class])];
    
    m_refreshControl = [[UIRefreshControl alloc] init];
    [m_refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    [m_treeView.scrollView addSubview:m_refreshControl];
    sel_menuID = @"";
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

- (void)refreshTable
{
    [self loadData];
}

- (void)loadData{
    //====Configure Categories===========================================
    NSMutableArray *categories = [[NSMutableArray alloc] init];
    for(int i =0 ; i < [self.m_data count] ; i++)
    {
        ExtraMenu *catedic = self.m_data[i];
        NSString *cateId = catedic.menuId;
        NSString *cateName = catedic.menuName;
        NSString *cateNum = @"";
        if([catedic.count integerValue] > 0){
            cateNum = catedic.count;
        }
        [categories addObject:@{@"id":cateId, @"value":cateName, @"count":cateNum ,@"children":catedic.extrafoods}];
    }
    m_categories = [[NSArray alloc] initWithArray:categories];
    [m_treeView reloadData];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark TreeView Delegate methods

- (CGFloat)treeView:(RATreeView *)treeView heightForRowForItem:(id)item
{
    NSInteger level = [treeView levelForCellForItem:item];
    NSInteger height = 30;
    if(level == 0) {
        height = 30;
    } else{
        height = 32;
    }
    return height;
}

- (void)treeView:(RATreeView *)treeView willExpandRowForItem:(id)item
{
    NSDictionary *dicCategory = item;
    NSInteger level = [treeView levelForCellForItem:item];
    if(level != 0) return;
    if([dicCategory[@"id"] integerValue] != 0) {
        RExtraCategoryCell *cell = (RExtraCategoryCell *)[treeView cellForItem:item];
        cell.mImageView.image = [UIImage imageNamed:@"category_collapse.png"];
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
        RExtraCategoryCell *cell = (RExtraCategoryCell *)[treeView cellForItem:item];
        cell.mImageView.image = [UIImage imageNamed:@"category_expand.png"];
    }
}
- (BOOL)treeView:(RATreeView *)treeView shouldExpandItem:(id)item
{
    NSInteger level = [treeView levelForCellForItem:item];
    if(level == 0)
        return YES;
    return NO;
}
/*
- (BOOL)treeView:(RATreeView *)treeView shouldItemBeExpandedAfterDataReload:(id)item treeDepthLevel:(NSInteger)treeDepthLevel
{
    NSInteger level = [treeView levelForCellForItem:item];
    if(level == 0)
        return YES;
    return NO;
}
*/

#pragma mark TreeView Data Source

- (UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(id)item
{
    //if(item == nil) return nil;
    NSInteger level = [treeView levelForCellForItem:item];
    
    if(level == 0) {
        NSDictionary *dicCategory = item;
        
        RExtraCategoryCell *cell = [treeView dequeueReusableCellWithIdentifier:NSStringFromClass([RExtraCategoryCell class])];
        cell.mTitleLabel.text = dicCategory[@"value"];
        cell.mRequiredLabel.text = dicCategory[@"count"];
        
        cell.mDelBtn.tag = [dicCategory[@"id"] integerValue];
        [cell.mDelBtn addTarget:self action:@selector(onExtraMenuDelClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.mAddBtn.tag = [dicCategory[@"id"] integerValue];
        [cell.mAddBtn addTarget:self action:@selector(onExtraFoodAddClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if([dicCategory[@"id"] isEqualToString:sel_menuID]){
            /*double delayInSeconds = 0.1;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [treeView expandRowForItem:item];
            });*/
            dispatch_async(dispatch_get_main_queue(), ^(){
                [treeView expandRowForItem:item];
            });
        }
        
        return cell;
    }
    else {
        ExtraFood *subItem = (ExtraFood *)item;
        
        RExtraFoodCell *cell = [treeView dequeueReusableCellWithIdentifier:NSStringFromClass([RExtraFoodCell class])];
        cell.mNameLabel.text = subItem.foodname;
        if([subItem.price floatValue] == 0){
            cell.mPriceLabel.text = @"";
        } else{
            cell.mPriceLabel.text = [NSString stringWithFormat:@"$%@", subItem.price];
        }        
        cell.mExtraFoodDelBtn.tag = [subItem.eid intValue];
        [cell.mExtraFoodDelBtn addTarget:self action:@selector(onExtraFoodDelClick:) forControlEvents:UIControlEventTouchUpInside];
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

- (void)onExtraMenuDelClick:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSString *menuId = [NSString stringWithFormat:@"%ld", (long)btn.tag];
    for(int i =0 ; i < self.m_data.count ; i++){
        ExtraMenu *one = self.m_data[i];
        if([one.menuId isEqualToString:menuId]){
            [self.m_data removeObjectAtIndex:i];
        }
    }
    [self refreshTable];
}

- (void)onExtraFoodAddClick:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSString *menuId = [NSString stringWithFormat:@"%ld", (long)btn.tag];
    sel_menuID = menuId;
    [self.delegate didAddFoodItem:menuId];
}

- (void)onExtraFoodDelClick:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSString *mId = [NSString stringWithFormat:@"%ld", (long)btn.tag];
    for(int i =0 ; i < self.m_data.count ; i++){
        ExtraMenu *one = self.m_data[i];
        for(int j = 0; j < one.extrafoods.count ; j++){
            ExtraFood *other = one.extrafoods[j];
            if([other.eid isEqualToString:mId]){
                [one.extrafoods removeObjectAtIndex:j];
            }
        }
        
    }
    [self refreshTable];
}
@end
