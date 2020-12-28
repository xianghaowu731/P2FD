//
//  SettingCVC.h
//  Food
//
//  Created by weiquan zhang on 6/17/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingCVC : UIViewController<UITableViewDelegate, UITableViewDataSource>


@property (strong, nonatomic) IBOutlet UITableView *mTableView;
- (IBAction)onBackClick:(id)sender;


@end
