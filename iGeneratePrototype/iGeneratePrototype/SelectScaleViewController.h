//
//  SelectScaleViewController.h
//  iGeneratePrototype
//
//  Created by Darius Petermann on 10/1/15.
//  Copyright (c) 2015 com.DariusPetermann. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol mySelectScaleDelegate <NSObject>
-(void)selectedScale:(NSString*)theScale;
@end
@interface SelectScaleViewController : UIViewController
<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, weak) id<mySelectScaleDelegate>myScaleDelegate;
@property (strong, nonatomic) IBOutlet UITableView *tableViewScale;
@end
