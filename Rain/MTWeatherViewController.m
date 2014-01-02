//
//  MTWeatherViewController.m
//  Rain
//
//  Created by Thomas Grant on 20/12/2013.
//  Copyright (c) 2013 Thomas Grant. All rights reserved.
//

#import "MTWeatherViewController.h"

@interface MTWeatherViewController () <CLLocationManagerDelegate> {
    BOOL _locationFound;
}
@property (strong, nonatomic) NSDictionary *location;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation MTWeatherViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.locationManager = [[CLLocationManager alloc] init];
        // configure location manager
        [self.locationManager setDelegate:self];
        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyKilometer];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.location = [[NSUserDefaults standardUserDefaults] objectForKey:MTRainUserDefaultsLocation];
    if (!self.location) {
        [self.locationManager startUpdatingLocation];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)controllerShouldAddCurrentLocation:(MTLocationsViewController *)controller {
    [self.locationManager startUpdatingLocation];
}

- (void)controller:(MTLocationsViewController *)controller didSelectLocation:(NSDictionary *)location {
    self.location = location;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    if (![locations count] || _locationFound) {
        return;
    }
    // stop updating location
    _locationFound = YES;
    [manager stopUpdatingLocation];
    // Current Location
    CLLocation *currentLocation = [locations objectAtIndex:0];
    //reverse geocode
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if ([placemarks count]) {
            _locationFound = NO;
            [self processPlacemark:[placemarks objectAtIndex:0]];
        }
    }];
}

- (void)processPlacemark:(CLPlacemark *)placemark {
    
    //Extract Data
    NSString *city = [placemark locality];
    NSString *country = [placemark country];
    CLLocationDegrees lat = placemark.location.coordinate.latitude;
    CLLocationDegrees lon = placemark.location.coordinate.longitude;
    // Create Location Dictionary
    NSDictionary *currentLocation = @{ MTLocationKeyCity : city, MTLocationKeyCountry : country, MTLocationKeyLatitude : @(lat), MTLocationKeyLongitude : @(lon) };
    
    //Add to locations
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSMutableArray *locations = [NSMutableArray arrayWithArray:[ud objectForKey:MTRainUserDefaultsLocations]];
    [locations addObject:currentLocation];
    [locations sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:MTLocationKeyCity ascending:YES]]];
    [ud setObject:locations forKey:MTRainUserDefaultsLocations];
    //Synchronise
    [ud synchronize];
    // update current location
    self.location = currentLocation;
    // Post notifications
    NSNotification *notification2 = [NSNotification notificationWithName:MTRainDidAddLocationNotification object:self userInfo:currentLocation];
    [[NSNotificationCenter defaultCenter] postNotification:notification2];
     
}

- (void)setLocation:(NSDictionary *)location {
    
    if (_location != location) {
        _location = location;
        
        // update user defaults
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:location forKey:MTRainUserDefaultsLocation];
        [ud synchronize];
        // Post Notification
        NSNotification *notification1 = [NSNotification notificationWithName:MTRainLocationDidChangeNotification object:self userInfo:location];
        [[NSNotificationCenter defaultCenter] postNotification:notification1];
        // update view
        [self updateView];
    }
}

- (void)updateView {
    //update location label
    [self.labelLocation setText:[self.location objectForKey:MTLocationKeyCity]];
}

@end
