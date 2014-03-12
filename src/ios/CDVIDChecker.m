//
//  CSVIDChecker.m
//  IDChecker
//
//  Created by Brian Woods on 1/10/14.
//
//

#import "CDVIDChecker.h"
#import "IDCheckerSDK.h"

#define WEAK_SELF() __weak __typeof(self)__self = self
#define STRONG_SELF() __strong __typeof(__self)_self = __self;


@implementation CDVIDChecker
{
  IDCDocument *_currentDoc;
  UIView *_waitView;
  IDCDocType _docType;
  IDCQualityType _quality;
  NSString* _callbackId;
}


- (CDVIDChecker*)initWithWebView:(UIWebView*)theWebView
{
  self = [super initWithWebView:theWebView];
  
  if (self != nil) {
    // loading spinner
    _waitView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
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


- (void)initializeClientCredentials:(CDVInvokedUrlCommand *)command
{
  NSString *agent = [command.arguments objectAtIndex:0];
  NSString *devAPIToken = [command.arguments objectAtIndex:1];
  NSString *clientRef = [command.arguments objectAtIndex:2];
  NSString *password = [command.arguments objectAtIndex:3];
  NSString *userId = [command.arguments objectAtIndex:4];
  NSString *cameraHelpText = [command.arguments objectAtIndex:5];

  IDCSettings *settings = [[IDCSettings alloc] init];
  
  settings.webUserId = @0;
  settings.agent = agent;
  settings.devAPIToken = devAPIToken;
  settings.clientRef = clientRef;
  settings.password = password;
  _cameraHelpText = cameraHelpText;

  // slightly ardrous
  NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
  [f setNumberStyle:NSNumberFormatterDecimalStyle];
  settings.userId = [f numberFromString:userId];
  
  settings.isUsingAutoCapture = YES;
  
  [[IDCheckerSDK shared] loadWithSettings:settings block:^(NSError *error) {
    if(!error) {
      // should do something intelligent here
    }
  }];
}

- (void)pollAndGrabData
{
  WEAK_SELF();
  // Start polling for more data
  [[IDCheckerSDK shared] startPollingForMoreAccurateData:self.document pollingResultBlock:^(IDCDocument *result) {
    STRONG_SELF();

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
    if (result.doB) [dict setObject:[[CDVIDChecker dateFormatter] stringFromDate:result.doB] forKey:@"DOB"];
    if (result.expDate) [dict setObject:[[CDVIDChecker dateFormatter] stringFromDate:result.expDate] forKey:@"Expiration"];
    if (result.countryResultAbbrevation) [dict setObject:result.countryResultAbbrevation forKey:@"Country"];
    if (result.socialSecurityNumber) [dict setObject:result.socialSecurityNumber forKey:@"SSN"];
    if (result.documentNumber) [dict setObject:result.documentNumber forKey:@"DocumentNumber"];
    if (result.issueDate) [dict setObject:[[CDVIDChecker dateFormatter] stringFromDate:result.issueDate] forKey:@"IssueDate"];
    if (passPhoto64) [dict setObject:passPhoto64 forKey:@"PassPhoto"];
    if (origImage64) [dict setObject:origImage64 forKey:@"OrigPhoto"];
    if (processed64) [dict setObject:processed64 forKey:@"ProcessedPhoto"];
    if (result.nationality) [dict setObject:result.nationality forKey:@"Nationality"];
    if (result.guid) [dict setObject:result.guid forKey:@"GUID"];
    
    _self.frontDoc = NULL;
    _self.backDoc = NULL;
    _self.document = NULL;
    
    [_self showWait:NO];
    
    // build result into data structure to return via callback
    CDVPluginResult *res = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dict];
    [self.commandDelegate sendPluginResult:res callbackId:_callbackId];
  }];
}

- (void)finishSession
{
  WEAK_SELF();
  
  [[IDCheckerSDK shared] closeRecordForGuid:self.guid block:^(NSError *error) {
    STRONG_SELF();
    
    if (error) {
      [_self showWait:NO];
      
      // Call error callback
      CDVPluginResult *res = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
      [_self.commandDelegate sendPluginResult:res callbackId:_callbackId];
    }
    else {
      [_self pollAndGrabData];
    }
  }];
}

- (void)setIsUploadBackColorImageDone:(BOOL)isUploadBackColorImageDone
{
  _isUploadBackColorImageDone = isUploadBackColorImageDone;
  if(_isUploadBackColorImageDone && _isUploadFrontColorImageDone) {
    [self finishSession];
  }
}

- (void)setIsUploadFrontColorImageDone:(BOOL)isUploadFrontColorImageDone
{
  _isUploadFrontColorImageDone = isUploadFrontColorImageDone;
  
  if (_docType == kIDCDocType2DBarcode || _docType == kIDCDocTypePassport) {
    [self finishSession];
  }
  else if(_isUploadBackColorImageDone && _isUploadFrontColorImageDone) {
    [self finishSession];
  }
}

- (void)uploadDocForOCR:(IDCDocument *)front back:(IDCDocument *)back
{
  WEAK_SELF();
  
  [self showWait:true];
  
  [[IDCheckerSDK shared] openRecordWithBlock:^(NSString *guid, NSError *error) {
    STRONG_SELF();
    
    if (error) {
      [_self showWait:NO];
      
      // Call error callback
      CDVPluginResult *res = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
      [_self.commandDelegate sendPluginResult:res callbackId:_callbackId];
    }
    else {
      _self.guid = guid;
    
      IDCDocument *toProcess = front;
      toProcess.guid = _self.guid;
    
      [[IDCheckerSDK shared] uploadDocumentForOcr:toProcess ocrResultBlock:^(IDCDocument *doc) {
        STRONG_SELF();
        doc.docType = toProcess.docType;
        doc.originalImage = toProcess.originalImage;
        doc.passPhoto = toProcess.passPhoto;
        _self.document = doc;
        
        [[IDCheckerSDK shared] uploadColorImageForIDCProcessing:front.originalImage guid:_self.guid block:^(NSError *error) {
          if (error) {
            [_self showWait:NO];
            
            // Call error callback
            CDVPluginResult *res = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
            [_self.commandDelegate sendPluginResult:res callbackId:_callbackId];
          }
          else {
            [_self setIsUploadFrontColorImageDone:YES];
          }
        }];
        
        if (back) {
          [[IDCheckerSDK shared] uploadColorImageForIDCProcessing:back.originalImage guid:_self.guid block:^(NSError *error) {
            if (error) {
              [_self showWait:NO];
              
              // Call error callback
              CDVPluginResult *res = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
              [_self.commandDelegate sendPluginResult:res callbackId:_callbackId];
            }
            else {
              [_self setIsUploadBackColorImageDone:YES];
            }
          }];
        }
      }];
    }
  }];
}

- (void)presentCameraForButton:(CDVInvokedUrlCommand *)command
{
  NSString *country = [command.arguments objectAtIndex:0];
  NSString *type = [command.arguments objectAtIndex:1];
  
  // starting anew
  self.frontDoc = NULL;
  self.backDoc = NULL;
  
  _callbackId = command.callbackId;
  
  if ([type isEqualToString:@"DriversLicense"]) {
    _docType = kIDCDocTypeDriversLicense;
  } else if ([type isEqualToString:@"2DBarCode"] || [type isEqualToString:@"2DBarcode"]) {
    _docType = kIDCDocType2DBarcode;
  } else {
    _docType = kIDCDocTypePassport;
  }
  
  switch (_docType) {
    case kIDCDocTypeDriversLicense:
    case kIDCDocType2DBarcode:
      _quality = kIDCQualityTypeHigh;
      break;
    default:
      _quality = kIDCQualityTypeMedium;
      break;
  }
  
  if (_docType == kIDCDocTypeDriversLicense) {
    [self captureFrontAndBack:command];
  }
  else {
    [self captureFront:command];
  }
}

- (void)captureFront:(CDVInvokedUrlCommand *)command
{
  WEAK_SELF();
  
  NSString *title;
  NSString *message;
  
  IDCDocument *doc = [[IDCDocument alloc] initWithDocType:_docType country:@""];
  switch (_docType) {
    case kIDCDocTypePassport:
      doc.documentDimensions = CGSizeMake(125.f, 88.f);
      title = @"Scan Passport";
      message = @"Scan Passport Identification";
      break;
    default:
      doc.documentDimensions = CGSizeMake(85.6, 54.f);
      title = @"Scan Back";
      message = @"Scan Back of Identification";
      break;
  }
  
  // display alert message to capture the back of the driver's license
  UIAlertView *av = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
  [av show];
  
  [[IDCheckerSDK shared] takePicture:doc viewControllerToPresent:self.viewController quality:_quality pictureTakenBlock:^(IDCDocument *result) {
    STRONG_SELF();
    [_self showWait:TRUE];
    
    _self.frontDoc = doc;
    
    [_self.viewController dismissViewControllerAnimated:true completion:^{
      [_self uploadDocForOCR:_self.frontDoc back:NULL];
    }];
  }];
}

- (void)captureFrontAndBack:(CDVInvokedUrlCommand *)command
{
  WEAK_SELF();
  IDCDocument *doc = [[IDCDocument alloc] initWithDocType:_docType country:@""];
  switch (_docType) {
    case kIDCDocTypePassport:
      doc.documentDimensions = CGSizeMake(125.f, 88.f);
      break;
    default:
      doc.documentDimensions = CGSizeMake(85.6, 54.f);
      break;
  }
  
  // display alert message to capture the back of the driver's license
  UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Scan Front" message:@"Scan Front of Identificaion" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
  [av show];

  // get the front first
  [[IDCheckerSDK shared] takePicture:doc viewControllerToPresent:self.viewController quality:_quality pictureTakenBlock:^(IDCDocument *result) {
    STRONG_SELF();
    _self.frontDoc = doc;
   
    [_self.viewController dismissViewControllerAnimated:true completion:^{
      [_self captureBack];
    }];
  }];
}

- (void)captureBack
{
  WEAK_SELF();
  
  // display alert message to capture the back of the driver's license
  UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Scan Back" message:@"Scan Back of Identification" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
  [av show];

  IDCDocument *docBack = [[IDCDocument alloc] initWithDocType:_docType country:@""];
  switch (_docType) {
    case kIDCDocTypePassport:
      docBack.documentDimensions = CGSizeMake(125.f, 88.f);
      break;
    default:
      docBack.documentDimensions = CGSizeMake(85.6, 54.f);
      break;
  }

  [[IDCheckerSDK shared] takePicture:docBack viewControllerToPresent:self.viewController quality:_quality pictureTakenBlock:^(IDCDocument *result) {
    STRONG_SELF();
    _self.backDoc = docBack;
    [_self showWait:TRUE];
    
    [_self.viewController dismissViewControllerAnimated:true completion:^{
      [_self uploadDocForOCR:_self.frontDoc back:_self.backDoc];
    }];
  }];
}


- (void)showWait:(BOOL)show
{
  [UIView animateWithDuration:.2 animations:^{
    _waitView.alpha = show ? 1.f : 0.f;
  }];
}

+ (NSDateFormatter *)dateFormatter
{
  static NSDateFormatter *result = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    result = [[NSDateFormatter alloc] init];
    [result setFormatterBehavior:NSDateFormatterBehavior10_4];
    result.dateStyle = NSDateFormatterMediumStyle;
    result.timeStyle = NSDateFormatterNoStyle;
    result.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    
  });
  return result;
}


@end
