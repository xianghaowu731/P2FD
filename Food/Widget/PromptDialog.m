//
//  ConfirmDialog.m
//  ChatApp
//
//  Created by Dick Arnold on 6/12/15.
//  Copyright (c) 2015 YAKEN. All rights reserved.
//

#import "PromptDialog.h"

@implementation PromptDialog

- (void)showWithTitle:(NSString *)title
              Message:(NSString *)message
          PlaceHolder:(NSString *)placeholder
              PreText:(NSString *)pretext
            OkCaption:(NSString *)okCaption
        CancelCaption:(NSString *)cancelCaption
                   Ok:(void (^)(NSString*))ok
               Cancel:(void (^)())cancel
{
    m_ok = ok;
    m_cancel = cancel;
    
    m_alertView = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:cancelCaption otherButtonTitles:okCaption, nil];
    m_alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField * alertTextField = [m_alertView textFieldAtIndex:0];
    alertTextField.placeholder = placeholder;
    if(![pretext isEqualToString:@""])
        alertTextField.text = pretext;
    [m_alertView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString* comment = [[alertView textFieldAtIndex:0] text];
    switch(buttonIndex) {
        case 0:
            m_cancel();
            break;
        case 1:
            m_ok(comment);
            break;
    }
}

@end
