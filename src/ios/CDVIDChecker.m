//
//  CSVIDChecker.m
//  IDChecker
//
//  Created by Brian Woods on 1/10/14.
//
//

#import "CDVIDChecker.h"
#import "IDCheckerSDK.h"

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
        //_cameraHelpText = [config valueForKey:@"com.idchecker.cameraHelpText"];
        
        IDCSettings *settings = [[IDCSettings alloc] init];
        
        // slightly ardrous
        //NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        //[f setNumberStyle:NSNumberFormatterDecimalStyle];
        //settings.userId = [f numberFromString:[config valueForKey:@"com.idchecker.userID"]];
        //settings.password = [config valueForKey:@"com.idchecker.password"];
        
        settings.webUserId = @0;
        //settings.agent = [config valueForKey:@"com.idchecker.agent"];
        //settings.devAPIToken = [config valueForKey:@"com.idchecker.devAPIToken"];
        //settings.clientRef = [config valueForKey:@"com.idchecker.clientRef"];
        settings.isUsingAutoCapture = YES;
        
        settings.agent = @"HelloBit";
        settings.devAPIToken = @"YU6R6-JTFPX-HBPAB";
        settings.clientRef = @"HelloBit";
        settings.password = @"B8it6Wi2s2e";
        settings.userId = @2286;
        //_cameraHelpText = @"Put Butt Here";
        
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
  
  IDCSettings *settings = [[IDCSettings alloc] init];
  
  // slightly ardrous
  //NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
  //[f setNumberStyle:NSNumberFormatterDecimalStyle];
  //settings.userId = [f numberFromString:[config valueForKey:@"com.idchecker.userID"]];
  //settings.password = [config valueForKey:@"com.idchecker.password"];
  
  settings.webUserId = @0;
  //settings.agent = [config valueForKey:@"com.idchecker.agent"];
  //settings.devAPIToken = [config valueForKey:@"com.idchecker.devAPIToken"];
  //settings.clientRef = [config valueForKey:@"com.idchecker.clientRef"];
  settings.isUsingAutoCapture = YES;
  
  settings.agent = @"HelloBit";
  settings.devAPIToken = @"YU6R6-JTFPX-HBPAB";
  settings.clientRef = @"HelloBit";
  settings.password = @"B8it6Wi2s2e";
  settings.userId = @2286;
  //_cameraHelpText = @"Put Butt Here";
  
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

  
  
  //doc type and country are not used yet but will be in the future
  IDCDocument *doc = [[IDCDocument alloc] initWithDocType:docType country:country];
  doc.cameraHelpText = _cameraHelpText;
  doc.documentDimensions = CGSizeMake(85.6, 54.f);
  
  CDVPluginResult* pluginResult = nil;
  
  
  [[IDCheckerSDK shared] startProcessForDocument:doc viewControllerToPresent:self.viewController
                                         quality:kIDCQualityTypeMedium pictureTakenBlock:^(BOOL pictureTaken) {
      CDVPluginResult* pluginResult = nil;
      NSString* myarg = [command.arguments objectAtIndex:0];
      
      if (myarg != nil) {
          pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"Here 1"];
      } else {
          pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Arg was null"];
      }
      [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
      
      return;

      
      if(pictureTaken){
          //Callback That Picture is Taken
          [self showWait:YES];
      }
  } uploadDoneBlock:^(IDCDocument *doc) {
      
      CDVPluginResult* pluginResult = nil;
      NSString* myarg = [command.arguments objectAtIndex:0];
      
      if (myarg != nil) {
          pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK  messageAsString:@"Here 2"];
      } else {
          pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Arg was null"];
      }
      [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
      
      return;

      if(!doc.error) {
          // Callback with data
          //we save the guid so we can use it to refresh the data later
          _currentDoc = doc;
          [[IDCheckerSDK shared] uploadColorImageForIDCProcessing:doc.originalImage guid:doc.guid block:^(NSError *error) {
              if(error)
              {
                  [self showWait:NO];
                  CDVPluginResult *res = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
                  [self.commandDelegate sendPluginResult:res callbackId:command.callbackId];
              } else {
                  [[IDCheckerSDK shared] closeRecordForGuid:doc.guid block:^(NSError *error) {
                      if(error) {
                          [self showWait:NO];
                          
                          // Call error callback
                          CDVPluginResult *res = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
                          [self.commandDelegate sendPluginResult:res callbackId:command.callbackId];
                      } else {
                          // Start polling for more data
                          [[IDCheckerSDK shared] startPollingForMoreAccurateData:_currentDoc pollingResultBlock:^(IDCDocument *result) {
                              //we got a result;
                              [self showWait:NO];

                              
                              NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                              [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
                              
                              // turn the images into something we can handle/post back to the server to save
                              NSData *origImageData = UIImageJPEGRepresentation(result.originalImage, 1.0);
                              NSData *passPhotoData = UIImageJPEGRepresentation(result.passPhoto, 1.0);
                              NSData *processedImageData = UIImageJPEGRepresentation(result.processedImage, 1.0);
                              NSString *origImage64 = [origImageData base64Encoding];
                              NSString *passPhoto64 = [passPhotoData base64Encoding];
                              NSString *processed64 = [processedImageData base64Encoding];
                              
                              NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:17];
                              if (result.clientRef) [dict setObject:result.clientRef forKey:@"ClientRef"];
                              if (result.firstName) [dict setObject:result.firstName forKey:@"FirstName"];
                              if (result.lastName) [dict setObject:result.lastName forKey:@"LastName"];
                              if (result.address1) [dict setObject:result.address1 forKey:@"Address1"];
                              if (result.address2) [dict setObject:result.address2 forKey:@"Address2"];
                              if (result.doB) [dict setObject:[dateFormatter stringFromDate:result.doB] forKey:@"DOB"];
                              if (result.expDate) [dict setObject:[dateFormatter stringFromDate:result.expDate] forKey:@"Expiration"];
                              if (result.countryResultAbbrevation) [dict setObject:result.countryResultAbbrevation forKey:@"Country"];
                              if (result.socialSecurityNumber) [dict setObject:result.socialSecurityNumber forKey:@"SSN"];
                              if (result.documentNumber) [dict setObject:result.documentNumber forKey:@"DocumentNumber"];
                              if (result.issueDate) [dict setObject:[dateFormatter stringFromDate:result.issueDate] forKey:@"IssueDate"];
                              if (passPhoto64) [dict setObject:passPhoto64 forKey:@"PassPhoto"];
                              if (origImage64) [dict setObject:origImage64 forKey:@"OrigPhoto"];
                              if (processed64) [dict setObject:processed64 forKey:@"ProcessedPhoto"];
                              if (result.nationality) [dict setObject:result.nationality forKey:@"Nationality"];
                              if (result.guid) [dict setObject:result.guid forKey:@"GUID"];
                              
                              // build result into data structure to return via callback
                              CDVPluginResult *res = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dict];
                              [self.commandDelegate sendPluginResult:res callbackId:command.callbackId];
                          }];
                      }
                  }];
              }
          }];
      } else {
          
          CDVPluginResult* pluginResult = nil;
          NSString* myarg = [command.arguments objectAtIndex:0];
          
          if (myarg != nil) {
              pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
          } else {
              pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Arg was null"];
          }
          [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
          
          return;

          // Call error Callback
          CDVPluginResult *res = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
          [self.commandDelegate sendPluginResult:res callbackId:command.callbackId];
      }
  }];
}


- (void)showWait:(BOOL)show
{
    [UIView animateWithDuration:.2 animations:^{
        _waitView.alpha = show ? 1.f : 0.f;
    }];
}


@end
