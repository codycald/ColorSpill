//
//  FLTMenuItemTitleView.m
//  FilterLab
//
//  Created by Cody Caldwell on 6/26/14.
//  Copyright (c) 2014 Cody Caldwell. All rights reserved.
//

#import "FLTMenuItemTitleView.h"

@interface FLTMenuItemTitleView ()

@property (strong, nonatomic) UILabel *label;

@end

@implementation FLTMenuItemTitleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.label = [[UILabel alloc] initWithFrame:self.bounds];
        self.label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.label.backgroundColor = [UIColor clearColor];
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.font = [UIFont fontWithName:@"Palatino" size:11];
        self.label.textColor = [UIColor whiteColor];
        
        [self addSubview:self.label];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.label.text = nil;
}

@end
