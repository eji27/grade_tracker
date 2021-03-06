//
//  ClassTableViewController.m
//  Grade_Tracker
//
//  Created by Yian Cheng on 7/8/14.
//  Copyright (c) 2014 EAAA. All rights reserved.
//

#import "ClassTableViewController.h"
#import "ClassItem.h"
#import "ClassItemStore.h"
#import "NewClassController.h"
#import "ClassDetailViewController.h"
#import "CategoryItem.h"

@implementation ClassTableViewController

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[ClassItemStore sharedStore] allClasses] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    
    NSArray *classes = [[ClassItemStore sharedStore] allClasses];
    ClassItem *class = classes[indexPath.row];
    cell.textLabel.text = class.className;
    
    return cell;
}

- (IBAction)toggleEditingMode:(id)sender
{
    if (self.isEditing) {
        [sender setTitle:@"Edit" forState:UIControlStateNormal];
        [self setEditing:NO animated:YES];
    } else {
        [sender setTitle:@"Done" forState:UIControlStateNormal];
        [self setEditing:YES animated:YES];
    }
}

- (void)addNewClass
{

    ClassItem *class = [[ClassItemStore sharedStore] createClass:nil];
    NSInteger lastRow = [[[ClassItemStore sharedStore] allClasses] indexOfObject:class];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lastRow inSection:0];
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSArray *classes = [[ClassItemStore sharedStore] allClasses];
        ClassItem *class = classes[indexPath.row];
        [[ClassItemStore sharedStore] removeClass:class];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [[ClassItemStore sharedStore] moveItemAtIndex:sourceIndexPath.row toIndex:destinationIndexPath.row];
}


- (IBAction)dismiss:(UIStoryboardSegue *)segue
{

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ClassDetailViewController *dvc = [[ClassDetailViewController alloc] init];
    dvc.classItem = [[[ClassItemStore sharedStore] allClasses] objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:dvc animated:YES];
}

@end
