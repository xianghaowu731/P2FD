//
//  ImageChooser.h
//  ChatApp
//
//  Created by Dick Arnold on 6/11/15.
//  Copyright (c) 2015 YAKEN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PECropViewController.h"

@interface ImageChooser : NSObject <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPopoverControllerDelegate, PECropViewControllerDelegate>
{
    UIViewController *m_controller;
    void (^m_completed)(UIImage *);
}

@property (nonatomic, retain) UIPopoverController *m_popoverController;
@property (nonatomic, retain) UIImagePickerController *m_pickerController;

- (void)showActionSheet:(UIViewController *)controller
              Completed:(void (^)(UIImage *))completed;
@end
