//
//  FLTFilterManager.m
//  FilterLab
//
//  Created by Cody Caldwell on 6/28/14.
//  Copyright (c) 2014 Cody Caldwell. All rights reserved.
//

#import "FLTFilterManager.h"
#import "FLTFilter.h"
#import "FLTImageEffectType.h"

@interface FLTFilterManager ()

@property (copy, nonatomic) NSArray *filterNames;
@property (copy, nonatomic, readwrite) NSMutableArray *mutableGeneralFilters;
@property (copy, nonatomic, readwrite) NSMutableArray *mutableToolFilters;

@end


@implementation FLTFilterManager

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        self.filterNames = @[@"FLTSharpnessFilter", @"FLTBrightnessFilter", @"FLTContrastFilter",
                             @"FLTSaturationFilter", @"FLTExposureFilter", @"FLTBlackVignetteFilter",
                             @"FLTWhiteVignetteFilter", @"FLTTemperatureFilter", @"FLTHighlightsFilter",
                             @"FLTShadowsFilter", @"FLTLucidityFilter", @"FLTReverieFilter",
                             @"FLTUtopiaFilter", @"FLTVeniceFilter", @"FLTFinesseFilter",
                             @"FLTSonataFilter", @"FLTBlissFilter", @"FLTArcadiaFilter",
                             @"FLTEssenceFilter", @"FLTTimberFilter", @"FLTTimelessFilter",
                             @"FLTLithiumFilter", @"FLTNimbusFilter", @"FLTWidowFilter",
                             @"FLTCobaltFilter"];
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
        FLTFilter *filter = [[filterClass alloc] init];
        
        if (filter.type == FLTGeneralFilterType) {
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
