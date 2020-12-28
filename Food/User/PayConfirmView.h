//
//  PayConfirmView.h
//  Food
//
//  Created by meixiang wu on 06/09/2017.
//  Copyright © 2017 Odelan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayConfirmView : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *mOrderNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *mInformLabel;
- (IBAction)onClickOK:(id)sender;

@property (strong, nonatomic) NSString* mStatus;
@property (strong, nonatomic) NSString* mOrder;

@end
