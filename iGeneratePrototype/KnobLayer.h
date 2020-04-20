//
//  KnobLayer.h
//  iGeneratePrototype
//
//  Created by Darius Petermann on 10/21/15.
//  Copyright (c) 2015 com.DariusPetermann. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>

@class CustomSliderControl;
@interface KnobLayer : CALayer

@property BOOL highlighted;
@property (weak) CustomSliderControl* slider;

@end
