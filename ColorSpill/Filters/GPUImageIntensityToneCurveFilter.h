//
//  GPUImageIntensityToneCurveFilter.h
//  ColorSpill
//
//  Created by Cody Caldwell on 7/4/14.
//  Copyright (c) 2014 Cody Caldwell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPUImage.h"

/*
    This class is a slight modification of Brad Larson's GPUImageToneCurveFilter class, giving
    one the ability to modify the intensity of the original effect by adjusting the new intensity property.
    The intensity can range from 0.0 to 1.0. A majority of the credit for this class' implementation 
    goes to Brad Larson (github.com/BradLarson).
 */

@interface GPUImageIntensityToneCurveFilter : GPUImageFilter {
    GLuint intensityUniform;
}

@property (assign, nonatomic) CGFloat intensity;
@property(readwrite, nonatomic, copy) NSArray *redControlPoints;
@property(readwrite, nonatomic, copy) NSArray *greenControlPoints;
@property(readwrite, nonatomic, copy) NSArray *blueControlPoints;
@property(readwrite, nonatomic, copy) NSArray *rgbCompositeControlPoints;

// Initialization and teardown
- (id)initWithACVData:(NSData*)data;

- (id)initWithACV:(NSString*)curveFilename;
- (id)initWithACVURL:(NSURL*)curveFileURL;

// This lets you set all three red, green, and blue tone curves at once.
// NOTE: Deprecated this function because this effect can be accomplished
// using the rgbComposite channel rather then setting all 3 R, G, and B channels.
- (void)setRGBControlPoints:(NSArray *)points DEPRECATED_ATTRIBUTE;

- (void)setPointsWithACV:(NSString*)curveFilename;
- (void)setPointsWithACVURL:(NSURL*)curveFileURL;

// Curve calculation
- (NSMutableArray *)getPreparedSplineCurve:(NSArray *)points;
- (NSMutableArray *)splineCurve:(NSArray *)points;
- (NSMutableArray *)secondDerivative:(NSArray *)cgPoints;
- (void)updateToneCurveTexture;

@end
