//
//  FLTHomeScreenViewController.m
//  FilterLab
//
//  Created by Cody Caldwell on 6/13/14.
//  Copyright (c) 2014 Cody Caldwell. All rights reserved.
//

#import "FLTHomeScreenViewController.h"

@interface FLTHomeScreenViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@end

@implementation FLTHomeScreenViewController

#pragma mark - Actions

- (IBAction)presentPhotoLibary:(id)sender {
    
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    // Let the user choose which album they want to use
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    ipc.delegate = self;
    [self presentViewController:ipc animated:YES completion:NULL];
}

@end
