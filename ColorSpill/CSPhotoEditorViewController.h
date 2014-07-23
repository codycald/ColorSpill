//
//  CSPhotoEditorViewController.h
//  ColorSpill
//
//  Created by Cody Caldwell on 6/19/14.
//  Copyright (c) 2014 Cody Caldwell. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CSPhotoEditorViewController;

@protocol CSPhotoEditorViewControllerDelegate <NSObject>

@required
- (void)photoEditorViewControllerDidCancel:(CSPhotoEditorViewController *)photoEditor;

@end

@interface CSPhotoEditorViewController : UIViewController

@property (strong, nonatomic) UIImage *image;
@property (weak, nonatomic) id<CSPhotoEditorViewControllerDelegate> delegate;

@end
