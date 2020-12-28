//
//  OtherCVC.h
//  Food
//
//  Created by weiquan zhang on 6/20/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OtherCVC : UIViewController

@property (strong, nonatomic) NSString* mTitle;
@property (strong, nonatomic) NSString* mContent;


@property (weak, nonatomic) IBOutlet UIWebView *mWebView;
@property (strong, nonatomic) IBOutlet UITextView *mTextView;
- (IBAction)onBackClick:(id)sender;

@end
