//
//  RFoodEditVC.m
//  Food
//
//  Created by weiquan zhang on 6/19/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import "RFoodEditVC.h"
#import "Config.h"
#import <UIImageView+WebCache.h>
#import "SVProgressHUD.h"
#import "HttpApi.h"
#import "ImageChooser.h"
#import "Common.h"
#import "RExtraFoodVC.h"
#import "ExtraMenu.h"
#import "ExtraFood.h"

@interface RFoodEditVC ()<ExtraViewDelegate>

@property(strong, nonatomic) UIImage* image;

@end

@implementation RFoodEditVC{
    ImageChooser* imgChooser;
    NSString* imageUrl;
    RExtraFoodVC *extrafoodTree;
    NSInteger mMenuIndex, mEFoodIndex;
    NSString* menuIndex;
    BOOL bImgUpdate;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CALayer *imageLayer = self.mDescText.layer;
    [imageLayer setCornerRadius:5];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:[UIColor orangeColor].CGColor];
    self.mDescText.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    imageLayer = self.mNameText.layer;
    [imageLayer setCornerRadius:5];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:[UIColor orangeColor].CGColor];
    
    imageLayer = self.mPriceText.layer;
    [imageLayer setCornerRadius:5];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:[UIColor orangeColor].CGColor];
    
    imageLayer = self.mImageView.layer;
    [imageLayer setCornerRadius:5];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:[UIColor orangeColor].CGColor];
    
    imageLayer = self.mMenuNameTxt.layer;
    [imageLayer setCornerRadius:5];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:[UIColor orangeColor].CGColor];
    
    imageLayer = self.mMenuRequiredTxt.layer;
    [imageLayer setCornerRadius:5];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:[UIColor orangeColor].CGColor];
    
    imageLayer = self.mExtraView.layer;
    [imageLayer setCornerRadius:5];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:[UIColor orangeColor].CGColor];
    
    imageLayer = self.mEFoodNameLabel.layer;
    [imageLayer setCornerRadius:5];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:[UIColor orangeColor].CGColor];
    
    imageLayer = self.mPriceLabel.layer;
    [imageLayer setCornerRadius:5];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:[UIColor orangeColor].CGColor];
    
    //self.navigationItem.title = @"Edit Food";
    self.mAddFoodView.hidden = YES;
    self.m_data = [[NSMutableArray alloc] init];
    extrafoodTree = [[RExtraFoodVC alloc] init];
    extrafoodTree.m_data = self.m_data;
    extrafoodTree.delegate = self;
    [self addChildViewController:extrafoodTree];
    CGRect frame = extrafoodTree.view.frame;
    frame.size.height = self.mExtraView.bounds.size.height;
    frame.size.width = self.mExtraView.bounds.size.width;
    extrafoodTree.view.frame = frame;
    [self.mExtraView addSubview:extrafoodTree.view];
    [extrafoodTree didMoveToParentViewController:self];
    
    mMenuIndex = 0;
    mEFoodIndex = 0;
    menuIndex = @"";
    bImgUpdate = false;
    
    [self loadData];
    [self setLayout:self.data];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void) loadData{
    [SVProgressHUD show];
    [[HttpApi sharedInstance] getExtraFoodsByFoodId:self.data.foodId Completed:^(NSArray *array){
        [SVProgressHUD dismiss];
        self.m_data = [[NSMutableArray alloc] init];
        for(int i = 0 ; i < array.count ; i++){
            mMenuIndex++;
            ExtraMenu* one = [[ExtraMenu alloc] init];
            NSDictionary* dic = (NSDictionary*)array[i];
            one.menuId = [NSString stringWithFormat:@"%ld", mMenuIndex];//[dic objectForKey:@"id"];
            one.foodId = [dic objectForKey:@"food_id"];
            one.menuName = [dic objectForKey:@"menu_name"];
            one.count = [dic objectForKey:@"count"];
            one.extrafoods = [[NSMutableArray alloc] init];
            NSArray *darray = [dic objectForKey:@"extra_food"];
            for(int j=0; j< darray.count; j++){
                mEFoodIndex++;
                ExtraFood* other = [[ExtraFood alloc] initWithDictionary:darray[j]];
                other.eid = [NSString stringWithFormat:@"%ld", mEFoodIndex];
                other.menuId = one.menuId;
                [one.extrafoods addObject:other];
            }
            [self.m_data addObject:one];
        }
        extrafoodTree.m_data = self.m_data;
        [extrafoodTree refreshTable];
    }Failed:^(NSString *strError) {
        [SVProgressHUD showErrorWithStatus:strError];
    }];
}

