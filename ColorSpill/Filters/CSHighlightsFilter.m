//
//  CSHighlightsFIlter.m
//  ColorSpill
//
//  Created by Cody Caldwell on 7/7/14.
//  Copyright (c) 2014 Cody Caldwell. All rights reserved.
//

#import "CSHighlightsFilter.h"

@implementation CSHighlightsFilter

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        self.filterName = @"Darken Highlights";
        self.imageName = @"highlights";
        self.type = CSToolFilterType;
        self.maximumFilterValue = 1.0;
        self.minimumFilterValue = 0.0;
        self.startingFilterValue = 1.0;
        self.gpuFilter = [[GPUImageHighlightShadowFilter alloc] init];
        self.intensity = 1.0;
    }
    return self;
}

- (void)setIntensity:(CGFloat)intensity {
    GPUImageHighlightShadowFilter *filter = (GPUImageHighlightShadowFilter *)self.gpuFilter;
    filter.highlights = intensity;
}

@end
