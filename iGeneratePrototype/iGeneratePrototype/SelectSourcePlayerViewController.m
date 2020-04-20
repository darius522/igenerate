//
//  SelectSourcePlayerViewController.m
//  iGeneratePrototype
//
//  Created by Darius Petermann on 11/25/15.
//  Copyright (c) 2015 com.DariusPetermann. All rights reserved.
//

#import "SelectSourcePlayerViewController.h"

@interface SelectSourcePlayerViewController ()

@end

@implementation SelectSourcePlayerViewController
@synthesize ftableNumber, ftablePlayerDelegate, ftablePlayerTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
        case 0: cell.textLabel.text = @"Glass"; break;
        case 1: cell.textLabel.text = @"Piano"; break;
        case 2: cell.textLabel.text = @"Pulswidth"; break;
        case 3: cell.textLabel.text = @"FilterBank"; break;
    }
    [cell.contentView setBackgroundColor:[UIColor colorWithRed:139.0/255.0 green:166.0/255.0 blue:168.0/255.0 alpha:1.0]];
    
    cell.textLabel.font = [UIFont fontWithName:@"Greek" size:15];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch(indexPath.row){
        case 0: ftableNumber = [NSNumber numberWithInt:1]; break;
        case 1: ftableNumber = [NSNumber numberWithInt:2]; break;
        case 2: ftableNumber = [NSNumber numberWithInt:3]; break;
        case 3: ftableNumber = [NSNumber numberWithInt:4]; break;
    }
    [self.ftablePlayerDelegate getFtableNumber:ftableNumber];
}

@end
