//
//  XYPadView.h
//  iGeneratePrototype
//
//  Created by Darius Petermann on 10/4/15.
//  Copyright (c) 2015 com.DariusPetermann. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol myXYPadDelegate <NSObject>
-(void)updateLocaterPosition:(int)xCoordinate and: (int)yCoordinate;
@end

@interface XYPadView : UIView
@property(nonatomic, weak) id<myXYPadDelegate>myPadDelegate;
-(void)initStuff;
-(void)truncateLocaterPosition:(int)xCoordinate and: (int)yCoordinate;
@property(strong, nonatomic)UILabel *beatTracker;
@end
