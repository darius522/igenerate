//
//  SelectScaleViewController.m
//  iGeneratePrototype
//
//  Created by Darius Petermann on 10/1/15.
//  Copyright (c) 2015 com.DariusPetermann. All rights reserved.
//

#import "SelectScaleViewController.h"

@interface SelectScaleViewController ()

@end

@implementation SelectScaleViewController
@synthesize myScaleDelegate;

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
    if(section == 0){
    return 7;
    }else{
        return 6;
    }
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section
{
    NSString* title;
    if(section == 0){
        title = @"♯'s";
    }else {
        title = @"♭'s";
    }
    return title;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = nil;
    
    static NSString *identifier = @"identifier";
    
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    if(indexPath.section == 0){
    switch(indexPath.row){
        case 0: cell.textLabel.text = @"C"; cell.detailTextLabel.text = @"No ♯" ; break;
        case 1: cell.textLabel.text = @"G"; cell.detailTextLabel.text = @"One ♯" ; break;
        case 2: cell.textLabel.text = @"D"; cell.detailTextLabel.text = @"Two ♯" ; break;
        case 3: cell.textLabel.text = @"A"; cell.detailTextLabel.text = @"Three ♯" ; break;
        case 4: cell.textLabel.text = @"E"; cell.detailTextLabel.text = @"Four ♯" ; break;
        case 5: cell.textLabel.text = @"B"; cell.detailTextLabel.text = @"Five ♯" ; break;
        case 6: cell.textLabel.text = @"F♯"; cell.detailTextLabel.text = @"Six ♯" ; break;
       }
    }else{
    switch(indexPath.row){
        case 0: cell.textLabel.text = @"F"; cell.detailTextLabel.text = @"One ♭" ; break;
        case 1: cell.textLabel.text = @"B♭"; cell.detailTextLabel.text = @"Two ♭" ; break;
        case 2: cell.textLabel.text = @"E♭"; cell.detailTextLabel.text = @"Three ♭" ; break;
        case 3: cell.textLabel.text = @"A♭"; cell.detailTextLabel.text = @"Four ♭" ; break;
        case 4: cell.textLabel.text = @"D♭"; cell.detailTextLabel.text = @"Five ♭" ; break;
        case 5: cell.textLabel.text = @"G♭"; cell.detailTextLabel.text = @"Six ♭" ; break;
       }
    }
    [cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
    [cell.contentView setBackgroundColor:[UIColor grayColor]];
    
    cell.textLabel.font = [UIFont fontWithName:@"Greek" size:15];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* theCell = [tableView cellForRowAtIndexPath:indexPath];
    [self.myScaleDelegate selectedScale:theCell.textLabel.text];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
