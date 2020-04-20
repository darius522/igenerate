//
//  KeyboardController.h
//  csSynthExplorer
//
//  Created by Darius Petermann on 8/9/15.
//  Copyright (c) 2015 Boulanger Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol KeyboardControllerDelegate <NSObject>
-(void)keyPressed:(int)keyNumber;
-(void)keyReleased;
@end
#import "MasterViewController.h"
@interface KeyboardController : UIView
-(void)initStuff;

@property (readwrite, weak) id<KeyboardControllerDelegate> myKeyboardDelegate;
@end
