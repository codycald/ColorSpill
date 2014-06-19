//
//  FLTPhotoPreviewViewController.h
//  FilterLab
//
//  Created by Cody Caldwell on 6/16/14.
//  Copyright (c) 2014 Cody Caldwell. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FLTPhotoPreviewViewController;

@protocol FLTPhotoPreviewViewControllerDelegate <NSObject>

@required
- (void)photoPreviewCancelPreview:(FLTPhotoPreviewViewController *)photoPreview;
- (void)photoPreview:(FLTPhotoPreviewViewController *)photoPreview useImage:(UIImage *)image;

@end

@interface FLTPhotoPreviewViewController : UIViewController

@property (strong, nonatomic) UIImage *image;
@property (weak, nonatomic) id<FLTPhotoPreviewViewControllerDelegate> delegate;

@end
