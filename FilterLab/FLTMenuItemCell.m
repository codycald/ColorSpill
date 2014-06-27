//
//  FLTMenuItemCell.m
//  FilterLab
//
//  Created by Cody Caldwell on 6/25/14.
//  Copyright (c) 2014 Cody Caldwell. All rights reserved.
//

#import "FLTMenuItemCell.h"

@implementation FLTMenuItemCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.imageView.image = nil;
}

@end
