//
//  DataManager.h
//  LoginTest
//
//  Created by Ajay Awasthi on 03/08/19.
//  Copyright © 2019 Ajay Awasthi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DataManager : NSObject

+ (instancetype)sharedManager;

- (void)loginWithParameters:(NSDictionary *)customParams withCompletionHandler:(void(^)(id responseObject, NSError *error))completionBlock;

-(void)saveData:(id)data withKey:(NSString *)key;
- (id)getDataForKey:(NSString*)key;
- (BOOL)validateEmailWithString:(NSString*)email;
@end

NS_ASSUME_NONNULL_END
