//
//  GPUImageIntensityGrayscaleFilter.m
//  FilterLab
//
//  Created by Cody Caldwell on 7/13/14.
//  Copyright (c) 2014 Cody Caldwell. All rights reserved.
//

#import "GPUImageIntensityGrayscaleFilter.h"

/*
 This class is a slight modification of Brad Larson's GPUImageGrayscaleFilter class, giving
 one the ability to modify the intensity of the original effect by adjusting the new intensity property.
 The intensity can range from 0.0 to 1.0. A majority of the credit for this class' implementation
 goes to Brad Larson (github.com/BradLarson).
 */

@implementation GPUImageIntensityGrayscaleFilter

#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
NSString *const kGPUImageIntensityGrayscaleFragmentShaderString = SHADER_STRING
(
 precision highp float;
 
 varying vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 uniform lowp float intensity;
 
 const highp vec3 W = vec3(0.2125, 0.7154, 0.0721);
 
 void main()
 {
     lowp vec4 textureColor = texture2D(inputImageTexture, textureCoordinate);
     float luminance = dot(textureColor.rgb, W);
     
     gl_FragColor = mix(textureColor, vec4(vec3(luminance), textureColor.a), intensity);
 }
 );
#else
NSString *const kGPUImageIntensityGrayscaleFragmentShaderString = SHADER_STRING
(
 varying vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 uniform lowp float intensity;
 
 const vec3 W = vec3(0.2125, 0.7154, 0.0721);
 
 void main()
 {
     vec4 textureColor = texture2D(inputImageTexture, textureCoordinate);
     float luminance = dot(textureColor.rgb, W);
     
     gl_FragColor = mix(textureColor, vec4(vec3(luminance), textureColor.a), intensity);
 }
 );
#endif


- (void)renderToTextureWithVertices:(const GLfloat *)vertices textureCoordinates:(const GLfloat *)textureCoordinates;
{
    if (!currentlyReceivingMonochromeInput)
    {
        [super renderToTextureWithVertices:vertices textureCoordinates:textureCoordinates];
    }
}

- (BOOL)wantsMonochromeInput;
{
    return NO;
}

- (BOOL)providesMonochromeOutput;
{
    return NO;
}


#pragma mark -
#pragma mark Initialization and teardown

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kGPUImageIntensityGrayscaleFragmentShaderString]))
    {
		return nil;
    }
    
    intensityUniform = [filterProgram uniformIndex:@"intensity"];
    
    return self;
}

#pragma mark - Accessors

- (void)setIntensity:(CGFloat)intensity {
    _intensity = intensity;
    [self setFloat:_intensity forUniform:intensityUniform program:filterProgram];
}

@end
