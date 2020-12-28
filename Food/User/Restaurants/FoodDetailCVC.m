//
//  FoodDetailCVC.m
//  Food
//
//  Created by weiquan zhang on 6/16/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import "FoodDetailCVC.h"
#import "Config.h"
#import "HttpAPI.h"
#import <UIImageView+WebCache.h>
#import "SVProgressHUD.h"
#import "Customer.h"
#import "FMDBHelper.h"
#import "Restaurant.h"
#import "AppDelegate.h"
#import "CartDetailVC.h"
#import "Common.h"
#import "ExtraFoodCategoryView.h"
#import "ExtraMenu.h"
#import "ExtraFood.h"
#import "TableFood.h"

extern Customer* customer;
extern FMDBHelper* helper;

@implementation FoodDetailCVC{
    ExtraFoodCategoryView *extrafoodTree;
    NSMutableArray* tabledata;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    helper = [FMDBHelper sharedInstance];
    // Do any additional setup after loading the view.
    self.mDescTV.editable = false;
    CALayer *imageLayer = self.mImageView.layer;
    //[imageLayer setCornerRadius:self.mImageView.frame.size.width/2];
    [imageLayer setCornerRadius:3];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:[UIColor orangeColor].CGColor];
    [self.mImageView setImage:[UIImage imageNamed:@"sample_food.png"]];
    
    imageLayer = self.mInstructionText.layer;
    [imageLayer setCornerRadius:3];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:[UIColor orangeColor].CGColor];
    
    imageLayer = self.mExtraView.layer;
    [imageLayer setCornerRadius:3];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:[UIColor orangeColor].CGColor];
    
    self.m_extdata = [[NSMutableArray alloc] init];
    extrafoodTree = [[ExtraFoodCategoryView alloc] init];
    extrafoodTree.m_data = self.m_extdata;
    //extrafoodTree.delegate = self;
    [self addChildViewController:extrafoodTree];
    CGRect frame = extrafoodTree.view.frame;
    frame.size.height = self.mExtraView.bounds.size.height;
    frame.size.width = self.mExtraView.bounds.size.width;
    extrafoodTree.view.frame = frame;
    [self.mExtraView addSubview:extrafoodTree.view];
    [extrafoodTree didMoveToParentViewController:self];
    
    [self loadExtData];
    self.mQuantity = 1;
    self.mEffectView.hidden = YES;
    self.mInstructionText.placeholder = @"Other requests?\nNote: Any additions not included will be charged to your card separately.";
    
    self.cartImg = [Common imageWithImage:[UIImage imageNamed:@"ic_cart"] scaledToSize:CGSizeMake(28.0, 28.0)];
    [self.mCartBtn setImage:self.cartImg forState:UIControlStateNormal];
    
    [self setLayout:self.data];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES;
}

- (void)loadExtData{
    [SVProgressHUD show];
    [[HttpApi sharedInstance] getExtraFoodsByFoodId:self.data.foodId Completed:^(NSArray *array){
        [SVProgressHUD dismiss];
        self.m_extdata = [[NSMutableArray alloc] init];
        for(int i = 0 ; i < array.count ; i++){
            ExtraMenu* one = [[ExtraMenu alloc] init];
            NSDictionary* dic = (NSDictionary*)array[i];
            one.menuId = [dic objectForKey:@"id"];
            one.foodId = [dic objectForKey:@"food_id"];
            one.menuName = [dic objectForKey:@"menu_name"];
            one.count = [dic objectForKey:@"count"];
            one.extrafoods = [[NSMutableArray alloc] init];
            NSArray *darray = [dic objectForKey:@"extra_food"];
            for(int j=0; j< darray.count; j++){
                ExtraFood* other = [[ExtraFood alloc] initWithDictionary:darray[j]];
                [one.extrafoods addObject:other];
            }
            [self.m_extdata addObject:one];
        }
        extrafoodTree.m_data = self.m_extdata;
        [extrafoodTree refreshTable];
    }Failed:^(NSString *strError) {
        [SVProgressHUD showErrorWithStatus:strError];
    }];
}