- (void) setLayout:(Food*) f{
    self.updateData = f;
    self.data = f;
    self.mNameText.text = self.data.name;
    NSAttributedString* desc = [[NSAttributedString alloc] initWithData:[self.data.desc dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    self.mDescText.attributedText = desc;
    self.mDescText.textAlignment = NSTextAlignmentLeft;
    [self.mDescText setFont:[UIFont systemFontOfSize:13]];
    self.mPriceText.text = [NSString stringWithFormat:@"%.2f", self.data.price.floatValue];
    [self.mStatusBtn setTitle:self.data.status forState:UIControlStateNormal];//.text = self.data.status;
    NSString* url = [NSString stringWithFormat:@"%@%@%@", SERVER_URL, FOOD_IMAGE_BASE_URL, self.data.img];
    [self.mImageView sd_setImageWithURL:[NSURL URLWithString:url]];
    if([self.data.status isEqualToString:STATUS_FOOD_ACTIVE]){
        [self.mStatusSwitch setOn:true];
    } else {
        [self.mStatusSwitch setOn:false];
    }
    self.image = [self.mImageView image];
}

- (void) didAddFoodItem:(NSString *)mID{//delegate function
    self.mAddFoodView.hidden = NO;
    menuIndex = mID;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)onClickUpdate:(id)sender {
    if(bImgUpdate){
        [SVProgressHUD show];
        UIImage *small = [Common resizeImage:self.image];
        NSData *postData = UIImagePNGRepresentation(small);
        [[HttpApi sharedInstance] foodImagePost:postData Completed:^(NSString *image) {
            imageUrl = image;
            [self updateFood];
        } Failed:^(NSString *strError) {
          //[SVProgressHUD dismiss];
          [SVProgressHUD showErrorWithStatus:strError];
        }];
    } else{
        [SVProgressHUD show];
        imageUrl = self.data.img;
        [self updateFood];
    }
}

- (void) updateFood {
    //make extra item
    NSString* extraStr=@"";
    if(self.m_data.count > 0){
        NSDictionary* json_dic = [self makeDictionaryForList];
        NSError * error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:json_dic options:NSJSONReadingMutableContainers error:&error];
        extraStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];//NSASCIIStringEncoding
    }
    float priceVal = [self.mPriceText.text floatValue];
    NSString* priceStr = [NSString stringWithFormat:@"%.2f", priceVal];
    //------------------
    [[HttpApi sharedInstance] uploadFoodByFoodId:(NSString *)self.data.foodId
                                            name:(NSString *)self.mNameText.text
                                     Description:(NSString *)self.mDescText.text
                                           price:(NSString *)priceStr
                                          status:(NSString *)self.updateData.status
                                           image:(NSString *)imageUrl
                                           Extra:(NSString *)extraStr
                                       Completed:^(NSString *array){
                                               [SVProgressHUD dismiss];
                                               //NSDictionary* data = (NSDictionary*) array;
                                               self.data = self.updateData;
                                               self.data.img = imageUrl;
                                               UIAlertController * alert=   [UIAlertController
                                                                             alertControllerWithTitle:@"Success"
                                                                             message:@"Successfully updated."
                                                                             preferredStyle:UIAlertControllerStyleAlert];
                                               
                                               UIAlertAction* yesButton = [UIAlertAction
                                                                           actionWithTitle:@"Ok"
                                                                           style:UIAlertActionStyleDefault
                                                                           handler:^(UIAlertAction * action)
                                                                           {
                                                                               [self.navigationController popViewControllerAnimated:YES];
                                                                               
                                                                           }];
                                               [alert addAction:yesButton];
                                               [self presentViewController:alert animated:YES completion:nil];
                                               return;
                                           }Failed:^(NSString *strError) {
                                               [SVProgressHUD showErrorWithStatus:strError];
                                           }];
}

