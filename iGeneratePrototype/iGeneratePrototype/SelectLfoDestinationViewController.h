//
//  SelectLfoDestinationViewController.h
//  iGeneratePrototype
//
//  Created by Darius Petermann on 10/7/15.
//  Copyright (c) 2015 com.DariusPetermann. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SelectLfoDestInstrumentDelegate <NSObject>
-(void)getLfoDest:(NSNumber*)theDest;
@end
@interface SelectLfoDestinationViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITableView *lfoDestinationTableView;
@property (retain,nonatomic) NSNumber* lfoDestinationNumber;
@property (weak, nonatomic) id<SelectLfoDestInstrumentDelegate>lfoDestDelegate;
@end
