//
//  IDCheckerSDK.h
//  IDCheckerSDK
//
//  Created by Michiel Boertjes on 5/8/13.
//  Copyright (c) 2013 IDChecker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IDCSettings.h"
#import "IDCDocument.h"

@class IDCSettings, IDCDocument, IDCRequestObject;

@interface IDCheckerSDK : NSObject

@property (nonatomic, strong, readonly) IDCSettings *settings;
@property (nonatomic, copy) IDCDocumentProcessedBlock pollingDoneBlock;


/**
 * Call this method first
 */
- (void)loadWithSettings:(IDCSettings *)settings block:(void(^)(NSError *))block;

/**
 * After calling +shared please load your custom settings before calling methods
 */
+ (IDCheckerSDK *)shared;

//- (void)openRecord;

/**
 * SDK takes care of image taking and upload
 * The camera viewcontroller is dismissed after the picture is taken. Upload starts at this moment
 * The IDCDocument argument has to have at least documentDimensions property set.
 * Please set highRes to YES if an image may contain a 2D barcode.
 */
- (void)startProcessForDocument:(IDCDocument *)document viewControllerToPresent:(UIViewController *)vc quality:(IDCQualityType)quality  pictureTakenBlock:(void(^)(BOOL))pictureTakenBlock uploadDoneBlock:(IDCDocumentProcessedBlock)uploadBlock;

/**
 * IDCCameraViewController is presented modally on the supplied UIViewController
 * Please set highRes to YES if an image may contain a 2D barcode.
 */
- (void)takePicture:(IDCDocument *)document viewControllerToPresent:(UIViewController *)vc quality:(IDCQualityType)quality pictureTakenBlock:(IDCDocumentProcessedBlock)pictureTakenBlock;


/**
 * Send a document taken with the -takePicture method to IDchecker for OCR processing
 */
- (void)uploadDocumentForOcr:(IDCDocument *)document ocrResultBlock:(IDCDocumentProcessedBlock)ocrResultBlock;

/**
 * Fetch more accurate data from server for an uploaded document.
 * Please note that -uploadColorImageForIDCProcessing has to be done first.
 * The polling timer fires every 30 seconds
 * If this method is called again while polling is in progress the previous polling will be canceled and it's block will be called with nil as argument
 */
- (void)startPollingForMoreAccurateData:(IDCDocument *)pollingDoc pollingResultBlock:(IDCDocumentProcessedBlock)block;

/**
 * Calling stopPoling stops the polling timer and calls the provided code block with nil as argument
 */
- (void)stopPolling;

/**
 * If you wish to control the time the guid is requested use this method
 */
- (void)openRecordWithBlock:(void(^)(NSString *, NSError *))block;

/**
 * Upload color image to IDChecker for processing
 * If you have no guid at this moment (you did not call the startProcessForDocument method first) please use openRecordWithBlock to obtain one.
 */
- (void)uploadColorImageForIDCProcessing:(UIImage *)image guid:(NSString *)guid block:(void(^)(NSError *))block;

/**
 * After all desired uploads are done we need to close the record to indicate it's ready for processing
 */
- (void)closeRecordForGuid:(NSString *)guid block:(void(^)(NSError *))block;

/**
 * returns a version number for the sdk
 */
+ (CGFloat)sdkVersion;

/**
 * returns a build number for the sdk
 */
+ (NSInteger)sdkBuild;

@end
