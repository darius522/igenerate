//
//  SelectLfoDestinationViewController.m
//  iGeneratePrototype
//
//  Created by Darius Petermann on 10/7/15.
//  Copyright (c) 2015 com.DariusPetermann. All rights reserved.
//

//LFO DESTINATION DEFINITION
#define AMP     (0)
#define PITCH   (1)
#define FILTCUT (2)
#define PAN     (3)


#import "SelectLfoDestinationViewController.h"

@interface SelectLfoDestinationViewController ()

@end

@implementation SelectLfoDestinationViewController
@synthesize lfoDestDelegate, lfoDestinationNumber, lfoDestinationTableView;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma __UITableView Delegate Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section
{
    return nil;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = nil;
    
    static NSString *identifier = @"identifier";
    
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
        switch(indexPath.row){
            case 0: cell.textLabel.text = @"Amplitude"; break;
            case 1: cell.textLabel.text = @"Pitch"; break;
            case 2: cell.textLabel.text = @"Filter Cutoff"; break;
            case 3: cell.textLabel.text = @"Panning"; break;
        }
    [cell.contentView setBackgroundColor:[UIColor colorWithRed:139.0/255.0 green:166.0/255.0 blue:168.0/255.0 alpha:1.0]];
    
    cell.textLabel.font = [UIFont fontWithName:@"Greek" size:15];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        switch(indexPath.row){
            case 0: lfoDestinationNumber = [NSNumber numberWithInt:AMP]; break;
            case 1: lfoDestinationNumber = [NSNumber numberWithInt:PITCH]; break;
            case 2: lfoDestinationNumber = [NSNumber numberWithInt:FILTCUT]; break;
            case 3: lfoDestinationNumber = [NSNumber numberWithInt:PAN]; break;
        }
        [self.lfoDestDelegate getLfoDest:lfoDestinationNumber];
}

@end
