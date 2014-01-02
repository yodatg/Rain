//
//  MTLocationsViewController.m
//  Rain
//
//  Created by Thomas Grant on 20/12/2013.
//  Copyright (c) 2013 Thomas Grant. All rights reserved.
//

#import "MTLocationsViewController.h"

static NSString *LocationCell = @"LocationCell";


@interface MTLocationsViewController ()

@property (strong, nonatomic) NSMutableArray *locations;

@end

@implementation MTLocationsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self loadLocations];
        // Add Observer
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didAddLocation:) name:MTRainDidAddLocationNotification object:nil];
    }
    return self;
}

- (void)didAddLocation:(NSNotification *)notification {
    
    NSDictionary *location = [notification userInfo];
    [self.locations addObject:location];
    [self.locations sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:MTLocationKeyCity ascending:YES]]];
    
}

- (void)loadLocations {
    
    self.locations = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:MTRainUserDefaultsLocations]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //setup View
    [self setupView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupView {
    
    // Register class for cell reuse
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:LocationCell];
}

#pragma mark - TableView Data & Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ([self.locations count] + 1);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LocationCell forIndexPath:indexPath];
    
    // Configure Cell
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        [cell.textLabel setText:@"Add Current Location"];
    } else {
        // Fetch Location
        NSDictionary *location = [self.locations objectAtIndex:(indexPath.row - 1)];
        // configure cell
        [cell.textLabel setText:[NSString stringWithFormat:@"%@, %@", location[MTLocationKeyCity], location[MTLocationKeyCountry]]];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // user selected Add Location
    if (indexPath.row == 0) {
        // notify delegate
        [self.delegate controllerShouldAddCurrentLocation:self];
    
    // user selected a location
    } else {
        //fetch location
        NSDictionary *location = [self.locations objectAtIndex:(indexPath.row - 1)];
        
        // Notify delegate
        [self.delegate controller:self didSelectLocation:location];
    }
    //show center view controller
    [self.viewDeckController closeLeftViewAnimated:YES];
}

- (void)dealloc {
    
    // Remove Observer
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if(_delegate) {
        _delegate = nil;
    }
}

@end
