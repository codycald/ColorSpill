//
//  FLTPhotoEditorViewController.h
//  FilterLab
//
//  Created by Cody Caldwell on 6/19/14.
//  Copyright (c) 2014 Cody Caldwell. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FLTPhotoEditorViewController;

@protocol FLTPhotoEditorViewControllerDelegate <NSObject>

@required
- (void)photoEditorViewControllerDidCancel:(FLTPhotoEditorViewController *)photoEditor;

@end

@interface FLTPhotoEditorViewController : UIViewController

@property (strong, nonatomic) UIImage *image;
@property (weak, nonatomic) id<FLTPhotoEditorViewControllerDelegate> delegate;

@end
