    //
    //  Networking.m
    //  NewProject
    //
    //  Created by Arash on 16/5/11.
    //  Copyright © 2016 Arash. All rights reserved.
    //

#import "Networking.h"

@implementation NetworkManager

+ (instancetype)shareManager
{
    static NetworkManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[NetworkManager alloc] initWithBaseURL:[NSURL URLWithString: [self baseURL]]];
            // Set the request timeout
        manager.requestSerializer.timeoutInterval = 30;
            // The requested data type
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
            // Request header type
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        
            // The data type returned
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/javascript", @"application/x-javascript", @"text/plain", @"image/gif", nil];
        
            // AFSecurityPolicy
        manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        
    });
    
    return manager;
}

+ (instancetype)shareManager2
{
        //    static NetworkManager * manager = nil;
        //    static dispatch_once_t onceToken;
        //    dispatch_once(&onceToken, ^{
    
    NetworkManager *manager = [[NetworkManager alloc] initWithBaseURL:[NSURL URLWithString: [self baseURL]]];
        // Set the request timeout
    manager.requestSerializer.timeoutInterval = 30;
        // The requested data type
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
        // Request header type
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", [GetUsernamePassword getAccessToken]] forHTTPHeaderField:@"Authorization"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
        // The data type returned
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/javascript", @"application/x-javascript", @"text/plain", @"image/gif", nil];
    
        // AFSecurityPolicy
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        //    });
    
    return manager;
}

#pragma mark BaseURL
+ (NSString *)baseURL
{
    return BaseURL;
}


@end

@implementation Networking

+ (void)getWithPath:(NSString *)path
         parameters:(NSString *)parameters
            success:(NetworkingSuccessBlock)successBlock
            failure:(NetworkingFailureBlock)failureBlock
           callBack:(NetworkingCallBackBlock)callBackBlock
{
    if (![Networking hasConnectivity]) {
        [[AZJAlertView sharedInstance]showMessage:@"شما در حالت آفلاین هستید!" withType:AZJAlertMessageTypeError];
        return;
    }
    NetworkManager * manager = [NetworkManager shareManager];
    [manager GET:path
      parameters:parameters
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
     successBlock(responseObject);
     callBackBlock();
     }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
     failureBlock(error);
     callBackBlock();
     }];
    
}

+ (void)postWithPath:(NSString *)path parameters:(NSString *)parameters success:(NetworkingSuccessBlock)successBlock failure:(NetworkingFailureBlock)failureBlock{
    if (![Networking hasConnectivity]) {
        [[AZJAlertView sharedInstance]showMessage:@"شما در حالت آفلاین هستید!" withType:AZJAlertMessageTypeError];
        return;
    }
        //    NSLog(@"Api = %@,parameters = %@", path, parameters);
    NetworkManager * manager = [NetworkManager shareManager];
    [manager POST:path parameters:parameters
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         //         NSLog(@"responseObject = %@",responseObject);
     successBlock(responseObject);
     }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
     failureBlock(error);
     }];
    
}

+(void)putWithPath:(NSString *)path
        parameters:(NSDictionary *)parameters
           success:(NetworkingSuccessBlock)successBlock
           failure:(NetworkingFailureBlock)failureBlock
          callBack:(NetworkingCallBackBlock)callBackBlock
{
    NetworkManager * manager = [NetworkManager shareManager];
    [manager PUT:path parameters:parameters
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
     successBlock(responseObject);
     callBackBlock();
     }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
     failureBlock(error);
     callBackBlock();
     }];
}

+ (void)deleteWithPath:(NSString *)path
            parameters:(NSDictionary *)parameters
               success:(NetworkingSuccessBlock)successBlock
               failure:(NetworkingFailureBlock)failureBlock
              callBack:(NetworkingCallBackBlock)callBackBlock
{
    NetworkManager * manager = [NetworkManager shareManager];
    [manager DELETE:path parameters:parameters
            success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
     successBlock(responseObject);
     callBackBlock();
     }
            failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
     failureBlock(error);
     callBackBlock();
     }];
    
    
    
}


