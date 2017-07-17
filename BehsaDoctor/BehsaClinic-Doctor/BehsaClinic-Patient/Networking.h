//
//  Networking.h
//  NewProject
//
//  Created by Arash on 16/5/11.
//  Copyright © 2016 Arash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"
#import <sys/socket.h>
#import <netinet/in.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^NetworkingSuccessBlock)(NSDictionary * responseDict);
typedef void(^NetworkingFailureBlock)(NSError * _Nonnull error);
typedef void(^NetworkingCallBackBlock)(void);


@interface NetworkManager : AFHTTPSessionManager

+ (instancetype)shareManager;
+ (instancetype)shareManager2;

@end

@interface Networking : NSObject

/* get */
+ (void)getWithPath:(NSString *)path
         parameters:(NSDictionary *)parameters
            success:(NetworkingSuccessBlock)successBlock
            failure:(NetworkingFailureBlock)failureBlock
           callBack:(NetworkingCallBackBlock)callBackBlock;

/* post */
+ (void)postWithPath:(NSString *)path
          parameters:(NSDictionary *)parameters
             success:(NetworkingSuccessBlock)successBlock
             failure:(NetworkingFailureBlock)failureBlock;

/* put */
+ (void)putWithPath:(NSString *)path
         parameters:(NSDictionary *)parameters
            success:(NetworkingSuccessBlock)successBlock
            failure:(NetworkingFailureBlock)failureBlock
           callBack:(NetworkingCallBackBlock)callBackBlock;

/* delete */
+ (void)deleteWithPath:(NSString *)path
            parameters:(NSDictionary *)parameters
               success:(NetworkingSuccessBlock)successBlock
               failure:(NetworkingFailureBlock)failureBlock
              callBack:(NetworkingCallBackBlock)callBackBlock;

/* upload file */
+ (void)uploadImageWithPath:(NSString *)path
                 parameters:(NSDictionary *)parameters
                      image:(UIImage *)image
                       name:(NSString *)name
                  imageName:(NSString *)imageName
                  imageType:(NSString *)imageType
                    success:(NetworkingSuccessBlock)successBlock
                    failure:(NetworkingFailureBlock)failureBlock
                   callBack:(NetworkingCallBackBlock)callBackBlock;

/* form data */
+ (void)formDataWithPath:(NSString *)path
              parameters:(NSDictionary *)parameters
                 success:(NetworkingSuccessBlock)successBlock
                 failure:(NetworkingFailureBlock)failureBlock;
+ (void)uploadVoiceWithPath:(NSString *)path
                 parameters:(NSDictionary *)parameters
                      voice:(NSData *)voice
                    success:(NetworkingSuccessBlock)successBlock
                    failure:(NetworkingFailureBlock)failureBlock;

+ (BOOL)hasConnectivity;

NS_ASSUME_NONNULL_END

@end
