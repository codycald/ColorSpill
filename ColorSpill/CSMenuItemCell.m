//
//  CSMenuItemCell.m
//  ColorSpill
//
//  Created by Cody Caldwell on 6/25/14.
//  Copyright (c) 2014 Cody Caldwell. All rights reserved.
//

#import "CSMenuItemCell.h"

@implementation CSMenuItemCell

#pragma mark - Initializers

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

#pragma mark - Overrides

- (void)prepareForReuse {
    [super prepareForReuse];
    self.imageView.image = nil;
}

@end