+ (void)uploadImageWithPath:(NSString *)path
                 parameters:(NSDictionary *)parameters
                      image:(UIImage *)image
                       name:(NSString *)name
                  imageName:(NSString *)imageName
                  imageType:(NSString *)imageType
                    success:(NetworkingSuccessBlock)successBlock
                    failure:(NetworkingFailureBlock)failureBlock
                   callBack:(NetworkingCallBackBlock)callBackBlock
{
    if (![Networking hasConnectivity]) {
        [[AZJAlertView sharedInstance]showMessage:@"شما در حالت آفلاین هستید!" withType:AZJAlertMessageTypeError];
        return;
    }
    [ProgressHUD show:@""];
    NetworkManager * manager = [NetworkManager shareManager2];
    [manager POST:path parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
            //  When it is set to 1.0, it will be compressed with the default value (0.6).
        NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
        [formData appendPartWithFileData:imageData name:name fileName:imageName mimeType:[NSString stringWithFormat:@"image/%@",imageType]]; // png/jpeg
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //[ProgressHUD dismiss];
        successBlock(responseObject);
        callBackBlock();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //[ProgressHUD dismiss];
        failureBlock(error);
        callBackBlock();
    }];
    
}

+ (void)formDataWithPath:(NSString *)path
              parameters:(NSDictionary *)parameters
                 success:(NetworkingSuccessBlock)successBlock
                 failure:(NetworkingFailureBlock)failureBlock
{
    if (![Networking hasConnectivity]) {
        [[AZJAlertView sharedInstance]showMessage:@"شما در حالت آفلاین هستید!" withType:AZJAlertMessageTypeError];
        return;
    }
    //[ProgressHUD show:@""];
        //NetworkManager * manager = [NetworkManager shareManager2];
    NetworkManager *manager = [[NetworkManager alloc] initWithBaseURL:[NSURL URLWithString: [self baseURL]]];
        // Set the request timeout
    manager.requestSerializer.timeoutInterval = 30;
        // The requested data type
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
        // Request header type
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", [GetUsernamePassword getAccessToken]] forHTTPHeaderField:@"Authorization"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
        // The data type returned
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/javascript", @"application/x-javascript", @"text/plain", @"image/gif", nil];
    
        // AFSecurityPolicy
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    [manager POST:path parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //[ProgressHUD dismiss];
        successBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //[ProgressHUD dismiss];
        failureBlock(error);
    }];
}

+ (void)uploadVoiceWithPath:(NSString *)path
                 parameters:(NSDictionary *)parameters
                      voice:(NSData *)voice
                    success:(NetworkingSuccessBlock)successBlock
                    failure:(NetworkingFailureBlock)failureBlock
{
    [ProgressHUD show:@""];
    NetworkManager * manager = [NetworkManager shareManager2];
    [manager POST:path parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        if (voice) {
            [formData appendPartWithFileData:voice
                                        name:@"voice"
                                    fileName:@"voice" mimeType:@"audio/x-caf"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //[ProgressHUD dismiss];
        successBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //[ProgressHUD dismiss];
        failureBlock(error);
    }];
    
}

+ (NSString *)baseURL
{
    return BaseURL;
}

+ (BOOL)hasConnectivity {
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr*)&zeroAddress);
    if(reachability != NULL) {
            //NetworkStatus retVal = NotReachable;
        SCNetworkReachabilityFlags flags;
        if (SCNetworkReachabilityGetFlags(reachability, &flags)) {
            if ((flags & kSCNetworkReachabilityFlagsReachable) == 0)
                {
                    // if target host is not reachable
                return NO;
                }
            
            if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0)
                {
                    // if target host is reachable and no connection is required
                    //  then we'll assume (for now) that your on Wi-Fi
                return YES;
                }
            
            
            if ((((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) ||
                 (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0))
                {
                    // ... and the connection is on-demand (or on-traffic) if the
                    //     calling application is using the CFSocketStream or higher APIs
                
                if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0)
                    {
                        // ... and no [user] intervention is needed
                    return YES;
                    }
                }
            
            if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN)
                {
                    // ... but WWAN connections are OK if the calling application
                    //     is using the CFNetwork (CFSocketStream?) APIs.
                return YES;
                }
        }
    }
    
    return NO;
}

@end
