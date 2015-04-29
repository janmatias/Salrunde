//
//  Generator.m
//  Salrunde
//
//  Created by Jan Matias Ørstavik on 22/01/15.
//  Copyright (c) 2015 Jan Matias Ørstavik. All rights reserved.
//

#import "Generator.h"
#import "Room.h"
#import "Constants.h"

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
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	main = [self generateTODO: rooms withDefaults: defaults];
	
	NSString *currentLoc = @"";
	
	for (int i = 0; i <[rooms count] ; i++) {
		Room *room = [rooms objectAtIndex:i];
		BOOL ok = YES;
		if (![currentLoc isEqualToString:room.building]){
			currentLoc = room.building;
			[main appendFormat:@"#%@\n", room.building];
		}
	
		[main appendFormat:@"// %@\n", room.name];
		
		if (room.tynnklient) {
			[main appendFormat:@"- %@\n\n", [defaults objectForKey:[NSString stringWithFormat:@"%@_%@", room.name, kCommentKey]]];
			continue;
		}
		
		if ([room.name isEqualToString:@"Real. Bib."] && ![(NSNumber *)[defaults objectForKey:[NSString stringWithFormat:@"%@_%@", room.name, kExtraKey]] boolValue]){
			[main appendFormat:@"- Reapub: Ikke OK!\n"];
			ok = NO;
		}
		
		if (room.cardReader && ![(NSNumber *)[defaults objectForKey:[NSString stringWithFormat:@"%@_%@", room.name, kCardReaderKey]] boolValue]){
			[main appendFormat:@"- Kortleser: Ikke OK!\n"];
			ok = NO;
		}
		
		if (room.black && [[defaults objectForKey:[NSString stringWithFormat:@"%@_%@", room.name, kBlackKey]] isEqualToString:@"<10%"]) {
			[main appendFormat:@"- Black toner: <10%%\n"];
			ok = NO;
		}
		
		if (room.color){
			if ([[defaults objectForKey:[NSString stringWithFormat:@"%@_%@", room.name, kCyanKey]] isEqualToString:@"<10%"]){
				[main appendFormat:@"- Cyan toner: <10%%\n"];
				ok = NO;
			}
			if ([[defaults objectForKey:[NSString stringWithFormat:@"%@_%@", room.name, kMagentaKey]] isEqualToString:@"<10%"]){
				[main appendFormat:@"- Magenta toner: <10%%\n"];
				ok = NO;
			}
			if ([[defaults objectForKey:[NSString stringWithFormat:@"%@_%@", room.name, kYellowKey]] isEqualToString:@"<10%"]){
				[main appendFormat:@"- Yellow toner: <10%%\n"];
				ok = NO;
			}
		}else{
			NSString *xero = [defaults objectForKey:[NSString stringWithFormat:@"%@_%@", room.name, kXerographicModuleKey]];
			if (room.xero && [xero isEqualToString:@"<10%"]){
				[main appendFormat:@"- Xerographic module: %@\n", xero];
				ok = NO;
			}
			NSString *fuser = [defaults objectForKey:[NSString stringWithFormat:@"%@_%@", room.name, kFuserModuleKey]];
			if (room.fuser && [fuser isEqualToString:@"<10%"]){
				[main appendFormat:@"- Fuser module: %@\n", fuser];
				ok = NO;
			}
		}
		if (room.A4) {
			NSString *A4 = [defaults objectForKey:[NSString stringWithFormat:@"%@_%@", room.name, kA4Key]];
			[main appendFormat:@"- %@ x A4\n", A4];
			if ([A4 isEqualToString:@"0"] || [A4 isEqualToString: @"<2"]){
				ok = NO;
			}
		}
		
		if (room.A3){
			NSString *A3 = [defaults objectForKey:[NSString stringWithFormat:@"%@_%@", room.name, kA3Key]];
			[main appendFormat:@"- %@ x A3\n", A3];
			if ([A3 isEqualToString:@"0"] || [A3 isEqualToString: @"<2"]){
				ok = NO;
			}
		}
		
		NSString *kommentar = (NSString *)[defaults objectForKey:[NSString stringWithFormat:@"%@_%@", room.name, kCommentKey]];
		if ([room.name isEqualToString:@"Sahara"] && [kommentar isEqualToString:@"Alt OK!"]){
			[main appendFormat:@"- %@\n\n", kommentar];
		}else if (![kommentar isEqualToString:@""]){
			[main appendFormat:@"- Kommentar:\n%@\n\n", kommentar];
		}else if(ok){
			[main appendString:@"- Alt OK!\n\n"];
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
		
		if (![[defaults objectForKey:[NSString stringWithFormat:@"%@_%@", room.name, kCardReaderKey]] boolValue] && room.cardReader){
			[main appendFormat: @"- Sjekk kortleser til %@\n", room.name];
			appended = true;
		}
		if ([room.name isEqualToString:@"Real. Bib."] && ![[defaults objectForKey:[NSString stringWithFormat:@"%@_%@", room.name, kExtraKey]] boolValue]){
			[main appendFormat: @"- Sjekk reapub kortleser\n"];
			appended = true;
		}
		
		NSSet *set = [NSSet setWithObjects:@"<10%", @"<10", @"<2", @"0", nil];
		
		if (room.black && [set containsObject:[defaults objectForKey:[NSString stringWithFormat:@"%@_%@", room.name, kBlackKey]]]){
			appended = true;
			if (room.storage){
				[main appendFormat:@"- Bestill black toner til %@\n", room.name];
			}else{
				[main appendFormat:@"- Ta med black toner til %@\n", room.name];
			}
		}
		
		if (room.color && [set containsObject:[defaults objectForKey:[NSString stringWithFormat:@"%@_%@", room.name, kCyanKey]]]){
			appended = true;
			if (room.storage){
				[main appendFormat:@"- Bestill cyan toner til %@\n", room.name];
			}else{
				[main appendFormat:@"- Ta med cyan toner til %@\n", room.name];
			}
		}
		
		if (room.color && [set containsObject:[defaults objectForKey:[NSString stringWithFormat:@"%@_%@", room.name, kMagentaKey]]]){
			appended = true;
			if (room.storage){
				[main appendFormat:@"- Bestill magenta toner til %@\n", room.name];
			}else{
				[main appendFormat:@"- Ta med magenta toner til %@\n", room.name];
			}
		}
		
		if (room.color && [set containsObject:[defaults objectForKey:[NSString stringWithFormat:@"%@_%@", room.name, kYellowKey]]]){
			appended = true;
			if (room.storage){
				[main appendFormat:@"- Bestill yellow toner til %@\n", room.name];
			}else{
				[main appendFormat:@"- Ta med yellow toner til %@\n", room.name];
			}
		}
		
		if (room.A4 && [set containsObject:[defaults objectForKey:[NSString stringWithFormat:@"%@_%@", room.name, kA4Key]]]){
			appended = true;
			if (room.storage){
				[main appendFormat:@"- Bestill en pall A4 til %@\n", room.name];
			}else{
				[main appendFormat:@"- Ta med A4 til %@\n", room.name];
			}
		}
		
		if (room.A3 && [set containsObject:[defaults objectForKey:[NSString stringWithFormat:@"%@_%@", room.name, kA3Key]]]){
			appended = true;
			if (room.storage){
				[main appendFormat:@"- Bestill en pall A3 til %@\n", room.name];
			}else{
				[main appendFormat:@"- Ta med A3 til %@\n", room.name];
			}
		}
	}
	
	if (!appended) {
		[main appendString:@"- Alt OK\n\n"];
	}else{
		[main appendString:@"\n"];
	}
	
	return main;
}

@end
