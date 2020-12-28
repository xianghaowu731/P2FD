//
//  FavoriteCVC.h
//  Food
//
//  Created by weiquan zhang on 6/20/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCRTableViewRefreshController.h"


@interface FavoriteCVC : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) RCRTableViewRefreshController *refreshController;

@property (strong, nonatomic) NSMutableArray* restData;
@property (strong, nonatomic) NSMutableArray* foodData;
@property (nonatomic) UIImage *cartImg;

@property (strong, nonatomic) IBOutlet UIButton *mRestBtn;
@property (strong, nonatomic) IBOutlet UIButton *mFoodBtn;
@property (strong, nonatomic) IBOutlet UITableView *mTableView;
@property (weak, nonatomic) IBOutlet UIButton *mCartBtn;


- (IBAction)onRestBtnClick:(id)sender;
- (IBAction)onFoodBtnClick:(id)sender;
- (IBAction)onBackClick:(id)sender;
- (IBAction)onCartClick:(id)sender;

@end
