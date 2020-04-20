//
//  LineSeparator.m
//  iGeneratePrototype
//
//  Created by Darius Petermann on 10/8/15.
//  Copyright (c) 2015 com.DariusPetermann. All rights reserved.
//

#import "LineSeparator.h"

@implementation LineSeparator



-(void)initStuff:(int)tagLine{
    
}

- (void)drawRect:(CGRect)rect {
    NSLog(@"called\n");
    //1.
    CGContextRef contextVertical = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(contextVertical, 4.0);
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    CGFloat components[] = {208.0/255.0,225.0/255.0,255.0/255.0,1.0};
    CGColorRef color = CGColorCreate(colorspace, components);
    CGContextSetStrokeColorWithColor(contextVertical, color);
    CGFloat dashArray[] = {20,4,6,4,6,4,6};
    //VERTICAL SEGMENTS
    CGContextSetLineDash(contextVertical, 0, dashArray, 8);
    
   
    CGContextMoveToPoint(contextVertical,0,1);
    CGContextAddLineToPoint(contextVertical,0,self.frame.size.height);
    CGContextDrawPath(contextVertical, kCGPathStroke);
}


@end
