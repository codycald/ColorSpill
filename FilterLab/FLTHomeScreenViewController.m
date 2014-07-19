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
#import "MRoundedButton.h"

@interface FLTHomeScreenViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate,
FLTPhotoPreviewViewControllerDelegate, FLTCameraViewControllerDelegate, FLTPhotoEditorViewControllerDelegate> {
    
    MRoundedButton *cameraButton;
    MRoundedButton *photoLibraryButton;
}

@end

@implementation FLTHomeScreenViewController

#pragma mark - View lifecycle

- (void)loadView {
    
    [super loadView];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.45f green:0.72f blue:0.91f alpha:1.0f];
    
    // Create the title
    UIImageView *logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Logo"]];
    
    // Describe the appearence of our camera and photo library buttons
    NSDictionary *cameraAppearenceProxy = @{kMRoundedButtonCornerRadius : @FLT_MAX,
                                            kMRoundedButtonBorderWidth : @3,
                                            kMRoundedButtonBorderColor : [UIColor colorWithRed:0.30f green:0.30f blue:0.30f alpha:1.0f],
                                            kMRoundedButtonBorderAnimationColor : [UIColor colorWithRed:0.20 green:0.20 blue:0.20 alpha:1.0],
                                            kMRoundedButtonContentColor : [UIColor colorWithRed:0.30f green:0.30f blue:0.30f alpha:1.0f],
                                            kMRoundedButtonContentAnimationColor : [UIColor colorWithRed:0.20 green:0.20 blue:0.20 alpha:1.0],
                                            kMRoundedButtonForegroundColor : [UIColor colorWithRed:0.98f green:0.32f blue:0.05f alpha:1.0f],
                                            kMRoundedButtonForegroundAnimationColor : [UIColor colorWithRed:0.56 green:0.16 blue:0.0 alpha:1.0]};
    
    NSDictionary *photoLibraryAppearenceProxy = @{kMRoundedButtonCornerRadius : @FLT_MAX,
                                                  kMRoundedButtonBorderWidth : @3,
                                                  kMRoundedButtonBorderColor : [UIColor colorWithRed:0.30f green:0.30f blue:0.30f alpha:1.0f],
                                                  kMRoundedButtonBorderAnimationColor : [UIColor colorWithRed:0.20 green:0.20 blue:0.20 alpha:1.0],
                                                  kMRoundedButtonContentColor : [UIColor colorWithRed:0.30f green:0.30f blue:0.30f alpha:1.0f],
                                                  kMRoundedButtonContentAnimationColor : [UIColor colorWithRed:0.20 green:0.20 blue:0.20 alpha:1.0],
                                                  kMRoundedButtonForegroundColor : [UIColor colorWithRed:0.51f green:0.78f blue:0.25f alpha:1.0f],
                                                  kMRoundedButtonForegroundAnimationColor : [UIColor colorWithRed:0.20 green:0.38 blue:0.01 alpha:1.0]};
    
    [MRoundedButtonAppearanceManager registerAppearanceProxy:cameraAppearenceProxy
                                               forIdentifier:@"cameraButton"];
    [MRoundedButtonAppearanceManager registerAppearanceProxy:photoLibraryAppearenceProxy
                                               forIdentifier:@"photoLibraryButton"];
    
    // Create the camera and photo library buttons
    cameraButton = [MRoundedButton buttonWithFrame:CGRectZero
                                       buttonStyle:MRoundedButtonCentralImage
                              appearanceIdentifier:@"cameraButton"];
    
    photoLibraryButton = [MRoundedButton buttonWithFrame:CGRectZero
                                             buttonStyle:MRoundedButtonCentralImage
                                    appearanceIdentifier:@"photoLibraryButton"];
    
    cameraButton.imageView.image = [UIImage imageNamed:@"Camera"];
    photoLibraryButton.imageView.image =[UIImage imageNamed:@"Picture_Fields"];
    
    cameraButton.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    photoLibraryButton.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    
    // Set actions for each button
    [cameraButton addTarget:self
                     action:@selector(presentCamera:)
           forControlEvents:UIControlEventTouchUpInside];
    
    [photoLibraryButton addTarget:self
                           action:@selector(presentPhotoLibary:)
                 forControlEvents:UIControlEventTouchUpInside];
    
    // Add the views to the view controllers view
    [self.view addSubview:logoView];
    [self.view addSubview:cameraButton];
    [self.view addSubview:photoLibraryButton];
    
    // Configure the layout of our views
    logoView.translatesAutoresizingMaskIntoConstraints = NO;
    cameraButton.translatesAutoresizingMaskIntoConstraints = NO;
    photoLibraryButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    // Create the lookup dictionary for our views
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(logoView, cameraButton, photoLibraryButton);
    
    // Define the vertical layout constraints
    NSArray *titleVerticalConstraints = [NSLayoutConstraint
                                         constraintsWithVisualFormat:@"V:|-50-[logoView]-45-[cameraButton(==90)]-(<=45)-[photoLibraryButton(==90)]-(>=30)-|"
                                         options:0
                                         metrics:nil
                                         views:viewsDictionary];
    
    // Define the horizontal layout constraints involving the title
    NSArray *titleHorizontalConstraints = [NSLayoutConstraint
                                           constraintsWithVisualFormat:@"H:|-20-[logoView]-20-|"
                                           options:0
                                           metrics:nil
                                           views:viewsDictionary];
    
    // Define the horizontal layout constraints involving the buttons
    NSArray *cameraHorizontalConstraints = [NSLayoutConstraint
                                            constraintsWithVisualFormat:@"H:|-120-[cameraButton(==90)]"
                                            options:0
                                            metrics:nil
                                            views:viewsDictionary];
    NSArray *photoLibraryHorizontalConstraints = [NSLayoutConstraint
                                                  constraintsWithVisualFormat:@"H:|-120-[photoLibraryButton(==90)]"
                                                  options:0
                                                  metrics:nil
                                                  views:viewsDictionary];
    
    // Add all the constraints to the base view
    [self.view addConstraints:titleHorizontalConstraints];
    [self.view addConstraints:titleVerticalConstraints];
    [self.view addConstraints:cameraHorizontalConstraints];
    [self.view addConstraints:photoLibraryHorizontalConstraints];
}

#pragma mark - UIViewController overrides

- (BOOL)shouldAutorotate {
    return NO;
}

#pragma mark - UIImagePickerController delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    // Hide status bar
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    FLTPhotoPreviewViewController *pvc = [[FLTPhotoPreviewViewController alloc] init];
    pvc.image = image;
    pvc.delegate = self;
    [picker presentViewController:pvc animated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
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

#pragma mark - FLTPhotoEditorViewController delegate methods

- (void)photoEditorViewControllerDidCancel:(FLTPhotoEditorViewController *)photoEditor {
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Actions

- (IBAction)presentCamera:(id)sender {
    
    if (photoLibraryButton.isHighlighted) {
        return;
    }
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        FLTCameraViewController *cvc = [[FLTCameraViewController alloc] init];
        cvc.delegate = self;
        [self presentViewController:cvc animated:YES completion:NULL];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No camera"
                                                        message:@"This device does not have a camera. Please select an image from your photo library."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)presentPhotoLibary:(id)sender {
    
    if (cameraButton.isHighlighted) {
        return;
    }
    
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
    evc.delegate = self;
    [self presentViewController:evc animated:YES completion:NULL];
}

@end