- (void) setLayout:(Food*)f {
    self.data = f;
    self.mNameLabel.text = f.name;
    if(![f.img isEqual:nil] && ![f.img isEqualToString:@""]){
        NSString* url = [NSString stringWithFormat:@"%@%@%@", SERVER_URL, FOOD_IMAGE_BASE_URL, f.img];
        [self.mImageView sd_setImageWithURL:[NSURL URLWithString:url]];
    } else {
        [self.mImageView setImage:[UIImage imageNamed:@"sample_rest.png"]];
    }
    self.mPriceLabel.text = [NSString stringWithFormat:@"$%.2f", f.price.floatValue];
    if(![f.desc isEqual:[NSNull null]]){
        NSAttributedString* desc = [[NSAttributedString alloc] initWithData:[f.desc dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        self.mDescTV.attributedText = desc;
        self.mDescTV.textAlignment = NSTextAlignmentLeft;
        [self.mDescTV setFont:[UIFont systemFontOfSize:12]];
        
        CGFloat fixedWidth = self.mDescTV.frame.size.width;
        CGFloat fixedHeight = self.mDescTV.frame.size.height;
        CGSize newSize = [self.mDescTV sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
        CGRect newFrame = self.mDescTV.frame;
        newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
        self.mDescTV.frame = newFrame;
        if(newSize.height > fixedHeight){
            CGRect orgFrame = self.mFoodListView.frame;
            orgFrame.origin.y += (newSize.height - fixedHeight);
            orgFrame.size.height -= (newSize.height - fixedHeight);
            self.mFoodListView.frame = orgFrame;
        }
    }
    for(int i = 0; i < g_Restaurants.count; i++)
    {
        Restaurant *one = (Restaurant *)[g_Restaurants objectAtIndex:i];
        if([one.restaurantId isEqualToString:self.restId])
        {
            NSAttributedString* comtext = [[NSAttributedString alloc] initWithData:[one.comment dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
            self.mInstructionText.attributedText = comtext;
            self.mInstructionText.textAlignment = NSTextAlignmentLeft;
            [self.mInstructionText setFont:[UIFont systemFontOfSize:12]];
            break;
        }
    }
    [self showQuantity];
    [self getData];
}

- (void)showQuantity{
    self.mQuantityLabel.text = [NSString stringWithFormat:@"%ld", (long)self.mQuantity];
}

- (void)getData{
    self.cartdata = [helper getOrdersByRestID:self.restId];
    tabledata = [[NSMutableArray alloc] init];
    float totalprice = 0;
    self.cartCount = 0;
    int count = 0;
    for(int i=0;i<self.cartdata.count;i++){
        Food *cart_food = (Food*)(self.cartdata[i]);
        TableFood *one = [[TableFood alloc] init];
        one.mId = cart_food.foodId;
        one.foodname = cart_food.name;
        one.price = [cart_food.price stringValue];
        one.count = [cart_food.count stringValue];
        one.type = 1;//main food
        [tabledata addObject:one];
        totalprice += cart_food.price.floatValue * [cart_food.count intValue];
        for(int j = 0; j < cart_food.extrafoods.count; j++){
            ExtraMenu* one_menu = cart_food.extrafoods[j];
            for(int k = 0 ; k < one_menu.extrafoods.count; k++){
                ExtraFood* one_food = one_menu.extrafoods[k];
                TableFood *other = [[TableFood alloc] init];
                other.mId = one_food.eid;
                other.foodname = one_food.foodname;
                other.price = one_food.price;
                other.count = one_food.count;
                other.type = 2;//extra food
                [tabledata addObject:other];
                totalprice += other.price.floatValue * [other.count intValue];
            }
        }
        count += [one.count intValue];
    }
    
    NSString* tprice = [NSString stringWithFormat:@"%.2f", totalprice];
    self.mTotalLabel.text = [NSString stringWithFormat:@"%@%@", @"$",tprice];
    
    self.cartCount = count;
    [self.mCartBtn setTitle:[NSString stringWithFormat:@" (%d)", count] forState:UIControlStateNormal];
    
    [self.mTableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [tabledata count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger height = 30;
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView == self.mTableView){
        UITableViewCell* cell;
        /*if (indexPath.row == self.cartdata.count) {
            cell = [self.mTableView dequeueReusableCellWithIdentifier:@"RID_TotalCell" forIndexPath:indexPath];
            int totalprice = 0;
            for(int i=0;i<self.cartdata.count;i++){
                totalprice += [((Food*)(self.cartdata[i])).price intValue] * [((Food*)(self.cartdata[i])).count intValue];
            }
            UILabel *totalPrice = [cell viewWithTag:2];
            NSString* tprice = [NSString stringWithFormat:@"%d", totalprice];
            totalPrice.text = [NSString stringWithFormat:@"%@%@", @"$",tprice];
        } else {*/
        cell = [self.mTableView dequeueReusableCellWithIdentifier:@"RID_FoodLineCell" forIndexPath:indexPath];
        UILabel *foodName = [cell viewWithTag:1];
        UILabel* price = [cell viewWithTag:3];
        UIButton *delBtn = [cell viewWithTag:4];
        UIButton *ext_delBtn = [cell viewWithTag:5];
        TableFood* one = tabledata[indexPath.row];
        NSString* fname = one.foodname;
        NSString* count = one.count;
        NSInteger type = one.type;
        if(type == 2){
            NSString* priceStr = [NSString stringWithFormat:@"%.2f", one.price.floatValue];
            [foodName setFont:[UIFont systemFontOfSize:12]];
            if( one.price.floatValue > 0){
                foodName.text = [NSString stringWithFormat:@"\t%@ (%@)\t\t+$%@", fname, count, priceStr];
            } else{
                foodName.text = [NSString stringWithFormat:@"\t%@ (%@)", fname, count];
            }            
            price.text = @"";
            delBtn.hidden = YES;
            ext_delBtn.hidden = NO;
            ext_delBtn.tag = indexPath.row;
            [ext_delBtn addTarget:self action:@selector(onExtMinuteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        } else{
            [foodName setFont:[UIFont systemFontOfSize:14]];
            foodName.text = [NSString stringWithFormat:@"%@ (%@)", fname, count];
            NSString* priceStr = [NSString stringWithFormat:@"%.2f", one.price.floatValue];
            price.text = [NSString stringWithFormat:@"%@%@", @"+$", priceStr];
            delBtn.hidden = NO;
            delBtn.tag = indexPath.row;
            [delBtn addTarget:self action:@selector(onMinuteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            ext_delBtn.hidden = YES;
        }
        //}
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)onExtMinuteBtnClick:(UIButton *)sender {
    long index = sender.tag;
    TableFood* sel_food = tabledata[index];
    ExtraFood* one_sel = [[ExtraFood alloc] init];
    for(int i=0;i<self.cartdata.count;i++){
        Food* one = self.cartdata[i];
        for(int j = 0; j < one.extrafoods.count; j++){
            ExtraMenu* one_menu = one.extrafoods[j];
            for(int k = 0 ; k < one_menu.extrafoods.count; k++){
                ExtraFood* one_food = one_menu.extrafoods[k];
                if([one_food.eid isEqualToString:sel_food.mId]){
                    one_sel = one_food;
                    [helper deleteExtFood:one_sel];
                    [self getData];
                    return;
                }
            }
        }
    }
}

- (void)onMinuteBtnClick:(UIButton *)sender {
    long index = sender.tag;
    TableFood* sel_food = tabledata[index];
    Food* one_sel = [[Food alloc] init];
    for(int i=0;i<self.cartdata.count;i++){
        Food* one = self.cartdata[i];
        if([one.foodId isEqualToString:sel_food.mId]){
            one_sel = one;
            //NSInteger count = [one_sel.count integerValue];
            [helper deleteFood:one_sel];
            //[helper updateFood:one_sel Quantity:-1];
            [self getData];
            return;
        }
    }
}

- (IBAction)onBackClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onPlusClick:(id)sender {
    self.mQuantity++;
    [self showQuantity];
}

- (IBAction)onMinuteClick:(id)sender {
    if(self.mQuantity > 0)
    {
        self.mQuantity--;
        [self showQuantity];
    }
}

- (void) runEffectFunction{
    // instantaneously make the image view small (scaled to 1% of its actual size)
    self.mEffectView.hidden = NO;
    self.mEffectView.frame= CGRectMake(70, 50, 36, 36);
    
    self.mEffectView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:0.3 animations:^{
        self.mEffectView.frame= CGRectMake(150, 20, 36, 36);
        //self.mEffectView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1); // scales up the view of button
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.4 animations:^{
            self.mEffectView.frame= CGRectMake(250, 533, 20, 20);
            //self.mEffectView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.3, 0.3);// scales down the view of button
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3 animations:^{
                self.mEffectView.transform = CGAffineTransformIdentity; // at the end sets the original identity of the button
                self.mEffectView.hidden = YES;
            }];
        }];
    }];
}

- (IBAction)onBagItClick:(id)sender {
    if(![self checkExtraFoods]){
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Warning!"
                                      message:@"You must make the selection."
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"Ok"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        //Handel your yes please button action here
                                    }];
        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    [self runEffectFunction];
    NSString *mInstruct = [self.mInstructionText.attributedText string];
    self.data.instruction = mInstruct;
    [helper updateFood:self.data Quantity:self.mQuantity];
    NSNotification *msg = [NSNotification notificationWithName:@"PlusOrder" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:msg];
    [self getData];
}

- (IBAction)onCancelClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onCartClick:(id)sender {
    if(self.cartCount == 0) return;
    [self.navigationController popViewControllerAnimated:YES];
    CartDetailVC* mVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_CartDetailVC"];
    mVC.navigationController = self.navigationController;
    mVC.restId = self.restId;
    mVC.mRest = self.restaurant;
    [self.navigationController pushViewController:mVC animated:YES];
}

- (BOOL)checkExtraFoods{
    NSMutableArray *extra_orders = [[NSMutableArray alloc] init];
    for(int i = 0; i < self.m_extdata.count ; i++){
        ExtraMenu* one = self.m_extdata[i];
        if([one.count integerValue] != 0){
            if([one.count integerValue] != [extrafoodTree.m_chooseCount[one.menuId] integerValue]){
                return false;
            } else{
                BOOL bflag = false;
                ExtraMenu* order_menu = [[ExtraMenu alloc] init];
                NSMutableArray* order_foods = [[NSMutableArray alloc] init];
                for(int j = 0; j < one.extrafoods.count; j++){
                    ExtraFood* other = one.extrafoods[j];
                    ExtraFood* new_food = [[ExtraFood alloc] init];
                    new_food.eid = other.eid;
                    new_food.menuId = other.menuId;
                    new_food.foodname = other.foodname;
                    new_food.price = other.price;
                    new_food.bCheck = other.bCheck;
                    if(new_food.bCheck){
                        [order_foods addObject:new_food];
                        bflag = true;
                    }
                }
                order_menu.menuId = one.menuId;
                order_menu.menuName = one.menuName;
                order_menu.count = one.count;
                order_menu.foodId = one.foodId;
                order_menu.extrafoods = order_foods;
                if(bflag)
                    [extra_orders addObject:order_menu];
            }
        } else{
            return false;
        }
    }
    self.data.extrafoods = extra_orders;
    return true;
}
@end
