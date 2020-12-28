//
//  Card3DSViewController.h
//  Custom Integration (ObjC)
//
//  Created by Ben Guo on 2/22/17.
//  Copyright © 2017 Stripe. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CheckViewControllerDelegate;

@interface ThreeDSViewController : UIViewController
- (IBAction)onBackClick:(id)sender;
- (IBAction)onPay:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *mPayImg;
@property (weak, nonatomic) IBOutlet UIView *mPayView;
@property (nonatomic, weak) id<CheckViewControllerDelegate> delegate;

@end
