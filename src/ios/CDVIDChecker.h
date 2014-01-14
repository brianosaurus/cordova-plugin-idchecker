//
//  CSVIDChecker.h
//  IDChecker
//
//  Created by Brian Woods on 1/10/14.
//
//

#import <Cordova/CDV.h>

@interface CDVIDChecker : CDVPlugin
{
@private
    
    NSString *_cameraHelpText;
}

- (void)captureCredentials:(CDVInvokedUrlCommand *)command;

@end
