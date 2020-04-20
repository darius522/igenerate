//
//  EnvelopeController.m
//  csSynthExplorer
//
//  Created by Darius Petermann on 8/5/15.
//  Copyright (c) 2015 Boulanger Lab. All rights reserved.
//

#import "EnvelopeController.h"
@interface EnvelopeController()

//Different points that the ADSR will use
@property (assign, nonatomic) CGPoint pStart; //0.0
@property (strong, nonatomic) UIButton* pAttack;
@property (assign, nonatomic) CGPoint ppDecay;
@property (strong, nonatomic) UIButton* pDecay;
@property (assign, nonatomic) CGPoint ppRelease;
@property (strong, nonatomic) UIButton* pRelease;
@property (assign, nonatomic) CGPoint pEnd; //0.0
@property (strong, nonatomic) UIView* adsrWindow;
@property (nonatomic) int thisButton;
@property (nonatomic) float sizeCoefficient;
@end

@implementation EnvelopeController
@synthesize sizeCoefficient;

UIPanGestureRecognizer *panRecognizerAttack;
UIPanGestureRecognizer *panRecognizerDecay;
UIPanGestureRecognizer *panRecognizerRelease;
//
//- (id)initWithCoder:(NSCoder *)aDecoder {
//    if ((self = [super initWithCoder:aDecoder])) {
//        [self baseClassInit];
//    }
//    return self;
//}
//
//- (void)baseClassInit {
//
//
//}

-(void)initStuff:(float)envelopeSize{
    sizeCoefficient = 1.5;
    //UIGESTURE INIT FOR THE THREE SEGMENTS
    panRecognizerAttack = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveEnvelope:)];
    [panRecognizerAttack setMinimumNumberOfTouches:1];
    [panRecognizerAttack setMaximumNumberOfTouches:1];
    panRecognizerDecay = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveEnvelope:)];
    [panRecognizerDecay setMinimumNumberOfTouches:1];
    [panRecognizerDecay setMaximumNumberOfTouches:1];
    panRecognizerRelease = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveEnvelope:)];
    [panRecognizerRelease setMinimumNumberOfTouches:1];
    [panRecognizerRelease setMaximumNumberOfTouches:1];
    
    
    
    //1. Attack: Create button, link action, link UIPANGESTURE
    _pAttack = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_pAttack setFrame:CGRectMake(50/sizeCoefficient, 50/sizeCoefficient, 18, 18)];
    [_pAttack setTitle:@"A" forState:UIControlStateNormal];
    [_pAttack setTitleColor: [UIColor redColor] forState: UIControlStateNormal];
    [_pAttack.titleLabel setFont:[UIFont fontWithName:@"Greek" size:8]];
    _pAttack.backgroundColor = [UIColor colorWithRed:176.0/255.0 green:224.0/255.0 blue:230.0/255.0 alpha:1];
    _pAttack.layer.cornerRadius = 9.0;
    _pAttack.tag = 0;
    [self addSubview:_pAttack];
    [_pAttack addGestureRecognizer:panRecognizerAttack];
    [_pAttack addTarget:self
                 action:@selector(buttonIsTouchedDOwn:)
       forControlEvents:UIControlEventTouchDown];
    
    //2. Decay: Create button, link action, link UIPANGESTURE
    _pDecay = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_pDecay setFrame:CGRectMake(150/sizeCoefficient, 100/sizeCoefficient, 18, 18)];
    [_pDecay setTitle:@"D" forState:UIControlStateNormal];
    [_pDecay setTitleColor: [UIColor redColor] forState: UIControlStateNormal];
    [_pDecay.titleLabel setFont:[UIFont fontWithName:@"Greek" size:8]];
    _pDecay.backgroundColor = [UIColor colorWithRed:176.0/255.0 green:224.0/255.0 blue:230.0/255.0 alpha:1];
    _pDecay.layer.cornerRadius = 9.0;
    _pDecay.tag = 1;
    [self addSubview:_pDecay];
    [_pDecay addGestureRecognizer:panRecognizerDecay];
    [_pDecay addTarget:self
                action:@selector(buttonIsTouchedDOwn:)
       forControlEvents:UIControlEventTouchDown];
    
    //3. Release: Create button, link action, link UIPANGESTURE
    _pRelease = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_pRelease setFrame:CGRectMake(300/sizeCoefficient, 100/sizeCoefficient, 18, 18)];
    [_pRelease setTitle:@"R" forState:UIControlStateNormal];
    [_pRelease setTitleColor: [UIColor redColor] forState: UIControlStateNormal];
    [_pRelease.titleLabel setFont:[UIFont fontWithName:@"Greek" size:8]];
    _pRelease.backgroundColor = [UIColor colorWithRed:176.0/255.0 green:224.0/255.0 blue:230.0/255.0 alpha:1];
    _pRelease.layer.cornerRadius = 9.0;
    _pRelease.tag = 2;
    [self addSubview:_pRelease];
    [_pRelease addGestureRecognizer:panRecognizerRelease];
    [self setNeedsDisplay];
    [_pRelease addTarget:self
                action:@selector(buttonIsTouchedDOwn:)
       forControlEvents:UIControlEventTouchDown];
    
    UIGraphicsBeginImageContext(self.frame.size);
    [[UIImage imageNamed:@"border_oscilloscope@2x.png"] drawInRect:self.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.backgroundColor = [UIColor colorWithPatternImage:image];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.ppAttack = [[touches anyObject] locationInView:self];
    [self setNeedsDisplay];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self setNeedsDisplay];
}

