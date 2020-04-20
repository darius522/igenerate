//
//  SelectMode.h
//  iGeneratePrototype
//
//  Created by Darius Petermann on 10/3/15.
//  Copyright (c) 2015 com.DariusPetermann. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol mySelectModeDelegate <NSObject>
-(void)selectedMode:(NSString*)theMode;
@end

@interface SelectMode : UIViewController
<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, weak) id<mySelectModeDelegate>myModeDelegate;

@end
