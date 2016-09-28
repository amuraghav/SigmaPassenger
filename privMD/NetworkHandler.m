//
//  NetworkHandler.m
//  privMD
//
//  Created by Surender Rathore on 29/03/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//

#import "NetworkHandler.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>

@interface NetworkHandler ()
@property(nonatomic,strong) AFHTTPRequestOperationManager *manager;
@end

@implementation NetworkHandler
@synthesize manager;
static NetworkHandler *networkHandler;

+ (id)sharedInstance {
    if (!networkHandler) {
        networkHandler  = [[self alloc] init];
    }
    
    return networkHandler;
}
-(void)composeRequestWithMethod:(NSString*)method paramas:(NSDictionary*)paramas onComplition:(void (^)(BOOL succeeded, NSDictionary  *response))completionBlock {
    
    self.manager = [AFHTTPRequestOperationManager manager];
    NSOperationQueue *operationQueue = self.manager.operationQueue;
    
    // BOOL isReachable =  [AFNetworkReachabilityManager sharedManager].reachable;
    
    //  if (isReachable)
    {
        
        
        NSString *postUrl = [self getBaseString:method];
        [self.manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status)
         
         {
             switch (status)
             {
                 case AFNetworkReachabilityStatusReachableViaWWAN:
                 case AFNetworkReachabilityStatusReachableViaWiFi:
                 {
                     NSLog(@"SO REACHABLE");
                     [operationQueue setSuspended:NO]; // or do whatever you want
                     [self.manager POST:postUrl parameters:paramas success:^(AFHTTPRequestOperation *operation, id responseObject) {
                         
                         //send success response with data
                         completionBlock(YES,responseObject);
                         
                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                         
                         
                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Network Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                         [alertView show];
                         [[ProgressIndicator sharedInstance]hideProgressIndicator];
                         //send response as Nil
                         completionBlock(NO,nil);
                         
                     }];
                     break;
                 }
                     
                 case AFNetworkReachabilityStatusNotReachable:
                 default:
                 {
                     NSLog(@"SO UNREACHABLE");
                     [operationQueue setSuspended:YES];
                     NSError *error;
                     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Network Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                     [alertView show];
                     [[ProgressIndicator sharedInstance]hideProgressIndicator];
                     //send response as Nil
                     completionBlock(NO,nil);
                     break;
                 }
             }
         }];
        [self.manager.reachabilityManager startMonitoring];
    }
    //    else {
    //        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No Internet Connection" message:@"Network not reachable at the moment, Please try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    //        [alert show];
    //
    //    }
}

-(void)cancelRequestOperation{
    
    for (NSOperation *operation in self.manager.operationQueue.operations) {
        // here you can check if this is an operation you want to cancel
        [operation cancel];
    }
}

-(NSString*)getBaseString:(NSString*)method
{
    return [NSString stringWithFormat:@"%@%@", BASE_URL, method];
}

-(NSString*)paramDictionaryToString:(NSDictionary*)params
{
    NSMutableString *request = [[NSMutableString alloc] init];
    [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [request appendFormat:@"&%@=%@", key, obj];
    }];
    
    NSString *finalRequest = request;
    if ([request hasPrefix:@"&"]) {
        finalRequest = [request substringFromIndex:1];
    }
    
    return finalRequest;
}

@end
