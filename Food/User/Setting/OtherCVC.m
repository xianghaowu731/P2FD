//
//  OtherCVC.m
//  Food
//
//  Created by weiquan zhang on 6/20/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import "OtherCVC.h"

@interface OtherCVC ()

@end

@implementation OtherCVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = self.mTitle;
    self.mTextView.text = self.mContent;
    
    NSStringEncoding encoding;
    NSError* error = nil;
    NSString* bundlePath = [[NSBundle mainBundle] bundlePath];
    
    NSString* htmlPath = [[NSBundle mainBundle] pathForResource:@"terms" ofType:@"htm"];
    NSString* htmlContent = [NSString stringWithContentsOfFile:htmlPath usedEncoding:&encoding error:&error];
    if (error == nil) // Manage the error
        [self.mWebView loadHTMLString:htmlContent baseURL:[NSURL fileURLWithPath:bundlePath]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [self.navigationController popViewControllerAnimated:YES];
}
@end
