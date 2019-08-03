//
//  NetworkManager.m
//  LoginTest
//
//  Created by Ajay Awasthi on 03/08/19.
//  Copyright © 2019 Ajay Awasthi. All rights reserved.
//

#import "NetworkManager.h"

#import "AFNetworkReachabilityManager.h"

#define BaseUrl  @"https://reqres.in/api/login"

@interface NetworkManager ()

@property (nonatomic, strong) NSMutableArray *allTasks;

@end

@implementation NetworkManager

+ (instancetype)sharedManager{
    
    static NetworkManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[NetworkManager alloc] initWithBaseURL:[NSURL URLWithString:BaseUrl]];
    });
    
    return sharedInstance;
}


- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    
    if (self)
    {
        AFJSONResponseSerializer *responseSer = [AFJSONResponseSerializer serializer];
        responseSer.removesKeysWithNullValues = YES;
        responseSer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json", @"text/plain", @"text/html"]];
        
        self.responseSerializer = responseSer;
        self.requestSerializer = [AFHTTPRequestSerializer serializer];
    }
    
    return self;
}

- (void)createPostRequestWithParameters:(NSDictionary *)parameters
                        withRequestPath:(NSString *)requestPath
                    withCompletionBlock:(void(^)(id responseObject, NSError *error))completionBlock
{
    NSError *error = [self checkAndCreateInternetError];
    if (error) {
        if (completionBlock) {
            completionBlock(nil, error);
        }
        return;
    }
    
    NSDictionary *finalParameters = [NSDictionary dictionaryWithDictionary:parameters];
    NSURLSessionDataTask *task = [self POST:requestPath parameters:finalParameters success:^(NSURLSessionDataTask *task, id responseObject)
                                  {
                                      if (completionBlock) {
                                          completionBlock(responseObject, nil);
                                      }
                                      
                                      [self removeTask:task];
                                  } failure:^(NSURLSessionDataTask *task, NSError *error)
                                  {
                                      if (completionBlock) {
                                          completionBlock(nil, error);
                                      }
                                      [self removeTask:task];
                                  }];
    [self addTask:task];
}

- (NSError *)checkAndCreateInternetError
{
    if ([[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus] == AFNetworkReachabilityStatusNotReachable) {
        NSDictionary *dict = @{NSLocalizedDescriptionKey : @"Oops!! Your internet connection seems to be offline. Please try again."};
        NSError *error = [NSError errorWithDomain:@"ed" code:1986 userInfo:dict];
        return error;
    }
    
    return nil;
}

- (void)addTask:(id)task
{
    if (!self.allTasks)
        self.allTasks = [[NSMutableArray alloc] init];
    
    [self.allTasks addObject:task];
}

- (void)removeTask:(id)task
{
    [self.allTasks removeObject:task];
}

- (void)cancelAllTasks
{
    for (id task in self.allTasks)
    {
        if ([task isKindOfClass:[NSURLSessionDataTask class]]) {
            [(NSURLSessionDataTask *)task cancel];
        }
    }
    
    [self.allTasks removeAllObjects];
}


@end
