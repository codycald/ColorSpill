//
//  CSHomeScreenViewController.m
//  ColorSpill
//
//  Created by Cody Caldwell on 6/13/14.
//  Copyright (c) 2014 Cody Caldwell. All rights reserved.
//

#import "CSHomeScreenViewController.h"
#import "CSCameraViewController.h"
#import "CSPhotoPreviewViewController.h"
#import "CSPhotoEditorViewController.h"
#import "MRoundedButton.h"

@interface CSHomeScreenViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate,
CSPhotoPreviewViewControllerDelegate, CSCameraViewControllerDelegate, CSPhotoEditorViewControllerDelegate> {
    
    MRoundedButton *cameraButton;
    MRoundedButton *photoLibraryButton;
}

@end

@implementation CSHomeScreenViewController

#pragma mark - View lifecycle

- (void)loadView {
    
    [super loadView];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.145f green:0.145f blue:0.145f alpha:1.0f];
    
    // Create the title
    UIImageView *logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Logo"]];
    
    UIColor *lightGray = [UIColor colorWithRed:0.98f green:0.98f blue:0.98f alpha:1.0f];
    UIColor *darkGray = [UIColor colorWithRed:0.10 green:0.10 blue:0.10 alpha:1.0];
    UIColor *lightBlue = [UIColor colorWithRed:0.36f green:0.67f blue:0.89f alpha:1.0f];
    UIColor *darkBlue = [UIColor colorWithRed:0.13 green:0.33 blue:0.49 alpha:1.0];
    UIColor *lightRed = [UIColor colorWithRed:0.98f green:0.32f blue:0.05f alpha:1.0f];
    UIColor *darkRed = [UIColor colorWithRed:0.56 green:0.16 blue:0.0 alpha:1.0];
    
    // Describe the appearence of our camera and photo library buttons
    NSDictionary *cameraAppearenceProxy = @{kMRoundedButtonCornerRadius : @FLT_MAX,
                                            kMRoundedButtonBorderWidth : @0,
                                            kMRoundedButtonContentColor : lightGray,
                                            kMRoundedButtonContentAnimateToColor : darkGray,
                                            kMRoundedButtonForegroundColor : lightBlue,
                                            kMRoundedButtonForegroundAnimateToColor : darkBlue};
    
    
    NSDictionary *photoLibraryAppearenceProxy = @{kMRoundedButtonCornerRadius : @FLT_MAX,
                                                  kMRoundedButtonBorderWidth : @0,
                                                  kMRoundedButtonContentColor : lightGray,
                                                  kMRoundedButtonContentAnimateToColor : darkGray,
                                                  kMRoundedButtonForegroundColor : lightRed,
                                                  kMRoundedButtonForegroundAnimateToColor : darkRed};
    
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
                                         constraintsWithVisualFormat:@"V:|-45-[logoView]-(<=65)-[cameraButton(==90)]-(>=50)-|"
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
    NSArray *buttonHorizontalConstraints = [NSLayoutConstraint
                                            constraintsWithVisualFormat:@"H:|-45-[cameraButton(==90)]-(>=15)-[photoLibraryButton(==90)]-45-|"
                                            options:0
                                            metrics:nil
                                            views:viewsDictionary];
    NSArray *photoLibraryVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[logoView]-(<=65)-[photoLibraryButton(==90)]-(>=50)-|" options:0 metrics:nil views:viewsDictionary];
    
    // Add all the constraints to the base view
    [self.view addConstraints:titleHorizontalConstraints];
    [self.view addConstraints:titleVerticalConstraints];
    [self.view addConstraints:buttonHorizontalConstraints];
    [self.view addConstraints:photoLibraryVerticalConstraints];
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
    CSPhotoPreviewViewController *pvc = [[CSPhotoPreviewViewController alloc] init];
    pvc.image = image;
    pvc.delegate = self;
    [picker presentViewController:pvc animated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - CSPhotoPreviewController delegate methods

- (void)photoPreviewCancelPreview:(CSPhotoPreviewViewController *)photoPreview {
    
    [photoPreview.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)photoPreview:(CSPhotoPreviewViewController *)photoPreview useImage:(UIImage *)image {
    
    [self dismissViewControllerAnimated:YES completion:^{
        [self openPhotoEditorWithImage:image];
    }];
}

#pragma mark - CSCameraViewController delegate methods

- (void)cameraViewController:(CSCameraViewController *)camera didCaptureImage:(UIImage *)image {
    
    [self dismissViewControllerAnimated:YES completion:^{
        [self openPhotoEditorWithImage:image];
    }];
}

#pragma mark - CSPhotoEditorViewController delegate methods

- (void)photoEditorViewControllerDidCancel:(CSPhotoEditorViewController *)photoEditor {
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Actions

- (IBAction)presentCamera:(id)sender {
    
    if (photoLibraryButton.isHighlighted) {
        return;
    }
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        CSCameraViewController *cvc = [[CSCameraViewController alloc] init];
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
    
    CSPhotoEditorViewController *evc = [[CSPhotoEditorViewController alloc] init];
    evc.image = image;
    evc.delegate = self;
    [self presentViewController:evc animated:YES completion:NULL];
}

@end
