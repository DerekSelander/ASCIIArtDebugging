//
//  DSTableViewController.m
//  ASCIIArtDebugging
//
//  Created by Derek Selander on 2/3/13.
//  Copyright (c) 2013 Derek Selander. All rights reserved.
//

#import "DSTableViewController.h"

@interface DSTableViewController ()

@end

@implementation DSTableViewController


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
#warning Stick a break point here, then in lldb console type 'po cell.imageView'
    
    //You can alter the ASCII to also enable/disable ASCIIArt through a NSLog; alter the ASCIIImageViewType;
    NSLog(@"%@", cell.imageView);
}


@end
