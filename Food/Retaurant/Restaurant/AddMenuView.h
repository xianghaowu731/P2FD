//
//  AddMenuView.h
//  Food
//
//  Created by meixiang wu on 17/08/2017.
//  Copyright © 2017 Odelan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddMenuView : UIViewController

@property (strong, nonatomic) NSMutableArray* data;
@property (weak, nonatomic) IBOutlet UILabel *mNameLabel;
@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property (weak, nonatomic) IBOutlet UITextField *mEditText;

- (IBAction)onAddNewMenu:(id)sender;
- (IBAction)onBackClick:(id)sender;

@end
