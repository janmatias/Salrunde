//
//  Generator.m
//  Salrunde
//
//  Created by Jan Matias Ørstavik on 22/01/15.
//  Copyright (c) 2015 Jan Matias Ørstavik. All rights reserved.
//

#import "Generator.h"
#import "NetworkHandler.h"
#import "Room.h"

@implementation Generator

-(NSString *)generate:(NSString *)location withNH:(id)nh
{
	NSArray *rooms;
	if ([location isEqualToString:@"Skranke"]){
		rooms = [nh getSkrankeRooms];
	}else if ([location isEqualToString:@"Delphi"]){
		rooms = [nh getDelphiRooms];
	}else{
		return @"";
	}
	
	rooms = [rooms sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"building" ascending:YES]]];
	
	NSMutableString *main = [[NSMutableString alloc] initWithString:@""];
	NSUserDefaults *d = [NSUserDefaults standardUserDefaults];
	
	main = [self generateTODO: rooms withDefaults: d];
	
	NSString *currentLoc = @"";
	
	for (int i = 0; i <[rooms count] ; i++) {
		Room *room = [rooms objectAtIndex:i];
		if (![currentLoc isEqualToString:room.building]){
			currentLoc = room.building;
			[main appendString:[NSString stringWithFormat:@"#%@\n", room.building]];
		}
		
	
		[main appendString:[NSString stringWithFormat:@"// %@\n", room.name]];
		
		if (room.tynnklient) {
			[main appendString:[NSString stringWithFormat:@"- %@\n\n", [d objectForKey:[NSString stringWithFormat:@"%@_kommentar", room.name]]]];
			continue;
		}
		
		if ([room.name isEqualToString:@"Real. Bib."]){
			NSString *kort;
			if ([(NSNumber *)[d objectForKey:[NSString stringWithFormat:@"%@_extra", room.name]] boolValue]){
				kort = @"OK!";
			}else{
				kort = @"Ikke OK!";
			}
			[main appendString:[NSString stringWithFormat:@"- Reapub: %@\n", kort]];
		}
		
		if (room.kortleser){
			NSString *kort;
			if ([(NSNumber *)[d objectForKey:[NSString stringWithFormat:@"%@_kortleser", room.name]] boolValue]){
				kort = @"OK!";
			}else{
				kort = @"Ikke OK!";
			}
			[main appendString:[NSString stringWithFormat:@"- Kortleser: %@\n", kort]];
		}
		
		if (room.svart) {
			[main appendString:[NSString stringWithFormat:@"- Svart toner: %@%%\n", [d objectForKey:[NSString stringWithFormat:@"%@_black", room.name]]]]; //SVART TONER
		}
		
		if (room.farge){
			[main appendString:[NSString stringWithFormat:@"- Cyan toner: %@%%\n", [d objectForKey:[NSString stringWithFormat:@"%@_cyan", room.name]]]];
			[main appendString:[NSString stringWithFormat:@"- Magenta toner: %@%%\n", [d objectForKey:[NSString stringWithFormat:@"%@_magenta", room.name]]]];
			[main appendString:[NSString stringWithFormat:@"- Yellow toner: %@%%\n", [d objectForKey:[NSString stringWithFormat:@"%@_yellow", room.name]]]];
		}else{
			if (room.xero){
				[main appendString:[NSString stringWithFormat:@"- Xerographic module: %@%%\n", [d objectForKey:[NSString stringWithFormat:@"%@_xero", room.name]]]];
			}
			if (room.fuser){
				[main appendString:[NSString stringWithFormat:@"- Fuser module: %@%%\n", [d objectForKey:[NSString stringWithFormat:@"%@_fuser", room.name]]]];
			}
		}
		if (room.A4) {
			[main appendString:[NSString stringWithFormat:@"- %@ x A4\n", (NSString*)[d objectForKey:[NSString stringWithFormat:@"%@_A4", room.name]]]];
		}
		
		if (room.A3){
			[main appendString:[NSString stringWithFormat:@"- %@ x A3\n", (NSString*)[d objectForKey:[NSString stringWithFormat:@"%@_A3", room.name]]]];
		}
		
		NSString *kommentar = (NSString *)[d objectForKey:[NSString stringWithFormat:@"%@_kommentar", room.name]];
		if ([room.name isEqualToString:@"Sahara"] && [kommentar isEqualToString:@"Alt OK!"]){
			[main appendString:[NSString stringWithFormat:@"- %@\n\n", kommentar]];
		}else if (![kommentar isEqualToString:@""]){
			[main appendString:[NSString stringWithFormat:@"- Kommentar:\n%@\n\n", kommentar]];
		}else{
			[main appendString:@"\n"];
		}
	}
	
	return main;
}

