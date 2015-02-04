//
//  Room.h
//  Salrunde
//
//  Created by Jan Matias Ørstavik on 23/01/15.
//  Copyright (c) 2015 Jan Matias Ørstavik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Room : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *building;
@property (strong, nonatomic) NSString *ID;

@property (nonatomic) BOOL A3;
@property (nonatomic) BOOL A4;
@property (nonatomic) BOOL svart;
@property (nonatomic) BOOL farge;
@property (nonatomic) BOOL xero;
@property (nonatomic) BOOL fuser;
@property (nonatomic) BOOL kortleser;
@property (nonatomic) BOOL lager;
@property (nonatomic) BOOL tynnklient;
@property (nonatomic) BOOL useLLF;
@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *longitude;
@property (strong, nonatomic) NSString *floor;


+(Room *)roomWithName: (NSString *)name Building: (NSString *)building ID: (NSString *)ID A4:(BOOL) A4 A3:(BOOL) A3 svart: (BOOL) svart farge: (BOOL) farge kortleser: (BOOL) kortleser xero: (BOOL) xero fuser: (BOOL) fuser;

+(Room *)roomWithName: (NSString *)name Building: (NSString *)building Lat: (NSString *)latitude Long: (NSString *)longitude Floor: (NSString *)floor A4:(BOOL) A4 A3:(BOOL) A3 svart: (BOOL) svart farge: (BOOL) farge kortleser: (BOOL) kortleser xero: (BOOL) xero fuser: (BOOL) fuser;

+(Room *)lagerWithName: (NSString *)name Building: (NSString *)building ID: (NSString *)ID A4:(BOOL) A4 A3:(BOOL) A3 svart: (BOOL) svart farge: (BOOL) farge;

+(Room *)lagerWithName: (NSString *)name Building: (NSString *)building Lat: (NSString *)latitude Long: (NSString *)longitude Floor: (NSString *)floor A4:(BOOL) A4 A3:(BOOL) A3 svart: (BOOL) svart farge: (BOOL) farge;

+(Room *)tynnklienterWithName: (NSString *)name Building: (NSString *)building;

@end