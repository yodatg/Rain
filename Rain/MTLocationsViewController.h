//
//  MTLocationsViewController.h
//  Rain
//
//  Created by Thomas Grant on 20/12/2013.
//  Copyright (c) 2013 Thomas Grant. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MTLocationsViewControllerDelegate;

@interface MTLocationsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) id <MTLocationsViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end


@protocol MTLocationsViewControllerDelegate <NSObject>

- (void)controllerShouldAddCurrentLocation:(MTLocationsViewController *)controller;
- (void)controller:(MTLocationsViewController *)controller didSelectLocation:(NSDictionary *)location;

@end


