//
//  RestaurantMVCViewController.m
//  Food
//
//  Created by meixiang wu on 5/13/17.
//  Copyright © 2017 Odelan. All rights reserved.
//

#import "RestaurantMVC.h"
#import "Config.h"
#import "Common.h"
#import "SVProgressHUD.h"
#import "HttpApi.h"
#import "Restaurant.h"
#import <UIImageView+WebCache.h>
#import "RFoodCategory.h"
#import "AddMenuView.h"

@interface RestaurantMVC ()
@property (strong, nonatomic) NSArray *colors;
@property (strong, nonatomic) NSString* restName;
@end

extern Restaurant *owner;

@implementation RestaurantMVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /*[self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        self.navigationController.navigationBar.tintColor = PRIMARY_COLOR;
        
    } else {// iOS 7.0 or later
        self.navigationController.navigationBar.barTintColor = PRIMARY_COLOR;
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        self.navigationController.navigationBar.translucent = NO;
    }
    self.navigationItem.title = @"Restaurant";*/
    
    self.colors = @[ [UIColor colorWithRed:1.0f green:0.58f blue:0.0f alpha:1.0f], [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.0f], [UIColor colorWithRed:0.1f green:1.0f blue:0.1f alpha:1.0f]];
    // Setup control using iOS7 tint Color
    self.mRatingView.backgroundColor  = self.colors[1];//[UIColor whiteColor];
    self.mRatingView.starImage = [[UIImage imageNamed:@"star-template"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.mRatingView.starHighlightedImage = [[UIImage imageNamed:@"star-highlighted-template"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.mRatingView.maxRating = 5.0;
    self.mRatingView.delegate = self;
    self.mRatingView.horizontalMargin = 5.0;
    self.mRatingView.editable=NO;
    float rating = 4.65f;
    self.mRatingView.rating= rating;
    self.mRatingView.displayMode=EDStarRatingDisplayAccurate;
    [self.mRatingView  setNeedsDisplay];
    self.mRatingView.tintColor = self.colors[0];
    self.mRatingLabel.text = [NSString stringWithFormat:@"%.1f", rating];
    //[self starsSelectionChanged:self.mRatingView rating:2.5];
    
    CALayer *imageLayer = self.mStatusIcon.layer;
    [imageLayer setCornerRadius:self.mStatusIcon.frame.size.width/2];
    [imageLayer setBorderWidth:0];
    [imageLayer setMasksToBounds:YES];
    //[imageLayer setBorderColor:self.colors[2].CGColor];
    [self.mImageView setBackgroundColor:self.colors[2]];
    
    RFoodCategory *foodTreeview = [[RFoodCategory alloc] init];
    [self addChildViewController:foodTreeview];
    CGRect frame = foodTreeview.view.frame;
    frame.size.height = self.mView.bounds.size.height;
    foodTreeview.view.frame = frame;//[[UIScreen mainScreen] bounds];
    [self.mView addSubview:foodTreeview.view];
    [foodTreeview didMoveToParentViewController:self];

    [self setLayout];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setLayout {
    NSString* url = [NSString stringWithFormat:@"%@%@%@", SERVER_URL, RESTAURANT_IMAGE_BASE_URL, owner.img];
    [self.mImageView sd_setImageWithURL:[NSURL URLWithString:url]];
    self.mStatusLabel.text = owner.status;
    if([owner.status isEqualToString:STATUS_OPEN]){
        [self.mStatusIcon setBackgroundColor:OPEN_COLOR];
    } else if([owner.status isEqualToString:STATUS_CLOSE]) {
        [self.mStatusIcon setBackgroundColor:CLOSE_COLOR];
    } else {
        [self.mStatusIcon setBackgroundColor:BUSY_COLOR];
    }
    float rating = [owner.ranking floatValue];
    self.mRatingView.rating= rating;
    [self.mRatingView  setNeedsDisplay];
    self.mRatingLabel.text = [NSString stringWithFormat:@"%.1f", rating];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setLayout];
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
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController* mVC = [sb instantiateViewControllerWithIdentifier:@"SID_InitNC"];
    [self presentViewController:mVC animated:YES completion:NULL];
}

- (IBAction)onEditMenuClick:(id)sender {
    AddMenuView* mVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_AddMenuView"];
    [self.navigationController pushViewController:mVC animated:YES];
    
}
@end
