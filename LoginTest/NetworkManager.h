//
//  NetworkManager.h
//  LoginTest
//
//  Created by Ajay Awasthi on 03/08/19.
//  Copyright © 2019 Ajay Awasthi. All rights reserved.
//

#import "AFHTTPSessionManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface NetworkManager : AFHTTPSessionManager

+ (instancetype)sharedManager;
- (void)createPostRequestWithParameters:(NSDictionary *)parameters
                        withRequestPath:(NSString *)requestPath
                    withCompletionBlock:(void(^)(id responseObject, NSError *error))completionBlock;
@end

NS_ASSUME_NONNULL_END