-(NSMutableString *)generateTODO:(NSArray *)rooms withDefaults:(NSUserDefaults *)defaults
{
	BOOL appended = false;
	NSMutableString *main = [[NSMutableString alloc] initWithString:@"//Til neste salrunde: (MERK! Tar ikke forbehold om at andre kan ha tatt med eller bestilt fra før)\n"];
	for (int i = 0; i < [rooms count]; i++) {
		Room *room = [rooms objectAtIndex:i];
		
		if (![(NSNumber *)[defaults objectForKey:[NSString stringWithFormat:@"%@_kortleser", room.name]] boolValue] && !room.lager && room.kortleser){
			[main appendString:[NSString stringWithFormat: @"- Sjekk kortleser til %@\n", room.name]];
			appended = true;
		}
		
		NSString *fraktEllerBestill;
		NSString *A4 = ((NSString *)[defaults objectForKey:[NSString stringWithFormat:@"%@_A4", room.name]]);
		NSString *A3 = ((NSString *)[defaults objectForKey:[NSString stringWithFormat:@"%@_A3", room.name]]);
		
		NSString *black; NSString *cyan; NSString *magenta; NSString *yellow;
		NSInteger blackInt = 1337; NSInteger cyanInt = 1337; NSInteger magentaInt = 1337; NSInteger yellowInt = 1337; NSInteger xeroInt = 1337; NSInteger fuserInt = 1337;
		
		if (room.lager) {
			black = ((NSString *)[defaults objectForKey:[NSString stringWithFormat:@"%@_black", room.name]]);
			cyan = ((NSString *)[defaults objectForKey:[NSString stringWithFormat:@"%@_cyan", room.name]]);
			magenta = ((NSString *)[defaults objectForKey:[NSString stringWithFormat:@"%@_magenta", room.name]]);
			yellow = ((NSString *)[defaults objectForKey:[NSString stringWithFormat:@"%@_yellow", room.name]]);
			
			fraktEllerBestill = @"Bestill";
			
		}else{
			blackInt = [((NSNumber *)[((NSString *)[defaults objectForKey:[NSString stringWithFormat:@"%@_black", room.name]]) stringByReplacingOccurrencesOfString:@"%" withString:@""]) integerValue];
			cyanInt = [((NSNumber *)[((NSString *)[defaults objectForKey:[NSString stringWithFormat:@"%@_cyan", room.name]]) stringByReplacingOccurrencesOfString:@"%" withString:@""]) integerValue];
			magentaInt = [((NSNumber *)[((NSString *)[defaults objectForKey:[NSString stringWithFormat:@"%@_magenta", room.name]]) stringByReplacingOccurrencesOfString:@"%" withString:@""]) integerValue];
			yellowInt = [((NSNumber *)[((NSString *)[defaults objectForKey:[NSString stringWithFormat:@"%@_yellow", room.name]]) stringByReplacingOccurrencesOfString:@"%" withString:@""]) integerValue];
			xeroInt = [((NSNumber *)[((NSString *)[defaults objectForKey:[NSString stringWithFormat:@"%@_xero", room.name]]) stringByReplacingOccurrencesOfString:@"%" withString:@""]) integerValue];
			fuserInt = [((NSNumber *)[((NSString *)[defaults objectForKey:[NSString stringWithFormat:@"%@_fuser", room.name]]) stringByReplacingOccurrencesOfString:@"%" withString:@""]) integerValue];
			fraktEllerBestill = @"Ta med";
		}
		
		if ([room.name isEqualToString:@"Lerkendal H"]){
			if (([A4 isEqualToString:@"0"] || [A4 isEqualToString:@"<2"]) && room.A4) {
				[main appendString:[NSString stringWithFormat:@"- %@ A4 til %@\n", @"Bestill", @"Lerkendalsprinterene"]];
				appended = true;
			}
			
			if (([A3 isEqualToString:@"0"] || [A3 isEqualToString:@"<2"]) && room.A3) {
				[main appendString:[NSString stringWithFormat:@"- %@ A3 til %@\n", @"Bestill", @"Lerkendalsprinterene"]];
				appended = true;
			}

		}else if (![room.name isEqualToString:@"Lerkendal V"]){
			if (room.lager){
				if (([A4 isEqualToString:@"<10"]) && room.A4) {
					[main appendString:[NSString stringWithFormat:@"- %@ A4 til %@\n", fraktEllerBestill, room.name]];
					appended = true;
				}
				if (([A3 isEqualToString:@"<10"]) && room.A3) {
					[main appendString:[NSString stringWithFormat:@"- %@ A3 til %@\n", fraktEllerBestill, room.name]];
					appended = true;
				}
			}else{
				if (([A4 isEqualToString:@"0"] || [A4 isEqualToString:@"<2"]) && room.A4) {
					[main appendString:[NSString stringWithFormat:@"- %@ A4 til %@\n", fraktEllerBestill, room.name]];
					appended = true;
				}
				if (([A3 isEqualToString:@"0"] || [A3 isEqualToString:@"<2"]) && room.A3) {
					[main appendString:[NSString stringWithFormat:@"- %@ A3 til %@\n", fraktEllerBestill, room.name]];
					appended = true;
				}
			}
		}
		
		if (room.lager){
			if ([black isEqualToString:@"0"] || [black isEqualToString:@"<2"]) {
				[main appendString:[NSString stringWithFormat:@"- %@ svart toner til %@\n", fraktEllerBestill, room.name]];
				appended = true;
			}
			if ([cyan isEqualToString:@"0"] || [cyan isEqualToString:@"<2"]) {
				[main appendString:[NSString stringWithFormat:@"- %@ cyan toner til %@\n", fraktEllerBestill, room.name]];
				appended = true;
			}
			if ([magenta isEqualToString:@"0"] || [magenta isEqualToString:@"<2"]) {
				[main appendString:[NSString stringWithFormat:@"- %@ magenta toner til %@\n", fraktEllerBestill, room.name]];
				appended = true;
			}
			if ([yellow isEqualToString:@"0"] || [yellow isEqualToString:@"<2"]) {
				[main appendString:[NSString stringWithFormat:@"- %@ yellow toner til %@\n", fraktEllerBestill, room.name]];
				appended = true;
			}
			
		}else{
			if (blackInt < 10  && room.svart) {
				[main appendString:[NSString stringWithFormat:@"- %@ svart toner til %@\n", fraktEllerBestill, room.name]];
				appended = true;
			}
			if (cyanInt < 10 && room.farge) {
				[main appendString:[NSString stringWithFormat:@"- %@ cyan toner til %@\n", fraktEllerBestill, room.name]];
				appended = true;
			}
			if (magentaInt < 10 && room.farge) {
				[main appendString:[NSString stringWithFormat:@"- %@ magenta toner til %@\n", fraktEllerBestill, room.name]];
				appended = true;
			}
			if (yellowInt < 10 && room.farge) {
				[main appendString:[NSString stringWithFormat:@"- %@ yellow toner til %@\n", fraktEllerBestill, room.name]];
				appended = true;
			}
			if (xeroInt < 10 && room.xero) {
				[main appendString:[NSString stringWithFormat:@"- %@ xerographic module til %@\n", fraktEllerBestill, room.name]];
				appended = true;
			}
			if (fuserInt < 10 && room.fuser) {
				[main appendString:[NSString stringWithFormat:@"- %@ fuser module til %@\n", fraktEllerBestill, room.name]];
				appended = true;
			}
		}
		
	}
	
	if (!appended) {
		[main appendString:@"- Alt OK (dobbeltsjekk, app under testing...)\n\n"];
	}else{
		[main appendString:@"\n"];
	}
	
	return main;
}

@end
