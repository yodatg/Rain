//
//  MTForecastClient.m
//  Rain
//
//  Created by Thomas Grant on 23/12/2013.
//  Copyright (c) 2013 Thomas Grant. All rights reserved.
//

#import "MTForecastClient.h"

@implementation MTForecastClient


+ (MTForecastClient *)sharedClient {
    
    static dispatch_once_t predicate;
    static MTForecastClient *_sharedClient = nil;
    dispatch_once(&predicate, ^{
        _sharedClient = [self alloc];
        _sharedClient = [_sharedClient initWithBaseURL:[self baseURL]];
    });
    return _sharedClient;
    
}

- (id)initWithBaseURL:(NSURL *)url {
    
    self = [super initWithBaseURL:url];
    if (self) {
        // Accept HTTP Header
        [self setDefaultHeader:@"Accept" value:@"application/json"];
        // Register HTTP Operation Class
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    }
    return self;
    
}

+ (NSURL *)baseURL {
    
    return [NSURL URLWithString:[NSString stringWithFormat:@"https://api.forecast.io/forecast/%@", MTForecastAPIKey]];
}
@end
