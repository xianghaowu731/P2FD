//
//  ImageChooser.m
//  ChatApp
//
//  Created by Dick Arnold on 6/11/15.
//  Copyright (c) 2015 YAKEN. All rights reserved.
//

#import "ImageChooser.h"

@implementation ImageChooser

@synthesize m_popoverController;
@synthesize m_pickerController;

- (void) showActionSheet:(UIViewController *)controller
               Completed:(void (^)(UIImage *))completed
{
    m_controller = controller;
    m_completed = completed;
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Image from..." delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Image Gallary", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [actionSheet showInView:controller.view];
}

#pragma mark - action sheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
        {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                picker.delegate = self;
                
                [m_controller presentViewController:picker animated:YES completion:nil];            }
            break;
        }
            
        case 1:
        {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            if(m_popoverController != nil) {
                [m_popoverController dismissPopoverAnimated:YES];
                m_popoverController = nil;
            }
            
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
            {
                imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                {
                    m_popoverController = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
                    m_popoverController.delegate = self;
                    [m_popoverController presentPopoverFromRect:CGRectMake(0, 0, 1024, 160)
                                                         inView:m_controller.view
                                       permittedArrowDirections:UIPopoverArrowDirectionAny
                                                       animated:YES];
                }
                else {
                    
                    [m_controller presentViewController:imagePicker animated:YES completion:nil];
                }
            }
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - image picker controller

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    self.m_pickerController = picker;
    
    [self openEditor:img];
}

- (void) openEditor:(UIImage *) editImage {
    
    PECropViewController *controller = [[PECropViewController alloc] init];
    controller.delegate = self;
    controller.image = editImage;
    controller.cropAspectRatio = 1.0f;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    [self.m_pickerController presentViewController:navigationController animated:YES completion:NULL];
}

#pragma mark - PECropViewController Delegate
- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage
{
    [controller dismissViewControllerAnimated:YES completion:^(void) {
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            [m_popoverController dismissPopoverAnimated:YES];
        else
            [self.m_pickerController dismissViewControllerAnimated:YES completion:nil];
        
        m_completed(croppedImage);
    }];
}

- (void) cropViewControllerDidCancel:(PECropViewController *) controller {
    
    [controller dismissViewControllerAnimated:YES completion:^(void) {}];
}

@end
