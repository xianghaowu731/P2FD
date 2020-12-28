//
//  ConfirmDialog.h
//  ChatApp
//
//  Created by Dick Arnold on 6/12/15.
//  Copyright (c) 2015 YAKEN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PromptDialog : NSObject <UIAlertViewDelegate>
{
    UIAlertView *m_alertView;
    void (^m_ok)();
    void (^m_cancel)();
}

- (void)showWithTitle:(NSString *)title
              Message:(NSString *)message
          PlaceHolder:(NSString *)placeholder
              PreText:(NSString *)pretext
            OkCaption:(NSString *)okCaption
        CancelCaption:(NSString *)cancelCaption
                   Ok:(void (^)(NSString*))ok
               Cancel:(void (^)())cancel;
@end
