//
//  DragValue.m
//  iGeneratePrototype
//
//  Created by Darius Petermann on 10/3/15.
//  Copyright (c) 2015 com.DariusPetermann. All rights reserved.
//

#define TEMPO (0)
#define LFOAMOUNT (1)
#define LFORATE (2)
#define TIME_SIGNATURE (3)
#define CUTOFF (4)
#define QUALITY (5)
#define OCT_RANGE_INSTR1 (7)
#define OCT_RANGE_INSTR2 (8)
#import "DragValue.h"

@interface DragValue()

@end

@implementation DragValue{
    CGPoint touchLocation;
    NSInteger yFactor;
    int latestValue;
}
@synthesize valueDelegate;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)even
{
    UITouch *touch = [touches anyObject];
    touchLocation = [touch locationInView:self.superview];
    int x = touchLocation.x;
    int y = touchLocation.y;
    //may have to fix that later on but didn't find any other way to get what uiview was being touched
    //TEMPO-VIEW IS BEING DETECTED
    if(x>80 && x <125 && y>147 && y<177){
        self.whatView = TEMPO;
    }else if(x>480 && x <535 && y>650 && y<680){
        self.whatView = LFOAMOUNT;
    }else if(x>604 && x <659 && y>722 && y<752){
        self.whatView = LFORATE;
    }else if(x >= 204 && x < 237 && y >= 145 && y < 175){
        self.whatView = TIME_SIGNATURE;
    }else if(x >= 63 && x < 147 && y >= 243 && y < 273){
        self.whatView = CUTOFF;
    }else if(x >= 63 && x < 118 && y >= 283 && y < 313){
        self.whatView = QUALITY;
    }else if(x >= 298 && x < 341 && y >= 662 && y < 692){
        self.whatView = OCT_RANGE_INSTR1;
    }else if(x >= 298 && x < 341 && y >= 718 && y < 748){
        self.whatView = OCT_RANGE_INSTR2;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    touchLocation = [touch locationInView:self];
    //range = 740 - 40
    yFactor = touchLocation.y;
    //pole moved to middle of DragView
    yFactor -= 20;
    yFactor *= (-1);
    latestValue = (int)yFactor;
    switch(self.whatView){
        case TEMPO:  [self.valueDelegate tempoChange:latestValue]; break;
        case LFOAMOUNT:[self.lfo1Delegate lfoAmountChange1:latestValue]; break;
        case LFORATE:  [self.lfo1Delegate lfoRateChange1:latestValue]; break;
        case TIME_SIGNATURE:  [self.timeSignatureDelegate timeSignatureChange:latestValue]; break;
        case CUTOFF:  [self.filterCutoffDelegate CutoffChange:latestValue]; break;
        case QUALITY:  [self.filterQualityDelegate QualityChange:latestValue]; break;
        case OCT_RANGE_INSTR1: [self.octaveRangeChange1Delegate OctRange1Change:latestValue];
        case OCT_RANGE_INSTR2: [self.octaveRangeChange2Delegate OctRange2Change:latestValue];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)even
{
    switch(self.whatView){
       case TEMPO: [self.valueDelegate tempoTouchEnded];
       case LFOAMOUNT: [self.lfo1Delegate lfoAmountEnded1];
       case LFORATE: [self.lfo1Delegate lfoRateEnded1];
       case TIME_SIGNATURE: [self.timeSignatureDelegate timeSignatureEnded]; break;
       case CUTOFF: [self.filterCutoffDelegate CutoffEnded]; break;
       case QUALITY: [self.filterQualityDelegate QualityEnded]; break;
       case OCT_RANGE_INSTR1: [self.octaveRangeChange1Delegate OctRange1Ended];
       case OCT_RANGE_INSTR2: [self.octaveRangeChange2Delegate OctRange2Ended];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
