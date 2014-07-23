//
//  CSShadowsFilter.m
//  ColorSpill
//
//  Created by Cody Caldwell on 7/7/14.
//  Copyright (c) 2014 Cody Caldwell. All rights reserved.
//

#import "CSShadowsFilter.h"

@implementation CSShadowsFilter

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        self.filterName = @"Lighten Shadows";
        self.imageName = @"shadows";
        self.type = CSToolFilterType;
        self.maximumFilterValue = 1.0;
        self.minimumFilterValue = 0.0;
        self.startingFilterValue = 0.0;
        self.gpuFilter = [[GPUImageHighlightShadowFilter alloc] init];
        self.intensity = 0.0;
    }
    return self;
}

- (void)setIntensity:(CGFloat)intensity {
    GPUImageHighlightShadowFilter *filter = (GPUImageHighlightShadowFilter *)self.gpuFilter;
    filter.shadows = intensity;
}

@end
