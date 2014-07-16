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
    
    self.view.backgroundColor = [UIColor blackColor];
    
    // Create the title
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"Filter Lab";
    titleLabel.font = [UIFont fontWithName:@"DancingScriptOT" size:60];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    // Describe the appearence of our camera and photo library buttons
    NSDictionary *appearenceProxy = @{kMRoundedButtonCornerRadius : @FLT_MAX,
                                      kMRoundedButtonBorderWidth : @2,
                                      kMRoundedButtonBorderColor : [UIColor whiteColor],
                                      kMRoundedButtonBorderAnimationColor : [UIColor darkGrayColor],
                                      kMRoundedButtonContentColor : [UIColor whiteColor],
                                      kMRoundedButtonContentAnimationColor : [UIColor darkGrayColor],
                                      kMRoundedButtonForegroundColor : [UIColor darkGrayColor],
                                      kMRoundedButtonForegroundAnimationColor : [UIColor whiteColor]};
    
    [MRoundedButtonAppearanceManager registerAppearanceProxy:appearenceProxy forIdentifier:@"cameraButton"];
    [MRoundedButtonAppearanceManager registerAppearanceProxy:appearenceProxy forIdentifier:@"photoLibraryButton"];
    
    // Create the camera and photo library buttons
    cameraButton = [MRoundedButton buttonWithFrame:CGRectZero buttonStyle:MRoundedButtonCentralImage appearanceIdentifier:@"cameraButton"];
    photoLibraryButton = [MRoundedButton buttonWithFrame:CGRectZero buttonStyle:MRoundedButtonCentralImage appearanceIdentifier:@"photoLibraryButton"];
    
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
    [self.view addSubview:titleLabel];
    [self.view addSubview:cameraButton];
    [self.view addSubview:photoLibraryButton];
    
    // Configure the layout of our views
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    cameraButton.translatesAutoresizingMaskIntoConstraints = NO;
    photoLibraryButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    // Create the lookup dictionary for our views
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(titleLabel, cameraButton, photoLibraryButton);
    
    // Define the vertical layout constraints
    NSArray *titleVerticalConstraints = [NSLayoutConstraint
                                         constraintsWithVisualFormat:@"V:|-53-[titleLabel]-40-[cameraButton(==90)]-50-[photoLibraryButton(==90)]"
                                         options:0
                                         metrics:nil
                                         views:viewsDictionary];
    
    // Define the horizontal layout constraints involving the title
    NSArray *titleHorizontalConstraints = [NSLayoutConstraint
                                           constraintsWithVisualFormat:@"H:|-20-[titleLabel]-20-|"
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

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        cameraButton.enabled = NO;
    }
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
    
    FLTCameraViewController *cvc = [[FLTCameraViewController alloc] init];
    cvc.delegate = self;
    [self presentViewController:cvc animated:YES completion:NULL];
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
