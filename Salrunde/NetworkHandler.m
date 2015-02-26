//
//  NetworkHandler.m
//  Salrunde
//
//  Created by Jan Matias Ørstavik on 19/01/15.
//  Copyright (c) 2015 Jan Matias Ørstavik. All rights reserved.
//

#import "NetworkHandler.h"

@interface NetworkHandler()

@property (strong, nonatomic) NSArray *delphi;
@property (strong, nonatomic) NSArray *skranke;

@end

@implementation NetworkHandler

-(instancetype)init
{
	self.delphi = @[[Room roomWithName:@"Lerkendal H" Building:@"Lerkendalsbygget" ID:@"38019" A4:YES A3:YES svart:YES farge:YES kortleser:YES xero:NO fuser:NO],
					[Room roomWithName:@"Lerkendal V" Building:@"Lerkendalsbygget" ID:@"38019" A4:YES A3:YES svart:YES farge:YES kortleser:YES xero:NO fuser:NO],
					[Room roomWithName:@"Alkymi" Building:@"Realfagsbygget" ID:@"33286" A4:YES A3:NO svart:YES farge:YES kortleser:YES xero:NO fuser:NO],
					[Room roomWithName:@"D1-102" Building:@"Realfagsbygget" ID:@"36162" A4:YES A3:NO svart:YES farge:NO kortleser:YES xero:YES fuser:YES],
					[Room roomWithName:@"D1-185" Building:@"Realfagsbygget" ID:@"36163" A4:YES A3:NO svart:YES farge:NO kortleser:YES xero:YES fuser:YES],
					[Room roomWithName:@"Meru" Building:@"Realfagsbygget" ID:@"35481" A4:YES A3:YES svart:YES farge:YES kortleser:YES xero:NO fuser:NO],
					[Room roomWithName:@"Real. Bib." Building:@"Realfagsbygget" ID:@"1053" A4:YES A3:NO svart:YES farge:NO kortleser:YES xero:NO fuser:NO],
					[Room roomWithName:@"Kalahari" Building:@"Perleporten" ID:@"52011" A4:YES A3:YES svart:YES farge:YES kortleser:YES xero:NO fuser:NO],
					[Room roomWithName:@"Sahara" Building:@"Perleporten" ID:@"52012" A4:NO A3:NO svart:NO farge:NO kortleser:NO xero:NO fuser:NO],
					[Room roomWithName:@"PU-Lab" Building:@"Perleporten" ID:@"52049" A4:YES A3:YES svart:YES farge:YES kortleser:YES xero:NO fuser:NO],
					[Room roomWithName:@"2-72B" Building:@"Materialteknisk" Lat:@"10.4096988" Long: @"63.4159922" Floor: @"2" A4:YES A3:YES svart:YES farge:YES kortleser:YES xero:NO fuser:NO],
					[Room lagerWithName:@"RA2 - Lager" Building: @"Realfagsbygget" Lat: @"10.4042324" Long: @"63.4154574" Floor: @"2" A4:YES A3:YES svart:YES farge:YES]
					];
	
	self.skranke = @[[Room roomWithName:@"P15 - 336" Building:@"P15" ID:@"6223" A4:YES A3:NO svart:YES farge:NO kortleser:YES xero:NO fuser:NO],
					 [Room roomWithName:@"P15 - 436" Building:@"P15" ID:@"6233" A4:YES A3:NO svart:YES farge:NO kortleser:YES xero:NO fuser:NO],
					 [Room roomWithName:@"P15 - 524" Building:@"P15" ID:@"6239" A4:YES A3:YES svart:YES farge:YES kortleser:YES xero:NO fuser:NO],
					 [Room roomWithName:@"SB1 - 360" Building:@"SB1" ID:@"33969" A4:YES A3:YES svart:YES farge:YES kortleser:YES xero:NO fuser:NO],
					 [Room roomWithName:@"SB1 - 315" Building:@"SB1" ID:@"33962" A4:YES A3:YES svart:YES farge:YES kortleser:YES xero:NO fuser:NO],
					 [Room roomWithName:@"SB1 - 316" Building:@"SB1" ID:@"33952" A4:YES A3:YES svart:YES farge:YES kortleser:YES xero:NO fuser:NO],
					 [Room roomWithName:@"SB1 - 321" Building:@"SB1" ID:@"34190" A4:YES A3:YES svart:YES farge:YES kortleser:YES xero:NO fuser:NO],
					 [Room tynnklienterWithName:@"Tynnklienter" Building:@"SB1 & SB2"],
					 [Room roomWithName:@"Ark. Bib." Building:@"SB1" ID:@"33889" A4:YES A3:YES svart:YES farge:YES kortleser:YES xero:NO fuser:NO],
					 [Room roomWithName:@"Metal. 114" Building:@"Metalurgibygget" ID:@"36125" A4:YES A3:NO svart:YES farge:NO kortleser:YES xero:NO fuser:NO],
					 [Room roomWithName:@"EL - G112" Building:@"EL-bygget" ID:@"29" A4:YES A3:NO svart:YES farge:YES kortleser: YES xero:NO fuser:NO],
					 [Room roomWithName:@"EL - G120" Building:@"EL-bygget" ID:@"17" A4:YES A3:NO svart:YES farge:YES kortleser: YES xero:NO fuser:NO],
					 [Room roomWithName:@"EL - G128" Building:@"EL-bygget" ID:@"7576" A4:YES A3:NO svart:YES farge:YES kortleser: YES xero:NO fuser:NO]
					 ];
	return self;
}

-(NSUInteger)getDelphiRows
{
	return [self.delphi count];
}

-(NSUInteger)getSkrankeRows
{
	return [self.skranke count];
}

-(NSArray *)getDelphiRooms
{
	return self.delphi;
}

-(NSArray *)getSkrankeRooms
{
	return self.skranke;
}

-(NSString *)getDelphiLabelForIndex:(NSInteger)index
{
	return ((Room *)[self.delphi objectAtIndex:index]).name;
}

-(NSString *)getSkrankeLabelForIndex:(NSInteger)index
{
	return ((Room *)[self.skranke objectAtIndex:index]).name;
}

-(Room *)getRoomForName:(NSString *)name
{
	Room *room;
	for (int i = 0; i < [self.delphi count]; i++) {
		room = [self.delphi objectAtIndex:i];
		if ([room.name isEqualToString:name]){
			return room;
		}
	}
	for (int i = 0; i < [self.skranke count]; i++) {
		room = [self.skranke objectAtIndex:i];
		if ([room.name isEqualToString:name]){
			return room;
		}
	}
	return nil;
}


@end
