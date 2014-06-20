//
//  FLTHomeScreenViewController.m
//  FilterLab
//
//  Created by Cody Caldwell on 6/13/14.
//  Copyright (c) 2014 Cody Caldwell. All rights reserved.
//

#import "FLTHomeScreenViewController.h"
#import "FLTCameraViewController.h"
#import "FLTPhotoPreviewViewController.h"
#import "FLTPhotoEditorViewController.h"

@interface FLTHomeScreenViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, FLTPhotoPreviewViewControllerDelegate, FLTCameraViewControllerDelegate>

@end

@implementation FLTHomeScreenViewController

- (BOOL)shouldAutorotate {
    return NO;
}

#pragma mark - UIImagePickerController delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    FLTPhotoPreviewViewController *pvc = [[FLTPhotoPreviewViewController alloc] init];
    pvc.image = image;
    pvc.delegate = self;
    [picker presentViewController:pvc animated:YES completion:NULL];
}

#pragma mark - FLTPhotoPreviewController delegate methods

- (void)photoPreviewCancelPreview:(FLTPhotoPreviewViewController *)photoPreview {
    
    [photoPreview.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)photoPreview:(FLTPhotoPreviewViewController *)photoPreview useImage:(UIImage *)image {
    
    [self dismissViewControllerAnimated:YES completion:^{
        [self openPhotoEditorWithImage:image];
    }];
}

#pragma mark - FLTCameraViewController delegate methods

- (void)cameraViewController:(FLTCameraViewController *)camera didCaptureImage:(UIImage *)image {
    
    [self dismissViewControllerAnimated:YES completion:^{
        [self openPhotoEditorWithImage:image];
    }];
}

#pragma mark - Actions

- (IBAction)presentCamera:(id)sender {
    
    FLTCameraViewController *cvc = [[FLTCameraViewController alloc] init];
    cvc.delegate = self;
    [self presentViewController:cvc animated:YES completion:NULL];
}

- (IBAction)presentPhotoLibary:(id)sender {
    
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    // Let the user choose which album they want to use
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    ipc.delegate = self;
    [self presentViewController:ipc animated:YES completion:NULL];
}

#pragma mark - Helper methods

- (void)openPhotoEditorWithImage:(UIImage *)image {
    
    FLTPhotoEditorViewController *evc = [[FLTPhotoEditorViewController alloc] init];
    evc.image = image;
    [self presentViewController:evc animated:YES completion:NULL];
}

@end
