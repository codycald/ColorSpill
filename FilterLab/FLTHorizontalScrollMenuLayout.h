//
//  FLTHorizontalScrollMenuLayout.h
//  FilterLab
//
//  Created by Cody Caldwell on 6/26/14.
//  Copyright (c) 2014 Cody Caldwell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FLTHorizontalScrollMenuLayout : UICollectionViewLayout

@property (assign, nonatomic) UIEdgeInsets edgeInsets;
@property (assign, nonatomic) CGSize itemSize;
@property (assign, nonatomic) CGFloat interItemSpacingX;
@property (assign, nonatomic) CGFloat titleHeight;

@end
