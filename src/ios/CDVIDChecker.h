//
//  CSVIDChecker.h
//  IDChecker
//
//  Created by Brian Woods on 1/10/14.
//
//
#import <Cordova/CDV.h>
#import "IDCheckerSDK.h"

@interface CDVIDChecker : CDVPlugin
{
@private
  NSString *_cameraHelpText;
}

@property (nonatomic, strong) NSString *guid;
@property (nonatomic, strong) IDCDocument *document;
@property (nonatomic, assign) BOOL isUploadFrontColorImageDone;
@property (nonatomic, assign) BOOL isUploadBackColorImageDone;
@property (nonatomic, strong) IDCDocument *frontDoc;
@property (nonatomic, strong) IDCDocument *backDoc;


- (void)initializeClientCredentials:(CDVInvokedUrlCommand *)command;
- (void)captureCredentials:(CDVInvokedUrlCommand *)command;
- (void)captureFront:(CDVInvokedUrlCommand *)command;
- (void)captureFontAndBack:(CDVInvokedUrlCommand *)command;
- (void)presentCameraForButton:(CDVInvokedUrlCommand *)command;


@end
