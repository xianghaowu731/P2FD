//
//  RFoodEditVC.m
//  Food
//
//  Created by weiquan zhang on 6/19/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import "RFoodAddVC.h"
#import "Config.h"
#import <UIImageView+WebCache.h>
#import "SVProgressHUD.h"
#import "HttpApi.h"
#import "ImageChooser.h"
#import "Common.h"
#import "RExtraFoodVC.h"
#import "ExtraMenu.h"
#import "ExtraFood.h"

@interface RFoodAddVC ()<ExtraViewDelegate>

@property(strong, nonatomic) UIImage* image;

@end

@implementation RFoodAddVC{
    ImageChooser* imgChooser;
    NSString* imageUrl;
    RExtraFoodVC *extrafoodTree;
    NSInteger mMenuIndex, mEFoodIndex;
    NSString* menuIndex;
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
    
    imageLayer = self.mAddExtraNameTxt.layer;
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
    
    imageLayer = self.mEfoodNameLabel.layer;
    [imageLayer setCornerRadius:5];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:[UIColor orangeColor].CGColor];
    
    imageLayer = self.mEPriceLabel.layer;
    [imageLayer setCornerRadius:5];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:[UIColor orangeColor].CGColor];
    //self.navigationItem.title = @"Add Food";
    self.mAddView.hidden = YES;
    
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
    
    [self setLayout:self.data];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) didAddFoodItem:(NSString *)mID{//delegate function
    self.mAddView.hidden = NO;
    menuIndex = mID;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void) setLayout:(Food*) f{
    self.data = f;
    self.mNameText.text = self.data.name;
    NSAttributedString* desc = [[NSAttributedString alloc] initWithData:[self.data.desc dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    self.mDescText.attributedText = desc;
    self.mDescText.textAlignment = NSTextAlignmentLeft;
    [self.mDescText setFont:[UIFont systemFontOfSize:12]];
    self.mPriceText.text = [NSString stringWithFormat:@"%.2f", self.data.price.floatValue];
    if([self.data.img length]!=0){
        NSString* url = [NSString stringWithFormat:@"%@%@%@", SERVER_URL, FOOD_IMAGE_BASE_URL, self.data.img];
        [self.mImageView sd_setImageWithURL:[NSURL URLWithString:url]];
    } else{
        [self.mImageView setImage:[UIImage imageNamed:@"sample_food.png"]];
    }
    
    self.image = [self.mImageView image];
    //[self.mTableView reloadData];
}

- (IBAction)onAddClick:(id)sender {
    [SVProgressHUD show];
    UIImage *small = [Common resizeImage:self.image];
    NSData *postData = UIImagePNGRepresentation(small);
    [[HttpApi sharedInstance] foodImagePost:postData Completed:^(NSString *image) {
        imageUrl = image;
        [self addFood];
    } Failed:^(NSString *strError) {
          //[SVProgressHUD dismiss];
          [SVProgressHUD showErrorWithStatus:strError];
     }];

}

- (IBAction)mPhotoClick:(id)sender {
    imgChooser = [[ImageChooser alloc] init];
    [imgChooser showActionSheet:self Completed:^(UIImage* img){
        [self.mImageView setImage:img];
        self.image = img;
    }];
}

- (IBAction)onBackClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onAddExtraMenu:(id)sender {
    if([self.mAddExtraNameTxt.text length] == 0){
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
    one.menuName = self.mAddExtraNameTxt.text;
    one.menuId = [NSString stringWithFormat:@"%ld", mMenuIndex];
    one.count = [NSString stringWithFormat:@"%ld", [self.mMenuRequiredTxt.text integerValue]];
    one.extrafoods = subArray;
    [self.m_data addObject:one];
    //extrafoodTree.m_data = self.m_data;
    [extrafoodTree refreshTable];
    self.mAddExtraNameTxt.text = @"";
    self.mMenuRequiredTxt.text = @"1";
}

- (IBAction)onAddViewHide:(id)sender {
    self.mAddView.hidden = YES;
}

- (IBAction)onAddExtraFoodClick:(id)sender {
    if([self.mEfoodNameLabel.text length] == 0){
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
    one.foodname = self.mEfoodNameLabel.text;
    one.price = [NSString stringWithFormat:@"%.2f",[self.mEPriceLabel.text floatValue]];
    one.menuId = menuIndex;
    for(int i = 0 ; i < self.m_data.count ; i++){
        ExtraMenu* mm = self.m_data[i];
        if([mm.menuId isEqualToString:menuIndex]){
            [mm.extrafoods addObject:one];
            break;
        }
    }
    menuIndex = @"";
    self.mAddView.hidden = YES;
    [extrafoodTree refreshTable];
    self.mEfoodNameLabel.text = @"";
    self.mEPriceLabel.text = @"";
}

- (void) addFood {
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
    [[HttpApi sharedInstance] registerFoodWithCategory:(NSString *)self.data.restId
                                      name:(NSString *)self.mNameText.text
                               Description:(NSString *)self.mDescText.text
                                     price:(NSString *)priceStr
                                    status:(NSString *)@"active"
                                     image:(NSString *)imageUrl
                                  Category:(NSString *)self.categoryId
                                     Extra:(NSString *)extraStr
                                  Completed:^(NSString *array){
                                         [SVProgressHUD dismiss];
                                         //NSDictionary* data = (NSDictionary*) array;
                                         self.data.img = imageUrl;
                                         UIAlertController * alert=   [UIAlertController
                                                                       alertControllerWithTitle:@"Success"
                                                                       message:@"Successfully register."
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
    /*[[HttpApi sharedInstance] registerFood:(NSString *)self.data.restId
                                            name:(NSString *)self.mNameText.text
                                     Description:(NSString *)self.mDescText.text
                                           price:(NSString *)self.mPriceText.text
                                          status:(NSString *)@"active"
                                           image:(NSString *)imageUrl Completed:^(NSString *array){
                                               [SVProgressHUD dismiss];
                                               //NSDictionary* data = (NSDictionary*) array;
                                               self.data.img = imageUrl;
                                               UIAlertController * alert=   [UIAlertController
                                                                             alertControllerWithTitle:@"Success"
                                                                             message:@"Successfully register."
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
                                           }];*/
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
        NSDictionary *menu_dic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:one.menuName, one.count,foods_array, nil] forKeys:[NSArray arrayWithObjects:@"menu_name", @"count", @"extrafoods", nil]];
        [properties_array addObject:menu_dic];
    }
    NSDictionary * result_dic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:properties_array, nil] forKeys:[NSArray arrayWithObjects:@"extras", nil]];
    return result_dic;
}
@end
