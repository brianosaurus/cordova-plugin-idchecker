//
//  IDCTypeDefines.h
//  IDCheckerSDK
//
//  Created by Michiel Boertjes on 4/7/13.
//  Copyright (c) 2013 IDChecker. All rights reserved.
//


//TypeDocID TypeDocOmschrijving
//
//1                 Binnenlandse Identiteitskaart/Verblijfsdocument
//2                 ID kaart (formaat 105mm x 74mm)
//3                 ID kaart (credit card formaat)
//4                 Nationaal paspoort
//5                 Rijbewijs

@class IDCDocument;

typedef enum {
    kIDCDocTypeUnknown = 0,
    kIDCDocTypeDomesticIdCardOrGreencard,
    kIDCDocTypeIDCard105x74,
    kIDCDocTypeIDCardCreditCard,
    kIDCDocTypePassport,
    kIDCDocTypeDriversLicense,
    kIDCDocType2DBarcode,
    kIDCDocTypeCount
}IDCDocType;

typedef enum
{
    kIDCGenderTypeUnknown,
    kIDCGenderTypeMale,
    kIDCGenderTypeFemale,
}IDCGenderType;

typedef enum
{
    kIDCQualityTypeLow,
    kIDCQualityTypeMedium,
    kIDCQualityTypeHigh
}IDCQualityType;

typedef void (^IDCDocumentProcessedBlock)(IDCDocument *);