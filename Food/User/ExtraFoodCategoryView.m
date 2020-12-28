//
//  ExtraFoodCategoryView.m
//  Food
//
//  Created by meixiang wu on 07/03/2018.
//  Copyright © 2018 Odelan. All rights reserved.
//

#import "ExtraFoodCategoryView.h"
#import <RATreeView.h>
#import "Config.h"
#import "AppDelegate.h"
#import "ExtraMenu.h"
#import "ExtraFood.h"
#import "ExtraMenuCell.h"
#import "ExtraFoodCell.h"
#import "Customer.h"

extern Customer *customer;
@interface ExtraFoodCategoryView ()<RATreeViewDelegate, RATreeViewDataSource>
{
    NSMutableArray *m_categories;
    RATreeView *m_treeView;
    UIRefreshControl *m_refreshControl;
    NSMutableDictionary *pre_item;
}
@end

@implementation ExtraFoodCategoryView

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
    
    [m_treeView registerNib:[UINib nibWithNibName:NSStringFromClass([ExtraMenuCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ExtraMenuCell class])];
    [m_treeView registerNib:[UINib nibWithNibName:NSStringFromClass([ExtraFoodCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ExtraFoodCell class])];
    
    m_refreshControl = [[UIRefreshControl alloc] init];
    [m_refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    [m_treeView.scrollView addSubview:m_refreshControl];
    pre_item = nil;
    //[self refreshTable];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[self refreshTable];
}

- (void)refreshTable
{
    [self loadData];
}

- (void)loadData{
    //====Configure Categories===========================================
    NSMutableArray *categories = [[NSMutableArray alloc] init];
    self.m_chooseCount = [[NSMutableDictionary alloc] init];
    for(int i =0 ; i < [self.m_data count] ; i++)
    {
        ExtraMenu *catedic = self.m_data[i];
        NSString *cateId = catedic.menuId;
        NSString *cateName = catedic.menuName;
        NSString *cateNum = @"";
        if([catedic.count integerValue] > 0){
            cateNum = catedic.count;
        }
        NSMutableArray* subfoods = [[NSMutableArray alloc] init];
        int count = 0;
        for(int j = 0; j < catedic.extrafoods.count; j++){
            ExtraFood *one = catedic.extrafoods[j];
            NSString *checkStr = @"0";
            if(one.bCheck){
                count++;
                checkStr = @"1";
            }
            NSMutableDictionary *subdic = [[NSMutableDictionary alloc] initWithDictionary:@{@"id":one.eid, @"menu_id":one.menuId, @"food_name":one.foodname, @"price":one.price, @"check":checkStr}];
            [subfoods addObject:subdic];
        }
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:@{@"id":cateId, @"value":cateName, @"count":cateNum ,@"children":subfoods}];
        [categories addObject:dic];
        NSString *defaultStr = [NSString stringWithFormat:@"%ld",(long)count];
        [self.m_chooseCount addEntriesFromDictionary:@{cateId:defaultStr}];
    }
    m_categories = categories;
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
    NSInteger height = 30;
    return height;
}

- (void)treeView:(RATreeView *)treeView willExpandRowForItem:(id)item
{
    NSMutableDictionary *dicCategory = item;
    NSInteger level = [treeView levelForCellForItem:item];
    if(level != 0) return;
    if([dicCategory[@"id"] integerValue] != 0) {
        ExtraMenuCell *cell = (ExtraMenuCell *)[treeView cellForItem:item];
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
        ExtraMenuCell *cell = (ExtraMenuCell *)[treeView cellForItem:item];
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

- (BOOL)treeView:(RATreeView *)treeView shouldItemBeExpandedAfterDataReload:(id)item treeDepthLevel:(NSInteger)treeDepthLevel
{
    NSInteger level = [treeView levelForCellForItem:item];
    if(level == 0)
        return YES;
    return NO;
}

- (void)treeView:(RATreeView *)treeView didSelectRowForItem:(id)item{
    NSInteger level = [treeView levelForCellForItem:item];
    if(level != 0){
        NSMutableDictionary* sel_item = item;
        ExtraFoodCell *cell = sel_item[@"cell"];
        NSString *mID = sel_item[@"menu_id"];
        int choose_count = [self.m_chooseCount[mID] intValue];
        BOOL bSelected = false;
        NSInteger menu_selItem = 1;
        for(int i =0 ; i < [m_categories count] ; i++)
        {
            NSMutableDictionary* catedic = m_categories[i];
            if([catedic[@"id"] isEqualToString:mID]){
                ExtraMenuCell *pcell = catedic[@"cell"];                
                menu_selItem = [pcell.mRequireLabel.text integerValue];
            }
        }
        if(menu_selItem == 1){
            if(choose_count == 0){
                sel_item[@"check"] = @"1";
                [cell.mCheckBox setOn:YES];
                choose_count++;
                bSelected = true;
                pre_item = sel_item;
            } else {
                if([sel_item[@"check"] integerValue] == 1){
                    sel_item[@"check"] = @"0";
                    [cell.mCheckBox setOn:NO];
                    choose_count--;
                    pre_item = sel_item;
                } else{
                    sel_item[@"check"] = @"1";
                    [cell.mCheckBox setOn:YES];
                    bSelected = true;
                    pre_item[@"check"] = @"0";
                    ExtraFoodCell *othercell = pre_item[@"cell"];
                    [othercell.mCheckBox setOn:NO];
                    NSString *epID = pre_item[@"id"];
                    pre_item = sel_item;
                    for(int i = 0; i < self.m_data.count; i++){
                        ExtraMenu* one_menu = self.m_data[i];
                        for(int j =0 ; j < one_menu.extrafoods.count; j++){
                            ExtraFood* one_food = one_menu.extrafoods[j];
                            if([epID isEqualToString:one_food.eid]){
                                one_food.bCheck = false;
                                break;
                            }
                        }
                    }
                }
            }
        } else{
            if([sel_item[@"check"] integerValue] == 1){
                sel_item[@"check"] = @"0";
                [cell.mCheckBox setOn:NO];
                choose_count--;
                pre_item = sel_item;
            } else if(choose_count < menu_selItem){
                sel_item[@"check"] = @"1";
                [cell.mCheckBox setOn:YES];
                choose_count++;
                bSelected = true;
                pre_item = sel_item;
            }
        }
        for(int i =0 ; i < [m_categories count] ; i++)
        {
            NSMutableDictionary* catedic = m_categories[i];
            if([catedic[@"id"] isEqualToString:mID]){
                ExtraMenuCell *pcell = catedic[@"cell"];
                if(choose_count == 0){
                    pcell.mChooseLabel.text = @"";
                } else{
                    pcell.mChooseLabel.text = [NSString stringWithFormat:@"choose %ld", (long)choose_count];
                }
            }
        }
        self.m_chooseCount[mID] = [NSString stringWithFormat:@"%ld", (long)choose_count];
        //set extra food class
        NSString *eID = sel_item[@"id"];
        for(int i = 0; i < self.m_data.count; i++){
            ExtraMenu* one_menu = self.m_data[i];
            for(int j =0 ; j < one_menu.extrafoods.count; j++){
                ExtraFood* one_food = one_menu.extrafoods[j];
                if([eID isEqualToString:one_food.eid]){
                    one_food.bCheck = bSelected;
                    break;
                }
            }
        }
    }
}


#pragma mark TreeView Data Source

- (UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(id)item
{
    //if(item == nil) return nil;
    NSInteger level = [treeView levelForCellForItem:item];
    
    if(level == 0) {
        NSMutableDictionary *dicCategory = item;
        
        ExtraMenuCell *cell = [treeView dequeueReusableCellWithIdentifier:NSStringFromClass([ExtraMenuCell class])];
        cell.mNameLabel.text = dicCategory[@"value"];
        cell.mRequireLabel.text = dicCategory[@"count"];
        if([cell.mRequireLabel.text length] > 0){
            cell.mMarkLabel.hidden = NO;
        } else{
            cell.mMarkLabel.hidden = YES;
        }
        NSString *menuID = dicCategory[@"id"];
        NSString *chooseNum = _m_chooseCount[menuID];
        if([chooseNum integerValue] > 0){
            cell.mChooseLabel.text = [NSString stringWithFormat:@"Choose %@",chooseNum];
        } else{
            cell.mChooseLabel.text = @"";
        }
        dicCategory[@"cell"] = cell;
        return cell;
    }
    else {
        NSMutableDictionary *subItem = item;
        
        ExtraFoodCell *cell = [treeView dequeueReusableCellWithIdentifier:NSStringFromClass([ExtraFoodCell class])];
        cell.mEFoodName.text = subItem[@"food_name"];
        if([subItem[@"price"] floatValue] == 0){
            cell.mPriceName.text = @"";
        } else{
            cell.mPriceName.text = [NSString stringWithFormat:@"$%.2f", [subItem[@"price"] floatValue] ];
        }
        if([subItem[@"check"] integerValue] == 1){
            [cell.mCheckBox setOn:YES];
        } else{
            [cell.mCheckBox setOn:NO];
        }
        /*cell.mExtraFoodDelBtn.tag = [subItem.eid intValue];
        [cell.mExtraFoodDelBtn addTarget:self action:@selector(onExtraFoodDelClick:) forControlEvents:UIControlEventTouchUpInside];*/
        subItem[@"cell"] = cell;
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
@end