//METHOD THAT CONVERT UIKIT COORDINATE TO BEZIER COORDINATE
-(CGPoint)converterCoordinates:(CGPoint)point
{
    return CGPointMake(point.x, self.frame.size.height-point.y);
}


//____________________ATTACK____________________//

//METHOD THAT ALLOW USE TO MOVE THE ATTACK BUTTON OF THE ENVELOPE
-(void)moveEnvelope:(UIPanGestureRecognizer*)recognizer{
    CGPoint translation = [recognizer translationInView:self];
    // Figure out where the user is trying to drag the view.
    CGPoint newCenter = CGPointMake(recognizer.view.center.x + translation.x,
                                    recognizer.view.center.y + translation.y);
    
    // see if the new position is in bounds.
    if(newCenter.y <= self.frame.size.height && newCenter.y >= 0 && newCenter.x <= self.frame.size.width && newCenter.x >= 0) {
        if(recognizer == panRecognizerAttack){
            if(newCenter.x <= _ppDecay.x){
        recognizer.view.center = newCenter;
        [recognizer setTranslation:CGPointZero inView:self];
            }
        }else if(recognizer == panRecognizerDecay){
            if(newCenter.x >= _ppAttack.x && newCenter.x <= _ppRelease.x){
                recognizer.view.center = newCenter;
                [recognizer setTranslation:CGPointZero inView:self];
            }
        }else if(recognizer == panRecognizerRelease){
            if(newCenter.x >= _ppDecay.x){
                recognizer.view.center = newCenter;
                [recognizer setTranslation:CGPointZero inView:self];
            }
        }
    }
    [self setNeedsDisplay];

}

//KEEPING TRACK OF WHICH SEGMENT IS BEING MODIFIED
-(void)buttonIsTouchedDOwn:(UIButton*)sender{
    _thisButton = (int)sender.tag;
}

