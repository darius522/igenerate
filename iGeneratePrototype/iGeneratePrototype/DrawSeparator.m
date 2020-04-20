//
//  DrawSeparator.m
//  iGeneratePrototype
//
//  Created by Darius Petermann on 10/12/15.
//  Copyright (c) 2015 com.DariusPetermann. All rights reserved.
//

#import "DrawSeparator.h"

@implementation DrawSeparator

- (void)drawRect:(CGRect)rect {
    CGContextRef contextVertical = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(contextVertical, 4.0);
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    CGFloat components[] = {51/255.0,255/255.0,204/255.0,1.0};
    CGColorRef color = CGColorCreate(colorspace, components);
    CGContextSetStrokeColorWithColor(contextVertical, color);
//    CGFloat dashArray[] = {2,6,12,6};
    //VERTICAL SEGMENTS
//    CGContextSetLineDash(contextVertical, 0, dashArray, 1);
    
    CGContextMoveToPoint(contextVertical,167,0);
    CGContextAddLineToPoint(contextVertical,167,self.frame.size.height-5);
    CGContextDrawPath(contextVertical, kCGPathStroke);
//    CGFloat dashArray2[] = {2,6,12,6};

//    CGContextSetLineDash(contextVertical, 0, dashArray, 1);
    CGContextMoveToPoint(contextVertical,0,148);
    CGContextAddLineToPoint(contextVertical,346,148);
    CGContextDrawPath(contextVertical, kCGPathStroke);
    
    CGContextMoveToPoint(contextVertical,0,197);
    CGContextAddLineToPoint(contextVertical,346,197);
    CGContextDrawPath(contextVertical, kCGPathStroke);

}


@end
