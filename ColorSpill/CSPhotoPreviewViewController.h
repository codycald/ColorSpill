//
//  CSPhotoPreviewViewController.h
//  ColorSpill
//
//  Created by Cody Caldwell on 6/16/14.
//  Copyright (c) 2014 Cody Caldwell. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CSPhotoPreviewViewController;

@protocol CSPhotoPreviewViewControllerDelegate <NSObject>

@required
- (void)photoPreviewCancelPreview:(CSPhotoPreviewViewController *)photoPreview;
- (void)photoPreview:(CSPhotoPreviewViewController *)photoPreview useImage:(UIImage *)image;

@end

@interface CSPhotoPreviewViewController : UIViewController

@property (strong, nonatomic) UIImage *image;
@property (weak, nonatomic) id<CSPhotoPreviewViewControllerDelegate> delegate;

@end
