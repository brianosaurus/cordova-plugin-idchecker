//
//  IDCDocument.h
//  IDCheckerSDK
//
//  Created by Michiel Boertjes on 5/31/13.
//  Copyright (c) 2013 IDChecker. All rights reserved.
//
#import "IDCTypeDefines.h"
#import <Foundation/Foundation.h>

@class IDCProcessResult;

@interface IDCDocument : NSObject

/**
 if a guid is provided, document will be added to same record
 if no guid is provided guid will be provided by the API
 */
@property (nonatomic, strong) NSString* guid;

//@property (nonatomic, assign) BOOL uploadedToIDC;

//startup params
@property (nonatomic, assign) IDCDocType docType;
@property (nonatomic, strong) NSString *country;

/**
 text will be shown to user for limited time when camera view is started
 */
@property (nonatomic, strong) NSString *cameraHelpText;

/**
dimensions ratio used for automaticly taking picture
 */
@property (nonatomic, assign) CGSize documentDimensions;

@property (nonatomic, strong) IDCProcessResult *processResult;

//add image
@property (nonatomic, strong) UIImage *originalImage;
@property (nonatomic, strong) UIImage *processedImage;
/*
 * This property will be set if a face was found on the original image
*/
@property (nonatomic, strong) UIImage *passPhoto;

//ocr result
@property (nonatomic, strong) NSError *error;
@property (nonatomic, strong) NSError *rejection;


@property (nonatomic, strong) NSString *clientRef;
@property (nonatomic, strong) NSString *fullName;
//all forenames
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *address1;
@property (nonatomic, strong) NSString *address2;

@property (nonatomic, strong) NSDate *doB;

@property (nonatomic, strong) NSString *personalNumber;
@property (nonatomic, assign) NSNumber *socialSecurityNumber;

@property (nonatomic, assign) IDCGenderType genderType;

@property (nonatomic, strong) NSString *nationality;

@property (nonatomic, strong) NSString *documentNumber;
@property (nonatomic, strong) NSString *docTypeDescription;
@property (nonatomic, strong) NSDate *expDate;
@property (nonatomic, strong) NSDate *issueDate;

@property (nonatomic, strong) NSString *countryResult;
@property (nonatomic, strong) NSString *countryResultAbbrevation;


- (id)initWithDocType:(IDCDocType)doctype country:(NSString *)country;

@end
