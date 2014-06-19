//
//  FLTCameraViewController.h
//  FilterLab
//
//  Created by Cody Caldwell on 6/15/14.
//  Copyright (c) 2014 Cody Caldwell. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FLTCameraViewController;

@protocol FLTCameraViewControllerDelegate <NSObject>

@required
- (void)cameraViewController:(FLTCameraViewController *)camera didCaptureImage:(UIImage *)image;

@end

@interface FLTCameraViewController : UIViewController

@property (weak, nonatomic) id<FLTCameraViewControllerDelegate> delegate;

@end
