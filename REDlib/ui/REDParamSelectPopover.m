//
//  ParmyParamSelectPopover.m
//  NoNameLib
//
//  Created by Tom Seago on 7/17/11.
//  Copyright 2011 Reality Box Labs LLC. All rights reserved.
//

#import "REDParamSelectPopover.h"

#import "REDRegistry.h"

@implementation REDParamSelectPopover

@synthesize paramKeys = _paramKeys;
@synthesize tableView = _tableView;
@synthesize selectDelegate = _selectDelegate;

-(id) initOnView:(UIView*)parent
{    
    self = [super initOnView:parent];
    if (self) 
	{
		self.view = [[UIView alloc] initWithFrame:CGRectMake(0,0,100,100)] ;
		self.view.backgroundColor = [UIColor clearColor];
		
		// Initialize our data from the registry
		self.paramKeys = [[[REDRegistry sharedInstance] 
						   allKeys] 
						   sortedArrayUsingComparator: ^(NSString* obj1, NSString* obj2) {							   
							   return [obj1 compare:obj2];
						   }];
		
		// Setup our actual table view
		self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,100,100)] ;
		_tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		_tableView.dataSource = self;
		_tableView.delegate = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorColor = [UIColor colorWithWhite:0.0f alpha:0.3f];
        
		[self.view addSubview:_tableView];
    }
    return self;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

-(void)dealloc 
{
	self.paramKeys = nil;
	self.tableView.dataSource = nil;
	self.tableView.delegate = nil;
	self.tableView = nil;
}


#pragma mark -
#pragma mark UITableViewDataSource

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
	
	if (!cell) 
	{
		// Make one
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
	}
	
	NSString* key = [_paramKeys objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor colorWithWhite:1.0f alpha:0.8];
    cell.detailTextLabel.textColor = [UIColor colorWithWhite:1.0f alpha:1.0f];
	cell.textLabel.text = key;
	cell.detailTextLabel.text = [[REDRegistry sharedInstance] stringForKey:key withDefault:@""];
	
	return cell;
}


-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [_paramKeys count];
}


//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;    // fixed font style. use custom view (UILabel) if you want something different
//- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section;

// Editing

// Individual rows can opt out of having the -editing property set for them. If not implemented, all rows are assumed to be editable.
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath;

// Moving/reordering

// Allows the reorder accessory view to optionally be shown for a particular row. By default, the reorder control will be shown only if the datasource implements -tableView:moveRowAtIndexPath:toIndexPath:
//- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath;

// Index

//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView;                                                    // return list of section titles to display in section index view (e.g. "ABCD...Z#")
//- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index;  // tell table which section corresponds to section title/index (e.g. "B",1))

// Data manipulation - insert and delete support

// After a row has the minus or plus button invoked (based on the UITableViewCellEditingStyle for the cell), the dataSource must commit the change
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;

// Data manipulation - reorder / moving support

//- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath;

#pragma mark -
#pragma mark UITablewViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	// Lovely ...
	NSLog(@"didSelectRow");

	[_selectDelegate selectedParamKey:[_paramKeys objectAtIndex:indexPath.row]];
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	[self hidePopover];
}

@end
