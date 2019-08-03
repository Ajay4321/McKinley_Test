//
//  DataManager.m
//  LoginTest
//
//  Created by Ajay Awasthi on 03/08/19.
//  Copyright © 2019 Ajay Awasthi. All rights reserved.
//

#import "DataManager.h"
#import "NetworkManager.h"

#define BaseUrl  @"https://reqres.in/api/login"

@implementation DataManager

+ (instancetype)sharedManager{
    
    static DataManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DataManager alloc] init];
    });
    
    return sharedInstance;
}
- (void)loginWithParameters:(NSDictionary *)customParams withCompletionHandler:(void(^)(id responseObject, NSError *error))completionBlock
{
    
    [[NetworkManager sharedManager] createPostRequestWithParameters:customParams withRequestPath:BaseUrl withCompletionBlock:^(id responseObject, NSError *error){
        if (responseObject)
        {
            completionBlock(responseObject,nil);
        }
    }];
}

- (void)saveData:(id)data withKey:(NSString *)key
{
    if (!data) {
        return;
    }
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:data forKey:key];
    [prefs synchronize];
}

- (id)getDataForKey:(NSString*)key
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    id data = [prefs objectForKey:key];
    return data;
}


@end
