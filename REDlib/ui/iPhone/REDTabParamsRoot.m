//
//  ParmyTabParams.m
//  Bumpy
//
//  Created by Tom Seago on 12/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "REDTabParamsRoot.h"

#import "REDlibInternal.h"
#import "REDRegistry.h"

#import "REDParamsNumberEditor.h"
#import "REDSliderView.h"
#import "REDWindow.h"

@interface REDTabParamsRoot()
-(void) processKeys;
@end

@implementation REDTabParamsRoot


-(id) init
{
    self = [super init];
    if (self)
    {
        self.title = @"Parameters";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:[REDlibInternal sharedInstance] action:@selector(hideControlWindow)];

        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];

        _tableView.delegate = self;
        _tableView.dataSource = self;
        self.view = _tableView;
        
        [self processKeys];
    }
    return self;
}


-(void) processKeys
{
    NSMutableArray* sections = [NSMutableArray array];
    
    // Add a generic "general" section at the beginning
    NSMutableArray* generalRows = [NSMutableArray array];
    [sections addObject:[NSDictionary dictionaryWithObjectsAndKeys:generalRows, @"rows", @"General", @"title", @"yes", @"isGeneral", nil]];

    NSString* currentTitle = nil;
    NSMutableArray* currentSectionRows = nil;
    
    for (NSString* key in [REDRegistry sharedInstance].allKeys)
    {
        NSLog(@"Processing key='%@'", key);
        
        if (currentTitle && [key hasPrefix:currentTitle])
        {
            // Add to current section
            NSString* suffix = [key substringFromIndex:currentTitle.length];
            
            [currentSectionRows addObject:suffix];
            NSLog(@"  to existing section '%@'", currentTitle);
        }
        else
        {
            // It is a new section

            // Split the key into a title portion on the first space followed
            // by the rest of the key
            NSArray* components = [key componentsSeparatedByString:@" "];
            if (components.count == 1)
            {
                // Add it to the "general" category
                [generalRows addObject:key];
                NSLog(@"  to general section");
            }
            else
            {
                // Make a new section for the first component
                // (importantly add a space to the end of it)
                currentTitle = [NSString stringWithFormat:@"%@ ", [components objectAtIndex:0]];
                currentSectionRows = [NSMutableArray array];
                
                [sections addObject:[NSDictionary dictionaryWithObjectsAndKeys:currentSectionRows, @"rows", currentTitle, @"title", nil]];

                NSString* suffix = [key substringFromIndex:currentTitle.length];                
                [currentSectionRows addObject:suffix];                
                NSLog(@"  to new section '%@'", currentTitle);
            }
        }
    }
    
    // Get rid of the general one if we don't need it
    if (generalRows.count == 0)
    {
        [sections removeObjectAtIndex:0];
    }
    
    _sections = sections;
}

-(void) viewWillAppear:(BOOL)animated
{
    [_tableView reloadData];
}

#pragma -
#pragma UITableView DataSource & Delegate

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        CGRect frame = cell.frame;
        frame.size.width -= 2 * 40;
        cell.frame = frame;
    }
    
    NSDictionary* section = [_sections objectAtIndex:indexPath.section];
    
    NSArray* rows = [section objectForKey:@"rows"];
    NSString* subKey = [rows objectAtIndex:indexPath.row];
    
    NSString* fullKey;
    if ([section objectForKey:@"isGeneral"])
    {
        fullKey = subKey;
    }
    else
    {
        fullKey = [NSString stringWithFormat:@"%@%@", [section objectForKey:@"title"], subKey];
    }
    NSObject* obj = [[REDRegistry sharedInstance] currentObjectForKey:fullKey];
                   
    cell.textLabel.text = subKey;
    cell.detailTextLabel.text = [obj description];
    
    return cell;
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return _sections.count;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIx
{
    NSDictionary* section = [_sections objectAtIndex:sectionIx];
    
    NSArray* rows = [section objectForKey:@"rows"];
    return rows.count;
}

-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)sectionIx
{
    NSDictionary* section = [_sections objectAtIndex:sectionIx];
    return [section objectForKey:@"title"];
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* section = [_sections objectAtIndex:indexPath.section];
    
    NSArray* rows = [section objectForKey:@"rows"];
    NSString* subKey = [rows objectAtIndex:indexPath.row];
    
    NSString* fullKey;
    if ([section objectForKey:@"isGeneral"])
    {
        fullKey = subKey;
    }
    else
    {
        fullKey = [NSString stringWithFormat:@"%@%@", [section objectForKey:@"title"], subKey];
    }
    NSObject* obj = [[REDRegistry sharedInstance] currentObjectForKey:fullKey];
    
    BOOL animated = NO;
    if ([obj isKindOfClass:[NSNumber class]])
    {
//        REDParamsNumberEditor* ctlr = [[REDParamsNumberEditor alloc] initForKey:fullKey withNumber:(NSNumber*)obj];
//        
//        [self.navigationController pushViewController:ctlr animated:YES];
        REDSliderView* slider = [[REDSliderView alloc] initForKey:fullKey withNumber:(NSNumber*)obj];
        [[REDWindow sharedInstance] showFloatingView:slider];
    }
    else
    {
        // For things we can't go to another screen for, animate the deselect
        animated = YES;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:animated];
}


@end
