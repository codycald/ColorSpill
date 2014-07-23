//
//  CSFilterManager.m
//  ColorSpill
//
//  Created by Cody Caldwell on 6/28/14.
//  Copyright (c) 2014 Cody Caldwell. All rights reserved.
//

#import "CSFilterManager.h"
#import "CSFilter.h"
#import "CSImageEffectType.h"

@interface CSFilterManager ()

@property (copy, nonatomic) NSArray *filterNames;
@property (copy, nonatomic, readwrite) NSMutableArray *mutableGeneralFilters;
@property (copy, nonatomic, readwrite) NSMutableArray *mutableToolFilters;

@end


@implementation CSFilterManager

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        self.filterNames = @[@"CSSharpnessFilter", @"CSBrightnessFilter", @"CSContrastFilter",
                             @"CSSaturationFilter", @"CSExposureFilter", @"CSBlackVignetteFilter",
                             @"CSWhiteVignetteFilter", @"CSTemperatureFilter", @"CSHighlightsFilter",
                             @"CSShadowsFilter", @"CSLucidityFilter", @"CSReverieFilter",
                             @"CSUtopiaFilter", @"CSVeniceFilter", @"CSFinesseFilter",
                             @"CSSonataFilter", @"CSBlissFilter", @"CSArcadiaFilter",
                             @"CSEssenceFilter", @"CSTimberFilter", @"CSTimelessFilter",
                             @"CSLithiumFilter", @"CSNimbusFilter", @"CSWidowFilter",
                             @"CSCobaltFilter"];
        [self createFilters];
    }
    return self;
}

#pragma mark - Helper methods

- (void)createFilters {

    _mutableGeneralFilters = [NSMutableArray array];
    _mutableToolFilters = [NSMutableArray array];
    
    for (NSString *filterName in self.filterNames) {
        
        Class filterClass = NSClassFromString(filterName);
        CSFilter *filter = [[filterClass alloc] init];
        
        if (filter.type == CSGeneralFilterType) {
            [_mutableGeneralFilters addObject:filter];
        } else {
            [_mutableToolFilters addObject:filter];
        }
    }
}

#pragma mark - Accessors

- (NSArray *)generalFilters {
    return [NSArray arrayWithArray:self.mutableGeneralFilters];
}

- (NSArray *)toolFilters {
    return [NSArray arrayWithArray:self.mutableToolFilters];
}

@end
