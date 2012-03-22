//
//  ParmyTabSets.m
//  Bumpy
//
//  Created by Tom Seago on 12/30/11.
//  Copyright 2011 Reality Box Labs LLC. All rights reserved.
//

#import "REDTabSetsRoot.h"
#import "REDlibInternal.h"

// hexdump -v -e '"0""x" 1/1 "%02x" ","' Sets.png 
char _gSetsBytes[] = {
    0x89,0x50,0x4e,0x47,0x0d,0x0a,0x1a,0x0a,0x00,0x00,0x00,0x0d,0x49,0x48,0x44,0x52,0x00,0x00,0x00,0x1c,0x00,0x00,0x00,0x1c,0x08,0x06,0x00,0x00,0x00,0x72,0x0d,0xdf,0x94,0x00,0x00,0x00,0x09,0x70,0x48,0x59,0x73,0x00,0x00,0x0b,0x13,0x00,0x00,0x0b,0x13,0x01,0x00,0x9a,0x9c,0x18,0x00,0x00,0x01,0x8a,0x49,0x44,0x41,0x54,0x48,0x89,0xed,0xd6,0xbf,0x4a,0x1c,0x51,0x14,0xc7,0xf1,0xcf,0x6e,0xd6,0x20,0x44,0x8c,0x81,0x14,0x82,0x45,0x4c,0x27,0x82,0x0f,0x20,0x29,0xac,0x6c,0x6d,0x92,0x54,0x76,0x16,0x11,0xf2,0x04,0x3e,0x41,0xc0,0x26,0x7d,0x4a,0x0b,0x45,0x10,0xf1,0x01,0x44,0x6c,0x52,0x07,0x0b,0x6b,0x11,0x2b,0x2d,0x4c,0xc4,0x3f,0x44,0x37,0x66,0xc7,0xe2,0xce,0xe2,0x32,0xec,0xcc,0xdc,0x59,0xdd,0x42,0xf0,0x07,0xc3,0xcc,0x85,0x33,0xe7,0x7b,0xe6,0xdc,0x3b,0xe7,0x9c,0x5a,0x92,0x24,0x3a,0xd4,0xc0,0x28,0x5e,0x8a,0x57,0x82,0x73,0x9c,0xc6,0x18,0x37,0x32,0xeb,0x77,0xd8,0x40,0x13,0xb7,0xa8,0x95,0xbc,0xdf,0xc2,0x6b,0xfc,0xc4,0xd7,0x5e,0x80,0x83,0xf8,0x8f,0x45,0x71,0x11,0x27,0xf8,0x8c,0x0f,0x31,0xb0,0x6e,0x40,0xb8,0xc6,0x11,0xfe,0x44,0xfa,0x38,0x16,0x82,0xec,0x19,0x58,0xc3,0x8b,0xf4,0x79,0x0b,0xe3,0x8a,0x53,0xfb,0x46,0x48,0xeb,0x9e,0xf0,0xc5,0x87,0xf8,0x28,0xa4,0x3b,0x0a,0xd8,0xa9,0x29,0x2c,0xa5,0x4e,0x92,0x1c,0x9b,0x56,0x7a,0x35,0xd2,0xe0,0x96,0x8b,0x1c,0x96,0x01,0x9b,0xf8,0x85,0x83,0x12,0xbb,0xb6,0x7e,0xe3,0x46,0xce,0xd7,0xc5,0x00,0x61,0x20,0xbd,0x2f,0x63,0xba,0xc4,0xf6,0x15,0xde,0x63,0x25,0x5d,0x9f,0xe1,0x1b,0x4e,0xaa,0x00,0xdb,0xa9,0x9c,0xc5,0x15,0x76,0x51,0x2f,0xb0,0xdd,0x14,0x4e,0xf8,0x30,0xbe,0xe0,0x47,0x55,0x60,0x5b,0x2d,0xe1,0x10,0x7d,0x8f,0xb4,0x1f,0xc2,0x9c,0xcc,0x81,0xcb,0x8b,0x34,0x4f,0x55,0x2a,0xd0,0x60,0x16,0xd6,0x0b,0xf0,0xc1,0x7a,0x06,0x3e,0x03,0x9f,0x2e,0x30,0xb7,0x16,0x3e,0x54,0xdd,0x2a,0x4d,0x43,0x68,0x37,0xff,0x0a,0x02,0x7a,0x34,0x60,0x13,0x23,0x58,0x4d,0x81,0x63,0xc2,0xa8,0xd1,0x37,0xe0,0x11,0x3e,0x09,0x65,0xa9,0x8e,0x75,0xf7,0xcd,0xb8,0x2f,0xc0,0x1b,0xec,0x77,0xac,0xff,0x0a,0x23,0x07,0x8f,0xb4,0xaf,0x45,0xdd,0xa2,0x2e,0x54,0xfc,0x35,0x5c,0x62,0x42,0x85,0xd9,0xa5,0x17,0x60,0x82,0x05,0xbc,0x15,0xaa,0xfe,0xb0,0xd0,0xd1,0xfb,0x0a,0xdc,0xe9,0x58,0xcf,0xe1,0xa2,0x82,0xef,0x6b,0x5d,0xe6,0xa0,0x2a,0x0d,0x78,0x00,0xf3,0x42,0x6a,0xcb,0x7e,0x97,0x44,0xd8,0x8e,0x51,0x99,0xbd,0xaf,0x02,0xdc,0xc5,0x0c,0x26,0x23,0xed,0x6b,0xd8,0x96,0x99,0x6f,0xef,0x00,0x4b,0xf6,0x4d,0xdd,0x1b,0x9b,0x13,0x64,0x00,0x00,0x00,0x00,0x49,0x45,0x4e,0x44,0xae,0x42,0x60,0x82};

@implementation REDTabSetsRoot

-(id) init
{
    self = [super init];
    if (self)
    {
        self.title = @"Sets";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:[REDlibInternal sharedInstance] action:@selector(hideControlWindow)];
        
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
        
        NSData* data = [NSData dataWithBytesNoCopy:_gSetsBytes length:sizeof(_gSetsBytes)];
        self.tabBarItem.image = [UIImage imageWithData:data];

    }
    return self;
}

-(void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"Set %d", indexPath.row];
    
    return cell;
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

@end
