//
//  AddMenuView.m
//  Food
//
//  Created by meixiang wu on 17/08/2017.
//  Copyright © 2017 Odelan. All rights reserved.
//

#import "AddMenuView.h"
#import "Restaurant.h"
#import "Menu.h"
#import "HttpApi.h"
#import "Config.h"
#import "SVProgressHUD.h"

extern Restaurant *owner;

@interface AddMenuView ()

@end

@implementation AddMenuView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mNameLabel.text = owner.name;
    self.data = [[NSMutableArray alloc] init];
    
    CALayer *imageLayer = self.mEditText.layer;
    [imageLayer setCornerRadius:5];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:PRIMARY_TEXT_COLOR.CGColor];
    
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)loadData {
    [SVProgressHUD show];
    [[HttpApi sharedInstance] getRestMenuByRestId:owner.restaurantId Completed:^(NSString* array){
        [SVProgressHUD dismiss];
        self.data = [[NSMutableArray alloc] init];
        NSMutableArray* dataArray = (NSMutableArray*)array;
        for(int i=0;i < dataArray.count; i++){
            NSMutableDictionary* dic = (NSMutableDictionary*) dataArray[i];
            Menu* one = [[Menu alloc] initWithDictionary:dic];
            [self.data addObject:one];
        }
        [self.mTableView reloadData];
    }Failed:^(NSString* error){
        [SVProgressHUD showErrorWithStatus:error];
    }];
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
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* cell;
    cell = [self.mTableView dequeueReusableCellWithIdentifier:@"RID_MenuItem" forIndexPath:indexPath];
    UILabel *menuName = [cell viewWithTag:1];
    NSString* fname = ((Menu*)(self.data[indexPath.row])).menuName;
    menuName.text = fname;
    
    UIButton* delBtn = [cell viewWithTag:2];
    delBtn.tag = [((Menu*)(self.data[indexPath.row])).menuId intValue];
    [delBtn addTarget:self action:@selector(onDeleteMenu:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)onDeleteMenu:(UIButton *)sender {
    UIButton *btndel = (UIButton *)sender;
    NSString *menuId = [NSString stringWithFormat:@"%ld", (long)btndel.tag];
    [SVProgressHUD show];
    [[HttpApi sharedInstance] delRestMenuByRestId:menuId Completed:^(NSString* array){
        [SVProgressHUD dismiss];
        [self loadData];
    }Failed:^(NSString* error){
        [SVProgressHUD showErrorWithStatus:error];
    }];
}

- (IBAction)onAddNewMenu:(id)sender {
    NSString* newName = @"";
    if([self.mEditText.text length] > 0){
        newName = self.mEditText.text;
    } else{
        return;
    }
    [SVProgressHUD show];
    [[HttpApi sharedInstance] addRestMenuByRestId:owner.restaurantId Name:newName Completed:^(NSString* array){
        [SVProgressHUD dismiss];
        [self loadData];
    }Failed:^(NSString* error){
        [SVProgressHUD showErrorWithStatus:error];
    }];
}

- (IBAction)onBackClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
