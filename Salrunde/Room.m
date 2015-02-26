//
//  Room.m
//  Salrunde
//
//  Created by Jan Matias Ørstavik on 23/01/15.
//  Copyright (c) 2015 Jan Matias Ørstavik. All rights reserved.
//

#import "Room.h"

@implementation Room

+(Room *)roomWithName:(NSString *)name Building: (NSString *)building ID: (NSString *)ID A4:(BOOL)A4 A3:(BOOL)A3 svart:(BOOL)svart farge:(BOOL)farge kortleser:(BOOL)kortleser xero:(BOOL)xero fuser:(BOOL)fuser
{
	Room *r = [[Room alloc] init];
	r.name = name;
	r.building = building;
	r.ID = ID;
	r.A4 = A4;
	r.A3 = A3;
	r.svart = svart;
	r.farge = farge;
	r.kortleser = kortleser;
	r.xero = xero;
	r.fuser = fuser;
	r.useLLF = NO;
	
	r.lager = NO;
	r.tynnklient = NO;
	return r;
}

+(Room *)roomWithName: (NSString *)name Building: (NSString *)building Lat: (NSString *)latitude Long: (NSString *)longitude Floor: (NSString *)floor A4:(BOOL) A4 A3:(BOOL) A3 svart: (BOOL) svart farge: (BOOL) farge kortleser: (BOOL) kortleser xero:(BOOL)xero fuser:(BOOL)fuser
{
	Room *r = [[Room alloc] init];
	r.name = name;
	r.building = building;
	r.latitude = latitude;
	r.longitude = longitude;
	r.floor = floor;
	r.A4 = A4;
	r.A3 = A3;
	r.svart = svart;
	r.farge = farge;
	r.kortleser = kortleser;
	r.xero = xero;
	r.fuser = fuser;
	r.useLLF = YES;
	
	r.lager = NO;
	r.tynnklient = NO;
	return r;
}

+(Room *)lagerWithName:(NSString *)name Building: (NSString *)building ID: (NSString *)ID A4:(BOOL) A4 A3:(BOOL) A3 svart: (BOOL) svart farge: (BOOL) farge
{
	Room *r = [[Room alloc] init];
	r.name = name;
	r.building = building;
	r.ID = ID;
	r.A4 = A4;
	r.A3 = A3;
	r.svart = svart;
	r.farge = farge;
	r.kortleser = NO;
	
	r.lager = YES;
	r.tynnklient = NO;
	return r;
}

+(Room *)lagerWithName: (NSString *)name Building: (NSString *)building Lat: (NSString *)latitude Long: (NSString *)longitude Floor: (NSString *)floor A4:(BOOL) A4 A3:(BOOL) A3 svart: (BOOL) svart farge: (BOOL) farge
{
	Room *r = [[Room alloc] init];
	r.name = name;
	r.building = building;
	r.latitude = latitude;
	r.longitude = longitude;
	r.floor = floor;
	r.A4 = A4;
	r.A3 = A3;
	r.svart = svart;
	r.farge = farge;
	r.useLLF = YES;
	
	r.lager = YES;
	r.tynnklient = NO;
	return r;
}

+(Room *)tynnklienterWithName:(NSString *)name Building: (NSString *)building
{
	Room *r = [[Room alloc] init];
	r.name = name;
	r.building = building;
	r.A4 = NO;
	r.A3 = NO;
	r.svart = NO;
	r.farge = NO;
	r.kortleser = NO;
	
	r.lager = NO;
	r.tynnklient = YES;
	return r;}

@end