- (IBAction)onClickSwitch:(id)sender {
    if([self.mStatusSwitch isOn]){
        self.updateData.status = STATUS_FOOD_ACTIVE;
        [self.mStatusBtn setTitle: STATUS_FOOD_ACTIVE forState:UIControlStateNormal];
    } else {
        self.updateData.status = STATUS_FOOD_INACTIVE;
        [self.mStatusBtn setTitle: STATUS_FOOD_INACTIVE forState:UIControlStateNormal];
    }
}

- (IBAction)onClickPhotoClick:(id)sender {
    imgChooser = [[ImageChooser alloc] init];
    [imgChooser showActionSheet:self Completed:^(UIImage* img){
        [self.mImageView setImage:img];
        self.image = img;
        bImgUpdate = true;
    }];
    
}

- (IBAction)onDelete:(id)sender {
    [SVProgressHUD show];
    
    [[HttpApi sharedInstance] delFoodByFoodId:self.data.foodId Completed:^(NSString *array){
        [SVProgressHUD dismiss];
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Success"
                                      message:@"Successfully removed."
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"Ok"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        [self.navigationController popViewControllerAnimated:YES];
                                        
                                    }];
        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }Failed:^(NSString *strError) {
        [SVProgressHUD showErrorWithStatus:strError];
    }];
}

- (IBAction)onBackClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onAddMenuClick:(id)sender {
    if([self.mMenuNameTxt.text length] == 0){
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Notice!"
                                      message:@"Please enter extra menu name."
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
    mMenuIndex++;
    NSMutableArray *subArray = [[NSMutableArray alloc] init];
    ExtraMenu *one = [[ExtraMenu alloc] init];
    one.menuName = self.mMenuNameTxt.text;
    one.menuId = [NSString stringWithFormat:@"%ld", mMenuIndex];
    one.count = [NSString stringWithFormat:@"%ld", [self.mMenuRequiredTxt.text integerValue]];
    one.extrafoods = subArray;
    [self.m_data addObject:one];
    //extrafoodTree.m_data = self.m_data;
    [extrafoodTree refreshTable];
    self.mMenuNameTxt.text = @"";
    self.mMenuRequiredTxt.text = @"1";
}

- (IBAction)onAddViewHideClick:(id)sender {
    self.mAddFoodView.hidden = YES;
}

- (IBAction)onExtraFoodAddClick:(id)sender {
    if([self.mEFoodNameLabel.text length] == 0){
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Notice!"
                                      message:@"Please enter extra food name."
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
    mEFoodIndex++;
    ExtraFood *one = [[ExtraFood alloc] init];
    one.eid = [NSString stringWithFormat:@"%ld", mEFoodIndex];
    one.foodname = self.mEFoodNameLabel.text;
    one.price = [NSString stringWithFormat:@"%.2f", [self.mPriceLabel.text floatValue]];
    one.menuId = menuIndex;
    for(int i = 0 ; i < self.m_data.count ; i++){
        ExtraMenu* mm = self.m_data[i];
        if([mm.menuId isEqualToString:menuIndex]){
            [mm.extrafoods addObject:one];
            break;
        }
    }
    menuIndex = @"";
    self.mAddFoodView.hidden = YES;
    [extrafoodTree refreshTable];
    self.mEFoodNameLabel.text = @"";
    self.mPriceLabel.text = @"";
}

- (NSDictionary*) makeDictionaryForList{
    NSMutableArray *properties_array = [[NSMutableArray alloc] init];
    for(int i=0; i< self.m_data.count; i++){
        ExtraMenu *one = (ExtraMenu*) self.m_data[i];
        NSMutableArray *foods_array = [[NSMutableArray alloc] init];
        for(int j = 0; j < one.extrafoods.count; j++){
            ExtraFood *other = (ExtraFood*) one.extrafoods[j];
            NSDictionary *pro_dic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:other.foodname,other.price, nil] forKeys:[NSArray arrayWithObjects:@"food_name", @"price", nil]];
            [foods_array addObject:pro_dic];
        }
        //NSString *favstr = [NSString stringWithFormat:@"%@",[one.mFavorite stringValue]];
        NSDictionary *menu_dic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:one.menuName, one.count, foods_array, nil] forKeys:[NSArray arrayWithObjects:@"menu_name", @"count", @"extrafoods", nil]];
        [properties_array addObject:menu_dic];
    }
    NSDictionary * result_dic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:properties_array, nil] forKeys:[NSArray arrayWithObjects:@"extras", nil]];
    return result_dic;
}

@end
