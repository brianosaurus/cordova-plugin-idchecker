//
//  CSVIDChecker.m
//  IDChecker
//
//  Created by Brian Woods on 1/10/14.
//
//

#import "CDVIDChecker.h"
#import <IDCheckerSDK/IDCheckerSDK.h>

@implementation CDVIDChecker
{
    IDCDocument *_currentDoc;
    UIView *_waitView;
}

- (CDVIDChecker*)initWithWebView:(UIWebView*)theWebView
{
    self = [super initWithWebView:theWebView];
    if (self != nil) {
        NSDictionary *config = self.commandDelegate.settings;
        _cameraHelpText = [config valueForKey:@"com.idchecker.cameraHelpText"];
        
        IDCSettings *settings = [[IDCSettings alloc] init];
        
        // slightly ardrous
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        settings.userId = [f numberFromString:[config valueForKey:@"com.idchecker.userID"]];
        settings.password = [config valueForKey:@"com.idchecker.password"];
        
        settings.webUserId = @0;
        settings.agent = [config valueForKey:@"com.idchecker.agent"];
        settings.devAPIToken = [config valueForKey:@"com.idchecker.devAPIToken"];
        settings.clientRef = [config valueForKey:@"com.idchecker.clientRef"];
        settings.isUsingAutoCapture = YES;
        
        settings.agent = @"HelloBit";
        settings.devAPIToken = @"YU6R6-JTFPX-HBPAB";
        settings.clientRef = @"HelloBit";
        settings.password = @"B8it6Wi2s2e";
        settings.userId = @2286;
        _cameraHelpText = @"Put Butt Here";
        
        //settings.userId = @6;
        //settings.password = @"haarlem";
        //settings.webUserId = @0;
        //settings.agent = @"IDCheckeriOSdemo App";
        //settings.devAPIToken = @"IOSSDKDEMO";
        //settings.clientRef = @"IDCheckeriOSDemo";
        
        [[IDCheckerSDK shared] loadWithSettings:settings block:^(NSError *error) {
            if(!error) {
                //self.captureAndUploadBtn.enabled = YES;
                //self.uploadBtn.enabled = YES;
                //self.uploadMultiBtn.enabled = YES;
                //self.uploadAndCloseBtn.enabled = YES;
            }
        }];
        
        // loading spinner
        _waitView = [[UIView alloc] initWithFrame:self.webView.bounds];
        [self.webView addSubview:_waitView];
        UIView *semiTransBackground = [[UIView alloc] initWithFrame:_waitView.bounds];
        semiTransBackground.backgroundColor = [UIColor colorWithWhite:0.f alpha:.8];
        [_waitView addSubview:semiTransBackground];
        UIActivityIndicatorView *ai = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        ai.frame = _waitView.bounds;
        [_waitView addSubview:ai];
        [ai startAnimating];
        _waitView.alpha = 0.f;
        
    }
    
    return self;
}

- (void)captureCredentials:(CDVInvokedUrlCommand *)command
{
    CDVPluginResult *pluginResult;
    
    NSString *country = [command.arguments objectAtIndex:0];
    NSString *type = [command.arguments objectAtIndex:1];
    IDCDocType docType;
    
    if ([type isEqualToString:@"DriversLicense"]) {
        docType = kIDCDocTypeDriversLicense;
    } else if ([type isEqualToString:@"2DBarCode"] ) {
        docType = kIDCDocType2DBarcode;
    } else {
        docType = kIDCDocTypePassport;
    }
    
    //doc type and country are not used yet but will be in the future
    IDCDocument *doc = [[IDCDocument alloc] initWithDocType:docType country:country];
    doc.cameraHelpText = _cameraHelpText;
    doc.documentDimensions = CGSizeMake(85.6, 54.f);
    
    
    [[IDCheckerSDK shared] startProcessForDocument:doc viewControllerToPresent:self.viewController quality:kIDCQualityTypeMedium pictureTakenBlock:^(BOOL pictureTaken) {
        if(pictureTaken){
            //Callback That Picture is Taken
            [self showWait:YES];
        }
    } uploadDoneBlock:^(IDCDocument *doc) {
        if(!doc.error) {
            // Callback with data
            //we save the guid so we can use it to refresh the data later
            _currentDoc = doc;
            [[IDCheckerSDK shared] uploadColorImageForIDCProcessing:doc.originalImage guid:doc.guid block:^(NSError *error) {
                if(error)
                {
                    [self showWait:NO];
                    [self.webView stringByEvaluatingJavaScriptFromString:@"ImageUploadError()"];
                }else{
                    [[IDCheckerSDK shared] closeRecordForGuid:doc.guid block:^(NSError *error) {
                        if(error) {
                            [self showWait:NO];
                            
                            // Call error callback
                            [self.webView stringByEvaluatingJavaScriptFromString:@"ImageUploadError()"];
                        } else{
                            // Start polling for more data
                            [[IDCheckerSDK shared] startPollingForMoreAccurateData:_currentDoc pollingResultBlock:^(IDCDocument *result) {
                                //we got a result;
                                [self showWait:NO];
                                
                                // build result into data structure to return via callback
                            }];
                            
                        }
                    }];
                }
            }];
        }else{
            // Call error Callback
            [self.webView stringByEvaluatingJavaScriptFromString:@"ErrorTakingPicture()"];
        }
    }];
    
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}


- (void)showWait:(BOOL)show
{
    [UIView animateWithDuration:.2 animations:^{
        _waitView.alpha = show ? 1.f : 0.f;
    }];
}


@end
