//
//  IDCSettings.h
//  IDCheckerSDK
//
//  Created by Michiel Boertjes on 5/31/13.
//  Copyright (c) 2013 IDChecker. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IDCConfiguration;

@interface IDCSettings : NSObject


/**
 if YES the camera view will automaticly take a picture when the document is filling the screen and image quality is good enough
 */
@property (nonatomic, assign) BOOL isUsingAutoCapture;

@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *devAPIToken;
@property (nonatomic, strong) NSNumber *webUserId;
@property (nonatomic, strong) NSString *agent;
@property (nonatomic, strong) NSString *clientRef;

@property (nonatomic, strong, readonly) IDCConfiguration *configuration;

- (void)loadConfigWithBlock:(void(^)(NSError *))block;

@end
