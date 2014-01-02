//
//  MTForecastClient.h
//  Rain
//
//  Created by Thomas Grant on 23/12/2013.
//  Copyright (c) 2013 Thomas Grant. All rights reserved.
//

#import "AFHTTPClient.h"

@interface MTForecastClient : AFHTTPClient
#pragma mark -
#pragma mark Shared Client
+ (MTForecastClient *)sharedClient;

@end
