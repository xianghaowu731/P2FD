//
//  ConfirmDialog.m
//  ChatApp
//
//  Created by Dick Arnold on 6/12/15.
//  Copyright (c) 2015 YAKEN. All rights reserved.
//

#import "ConfirmDialog.h"

@implementation ConfirmDialog

- (void)showWithTitle:(NSString *)title
              Message:(NSString *)message
            OkCaption:(NSString *)okCaption
        CancelCaption:(NSString *)cancelCaption
                   Ok:(void (^)())ok
               Cancel:(void (^)())cancel
{
    m_ok = ok;
    m_cancel = cancel;
    
    m_alertView = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:cancelCaption otherButtonTitles:okCaption, nil];
    [m_alertView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch(buttonIndex) {
        case 0:
            m_cancel();
            break;
        case 1:
            m_ok();
            break;
    }
}

@end
