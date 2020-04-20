//
//  KeyboardController.m
//  csSynthExplorer
//
//  Created by Darius Petermann on 8/9/15.
//  Copyright (c) 2015 Boulanger Lab. All rights reserved.
//

#import "KeyboardController.h"

@implementation KeyboardController
@synthesize myKeyboardDelegate;
- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self baseClassInit];
    }
    return self;
}

- (void)baseClassInit {
    
    
}
-(void)initStuff{
    int i;
    int j = 0;
    for(i = 0; i < 24; i++){
        UIButton *keys   =   [UIButton buttonWithType:UIButtonTypeRoundedRect];
        if(i == 0 || i == 5 || i == 12 || i == 17){
        keys.frame       =   CGRectMake(j*50.2,0,50.2,168);
        [keys setBackgroundImage:[UIImage imageNamed:@"c-f.png"] forState:UIControlStateNormal];
            [keys sendSubviewToBack:self];
            j++;
        }else if(i == 2 || i == 7 || i == 9 || i == 14 || i == 19 || i == 21){
            keys.frame       =   CGRectMake(j*50.2,0,50.2,168);
            [keys setBackgroundImage:[UIImage imageNamed:@"d-g-a.png"] forState:UIControlStateNormal];
            [keys sendSubviewToBack:self];
            j++;
        }else if(i == 4 || i == 11 || i == 16 || i == 23){
            keys.frame       =   CGRectMake(j*50.2,0,50.2,168);
            [keys setBackgroundImage:[UIImage imageNamed:@"b-e.png"] forState:UIControlStateNormal];
            [keys sendSubviewToBack:self];
            j++;
        }else{
            keys.frame       =   CGRectMake((j*50.2)-21,0,38,95);
            [keys setBackgroundImage:[UIImage imageNamed:@"black_key.png"] forState:UIControlStateNormal];
            [keys bringSubviewToFront:self];
        }
        //TO DO: ADD HIGHLIGHTED KEY IMAGE FOR PRESSED KEY
//        [whitekeys setBackgroundImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateHighlighted];
        keys.tag = i;
        [keys addTarget:self action:@selector(keyPressed:) forControlEvents:UIControlEventTouchDown];
        [keys addTarget:self action:@selector(keyReleased) forControlEvents:UIControlEventTouchUpInside];
        keys.showsTouchWhenHighlighted = YES;
        [self addSubview:keys];
    }
}

-(void)keyPressed:(UIButton*)sender{
    //SENDING THE INFO THAT KEY IS BEIN PRESSED TO MAIN THREAD
    if(self.myKeyboardDelegate && [self.myKeyboardDelegate respondsToSelector:@selector(keyPressed:)]) {
        [self.myKeyboardDelegate keyPressed:(int)sender.tag];
    }
}
-(void)keyReleased{
    if(self.myKeyboardDelegate && [self.myKeyboardDelegate respondsToSelector:@selector(keyPressed:)]) {
        [self.myKeyboardDelegate keyReleased];
    }
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}


@end
