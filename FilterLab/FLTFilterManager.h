//
//  FLTFilterManager.h
//  FilterLab
//
//  Created by Cody Caldwell on 6/28/14.
//  Copyright (c) 2014 Cody Caldwell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FLTFilter.h"

@interface FLTFilterManager : NSObject

@property (copy, nonatomic, readonly) NSArray *generalFilters;
@property (copy, nonatomic, readonly) NSArray *toolFilters;

@end
