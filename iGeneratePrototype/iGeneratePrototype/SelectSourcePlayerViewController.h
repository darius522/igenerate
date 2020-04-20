//
//  SelectSourcePlayerViewController.h
//  iGeneratePrototype
//
//  Created by Darius Petermann on 11/25/15.
//  Copyright (c) 2015 com.DariusPetermann. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SelectFtablePlayerDelegate <NSObject>
-(void)getFtableNumber:(NSNumber*)theFtable;
@end
@interface SelectSourcePlayerViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITableView *ftablePlayerTableView;
@property (retain,nonatomic) NSNumber* ftableNumber;
@property (weak, nonatomic) id<SelectFtablePlayerDelegate>ftablePlayerDelegate;

@end
