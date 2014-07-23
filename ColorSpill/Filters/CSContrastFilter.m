//
//  CSContrastFilter.m
//  ColorSpill
//
//  Created by Cody Caldwell on 7/4/14.
//  Copyright (c) 2014 Cody Caldwell. All rights reserved.
//

#import "CSContrastFilter.h"

@implementation CSContrastFilter

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        self.filterName = @"Contrast";
        self.imageName = @"contrast";
        self.type = CSToolFilterType;
        self.maximumFilterValue = 4.0;
        self.minimumFilterValue = 0.0;
        self.startingFilterValue = 1.0;
        self.gpuFilter = [[GPUImageContrastFilter alloc] init];
        self.intensity = 1.0;
    }
    return self;
}

- (void)setIntensity:(CGFloat)intensity {
    GPUImageContrastFilter *filter = (GPUImageContrastFilter *)self.gpuFilter;
    filter.contrast = intensity;
}

@end
