//
//  CSCameraViewController.h
//  ColorSpill
//
//  Created by Cody Caldwell on 6/15/14.
//  Copyright (c) 2014 Cody Caldwell. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CSCameraViewController;

@protocol CSCameraViewControllerDelegate <NSObject>

@required
- (void)cameraViewController:(CSCameraViewController *)camera didCaptureImage:(UIImage *)image;

@end

@interface CSCameraViewController : UIViewController

@property (weak, nonatomic) id<CSCameraViewControllerDelegate> delegate;

@end
