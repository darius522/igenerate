//
//  XYPadView.m
//  iGeneratePrototype
//
//  Created by Darius Petermann on 10/4/15.
//  Copyright (c) 2015 com.DariusPetermann. All rights reserved.
//

#import "XYPadView.h"
@interface XYPadView()
@property(strong, nonatomic)UIImageView *pLocater;
@end
@implementation XYPadView
@synthesize myPadDelegate, beatTracker;
-(void)initStuff{
    
    _pLocater = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"toggle_grid.png"]];
    [self.pLocater setFrame:CGRectMake(0, 0, 36, 36)];
    _pLocater.layer.cornerRadius = 0.0;
    _pLocater.layer.opacity = 0.5;
    _pLocater.tag = 0;
    [self addSubview:_pLocater];
    beatTracker = [[UILabel alloc]initWithFrame:CGRectMake(5, 2, 36, 36)];
    beatTracker.text = @"1/4";
    beatTracker.font = [UIFont fontWithName:@"Greek" size:19];
    [self addSubview:self.beatTracker];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint tappedPt = [[touches anyObject] locationInView: self];
    [self.myPadDelegate updateLocaterPosition:tappedPt.x and:tappedPt.y];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint tappedPt = [[touches anyObject] locationInView: self];
[self.myPadDelegate updateLocaterPosition:tappedPt.x and:tappedPt.y];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
}


-(void)truncateLocaterPosition:(int)xCoordinate and:(int)yCoordinate{
    CGRect frame = CGRectMake(xCoordinate, yCoordinate, 36, 36);
    CGRect frame2 = CGRectMake(xCoordinate+5, yCoordinate+2, 36, 36);
    self.pLocater.frame = frame;
    self.beatTracker.frame = frame2;
    
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect{
    int i = 0;
    int xIncrement = 36, yIncrement = 36;
    //FOR VERTICAL SEGMENT
    //1.
    CGContextRef contextVertical = UIGraphicsGetCurrentContext();
    CGContextRef contextHorizontal = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(contextVertical, 2.0);
    CGContextSetLineWidth(contextHorizontal, 2.0);
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    CGFloat components[] = {139/255.0,166/255.0,168/255.0,1.0};
    CGColorRef color = CGColorCreate(colorspace, components);
    CGContextSetStrokeColorWithColor(contextVertical, color);
    CGContextSetStrokeColorWithColor(contextHorizontal, color);
    CGFloat dashArray[] = {2,6,4,2};
    //SET LINE DASH
    CGContextSetLineDash(contextVertical, 0, dashArray, 1);
    CGContextSetLineDash(contextHorizontal, 0, dashArray, 1);
    
    //VERTICAL LINES MATRIX
    for(i = 0; i < 7; i++){
    CGContextMoveToPoint(contextVertical,xIncrement,5);
    CGContextAddLineToPoint(contextVertical,xIncrement,self.frame.size.height-5);
    CGContextDrawPath(contextVertical, kCGPathStroke);
        xIncrement += 36;
    }
    i = 0;
    //HORIZONTAL LINES MATRIX
    for(i = 0; i < 7; i++){
        CGContextMoveToPoint(contextHorizontal,5,yIncrement);
        CGContextAddLineToPoint(contextHorizontal,self.frame.size.width-5,yIncrement);
        CGContextDrawPath(contextHorizontal, kCGPathStroke);
        yIncrement += 36;
    }
}


@end