- (void)drawRect:(CGRect)rect {
    //MAKING SURE SUSTAIN LEVEL IS SAME AS RELEASE LEVEL
    if(_thisButton == 1){
        CGRect thisFrame = _pRelease.frame;
        thisFrame.origin.y = _pDecay.frame.origin.y;
        thisFrame.origin.x = _pRelease.frame.origin.x;
        _pRelease.frame = thisFrame;
    }else if(_thisButton == 2){
        CGRect thisFrame = _pDecay.frame;
        thisFrame.origin.y = _pRelease.frame.origin.y;
        thisFrame.origin.x = _pDecay.frame.origin.x;
        _pDecay.frame = thisFrame;
    }


    _pStart = CGPointMake(5,5);
    _ppAttack = [_pAttack.superview convertPoint:_pAttack.center toView:self];
    _ppDecay = [_pDecay.superview convertPoint:_pDecay.center toView:self];
    _ppRelease = [_pRelease.superview convertPoint:_pRelease.center toView:self];
    _pEnd = CGPointMake(395/sizeCoefficient, 5);
    //FOR ADSR SEGMENT
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2.0);
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    CGFloat components[] = {240.0/255.0,248.0/255.0,255.0/255.0,1.0};
    CGColorRef color = CGColorCreate(colorspace, components);
    CGContextSetStrokeColorWithColor(context, color);
    
    //FOR VERTICAL SEGMENT
    //1.
    CGContextRef contextVertical1 = UIGraphicsGetCurrentContext();
    CGContextRef contextVertical2 = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(contextVertical1, 2.0);
    CGContextSetLineWidth(contextVertical2, 2.0);
    CGContextSetStrokeColorWithColor(contextVertical1, color);
    CGContextSetStrokeColorWithColor(contextVertical2, color);
    CGFloat dashArray[] = {2,6,4,2};
    
    //ADSR SEGMENT
    CGContextMoveToPoint(context,[self converterCoordinates:_pStart].x,[self converterCoordinates:_pStart].y);
    CGContextAddLineToPoint(context,_ppAttack.x,_ppAttack.y);
    CGContextAddLineToPoint(context,_ppDecay.x,_ppDecay.y);
    CGContextAddLineToPoint(context,_ppRelease.x,_ppRelease.y);
    CGContextAddLineToPoint(context,[self converterCoordinates:_pEnd].x,[self converterCoordinates:_pEnd].y);
    CGContextDrawPath(context, kCGPathStroke);
    
    //VERTICAL SEGMENTS
    CGContextSetLineDash(contextVertical1, 0, dashArray, 1);
    CGContextSetLineDash(contextVertical2, 0, dashArray, 1);
    
    CGContextMoveToPoint(contextVertical1,_ppAttack.x,5);
    CGContextAddLineToPoint(contextVertical1,_ppAttack.x,self.frame.size.height-5);
    CGContextDrawPath(contextVertical1, kCGPathStroke);
    
    CGContextMoveToPoint(contextVertical2,_ppRelease.x,5);
    CGContextAddLineToPoint(contextVertical1,_ppRelease.x,self.frame.size.height-5);
    CGContextDrawPath(contextVertical1, kCGPathStroke);
    //PASSING THE VALUE TO MAINCONTROLLER
    //SENDING THE INFO THAT KEY IS BEIN PRESSED TO MAIN THREAD
    if(self.myEnvelopeDelegate){
        [self.myEnvelopeDelegate kAttackTime:(_ppAttack.x/120.0)];
        [self.myEnvelopeDelegate kAttackAmp:((self.frame.size.height - _ppAttack.y)/(200.0/1.5))];
        [self.myEnvelopeDelegate kDecayTime:((_ppDecay.x - _ppAttack.x)/(120.0/sizeCoefficient))];
        [self.myEnvelopeDelegate kDecayAmp:((self.frame.size.height - _ppDecay.y)/(200.0/sizeCoefficient))];
        [self.myEnvelopeDelegate kSustainAmp:((self.frame.size.height - _ppRelease.y)/(200.0/sizeCoefficient))];
        [self.myEnvelopeDelegate kReleaseTime:((self.frame.size.width)-_ppRelease.x)/(120.0/sizeCoefficient)];
    }
}

@end
