//
//  Generator.swift
//  Salrunde
//
//  Created by Jan Matias Ørstavik on 05/02/15.
//  Copyright (c) 2015 Jan Matias Ørstavik. All rights reserved.
//

import Foundation

class Generator{
	
	func generate(location : String, nh : NetworkHandler) -> String{
		let defaults = NSUserDefaults.standardUserDefaults()
		var rooms : Array<Room>!
		switch location{
		case "skranke":
			rooms = nh.getSkrankeRooms()
			break
		case "delphi":
			rooms = nh.getDelphiRooms()
			break
		default:
			rooms = nil
			break;
		}
		
		if (rooms? == nil){
			return "ERROR, current location not defined.\nContact jan.m.orstavik@ntnu.no about this"
		}
		
		rooms!.sort({ $0.building > $1.building});
		
		var message = generateTODO(WithRooms: rooms, AndDefaults: defaults)
		
		var currentBuilding = ""
		for r in rooms{
			if (!(currentBuilding == r.building)){
				currentBuilding = r.building
				message += "#" + currentBuilding + "\n" }
			
			message += "// " + r.name + "\n"
			
			if r.activationClients {
				message += "- " + (defaults.objectForKey(r.name + "_comment") as String) + "\n\n"
				continue }
			
			if r.name == "Real. Bib." {
				let kort = (defaults.objectForKey(r.name + "_extraSwitch") as Bool) ? "OK!" : "Ikke OK!"
				message += "- Reapub: " + kort + "\n" }
			
			if r.cardReader {
				let kort = (defaults.objectForKey(r.name + "_cardReader") as Bool) ? "OK!" : "Ikke OK!"
				message += "- Kortleser: " + kort + "\n" }
			
			if r.black {
				message += "- Svart toner: " + (defaults.objectForKey(r.name + "_black") as String) + "%\n" }
			
			if r.color {
				message += "- Cyan toner: " + (defaults.objectForKey(r.name + "_cyan") as String) + "%\n"
				message += "- Magenta toner: " + (defaults.objectForKey(r.name + "_magenta") as String) + "%\n"
				message += "- Yellow toner: " + (defaults.objectForKey(r.name + "_yellow") as String) + "%\n" }
			else {
				if r.xero {
					message += "- Xerographic module: " + (defaults.objectForKey(r.name + "_xero") as String) + "%\n" }
				
				if r.fuser {
					message += "- Fuser module: " + (defaults.objectForKey(r.name + "_fuser") as String) + "%\n" } }

			if r.A4 {
				message += "- " + (defaults.objectForKey(r.name + "_A4") as String) + " x A4\n" }
			
			if r.A3 {
				message += "- " + (defaults.objectForKey(r.name + "_A3") as String) + " x A4\n" }
			
			let comment = defaults.objectForKey(r.name + "_comment") as String
			if r.name == "Sahara" && comment == "Alt OK!"{
				message += "- " + comment + "\n\n"
			}
			else if comment != "" {
				message += "- Kommentar:\n" + comment + "\n\n"
			}
			else{
				message += "\n"
			}
		}
		return message
	}
	
	
	private func generateTODO(WithRooms rooms : Array<Room>, AndDefaults defaults : NSUserDefaults) -> String{
		var message = ""
		
		
		return message
	}
	
	/*
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
	
	return main;*/
}