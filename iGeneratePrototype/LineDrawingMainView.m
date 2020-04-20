//
//  LineDrawingMainView.m
//  iGeneratePrototype
//
//  Created by Darius Petermann on 10/24/15.
//  Copyright (c) 2015 com.DariusPetermann. All rights reserved.
//

#import "LineDrawingMainView.h"

@implementation LineDrawingMainView


- (void)drawRect:(CGRect)rect {
    CGContextRef contextVertical = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(contextVertical, 1.5);
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    CGFloat components[] = {0/255.0,0/255.0, 0/255.0,1.0};
    CGColorRef color = CGColorCreate(colorspace, components);
    CGContextSetStrokeColorWithColor(contextVertical, color);

    //SEPARATOR MIDI MONITORING
    //1.
    CGContextMoveToPoint(contextVertical,3, 2);
    CGContextAddLineToPoint(contextVertical, (self.frame.size.width/2)-3, 2);
    CGContextDrawPath(contextVertical, kCGPathStroke);
    //2.
    CGContextMoveToPoint(contextVertical,((self.frame.size.width/2)-3), 2);
    CGContextAddLineToPoint(contextVertical,self.frame.size.width-3 , 2);
    CGContextDrawPath(contextVertical, kCGPathStroke);
    //3.
    CGContextMoveToPoint(contextVertical,(self.frame.size.width/2)-3, 5);
    CGContextAddLineToPoint(contextVertical, (self.frame.size.width/2)-3, self.frame.size.height);
    CGContextDrawPath(contextVertical, kCGPathStroke);
}

@end
