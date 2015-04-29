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
@property (nonatomic) BOOL black;
@property (nonatomic) BOOL color;
@property (nonatomic) BOOL xero;
@property (nonatomic) BOOL fuser;
@property (nonatomic) BOOL cardReader;
@property (nonatomic) BOOL storage;
@property (nonatomic) BOOL tynnklient;
@property (nonatomic) BOOL useLLF;
@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *longitude;
@property (strong, nonatomic) NSString *floor;


+(Room *)roomWithName: (NSString *)name Building: (NSString *)building ID: (NSString *)ID A4:(BOOL) A4 A3:(BOOL) A3 black: (BOOL) black color: (BOOL) color cardReader: (BOOL) cardReader xero: (BOOL) xero fuser: (BOOL) fuser;

+(Room *)roomWithName: (NSString *)name Building: (NSString *)building Lat: (NSString *)latitude Long: (NSString *)longitude Floor: (NSString *)floor A4:(BOOL) A4 A3:(BOOL) A3 black: (BOOL) black color: (BOOL) color cardReader: (BOOL) cardReader xero: (BOOL) xero fuser: (BOOL) fuser;

+(Room *)storageWithName: (NSString *)name Building: (NSString *)building ID: (NSString *)ID A4:(BOOL) A4 A3:(BOOL) A3 black: (BOOL) black color: (BOOL) color;

+(Room *)storageWithName: (NSString *)name Building: (NSString *)building Lat: (NSString *)latitude Long: (NSString *)longitude Floor: (NSString *)floor A4:(BOOL) A4 A3:(BOOL) A3 black: (BOOL) black color: (BOOL) color;

+(Room *)tynnklienterWithName: (NSString *)name Building: (NSString *)building;

@end