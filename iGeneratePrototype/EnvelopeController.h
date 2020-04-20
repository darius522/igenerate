//
//  EnvelopeController.h
//  csSynthExplorer
//
//  Created by Darius Petermann on 8/5/15.
//  Copyright (c) 2015 Boulanger Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@protocol EnvelopeDelegate <NSObject>
-(void)kAttackTime:(float)theTime;
-(void)kAttackAmp:(float)theAmp;
-(void)kDecayTime:(float)theTime;
-(void)kDecayAmp:(float)theAmp;
-(void)kSustainAmp:(float)theAmp;
-(void)kReleaseTime:(float)theTime;
@end

@interface EnvelopeController : UIView

@property (assign, nonatomic) CGPoint ppAttack; //0.0
-(void)moveEnvelope:(UIPanGestureRecognizer*)recognizer;
-(void)initStuff:(float)envelopeSize;


@property (readwrite, weak) id<EnvelopeDelegate
> myEnvelopeDelegate;

@end
