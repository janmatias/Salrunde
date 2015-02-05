//
//  NetworkHandler.swift
//  Salrunde
//
//  Created by Jan Matias Ørstavik on 05/02/15.
//  Copyright (c) 2015 Jan Matias Ørstavik. All rights reserved.
//

import Foundation

class NetworkHandler {
	private var delphi, skranke : Array<Room>
	
	init(){
		delphi = Array<Room>()
		skranke = Array<Room>()
		initDelphiArray()
		initSkrankeArray()
	}
	
	
	func getDelphiCount()->Int{
		return delphi.count
	}
	
	func getSkrankeCount()->Int{
		return skranke.count
	}
	
	func getDelphiRooms()->Array<Room>{
		return delphi
	}
	
	func getSkrankeRooms()->Array<Room>{
		return skranke
	}
	
	func getDelphiNameForIndex(index : Int)->String{
		return delphi[index].name
	}
	
	func getSkrankeNameForIndex(index : Int)->String{
		return skranke[index].name
	}
	
	func getRoomForName(name : String)->Room?{
		for r in delphi{
			if (r.name == name){
				return r
			}
		}
		for r in skranke{
			if (r.name == name){
				return r
			}
		}
		return nil
	}
	
	
	// Private functions
	
	private func initDelphiArray(){
		delphi.append(Room(name: "Lerkendal H", building: "Lerkendalsbygget", ID: "38019", A4: true, A3: true, black: true, color: true, xero: false, fuser: false, cardReader: true, printerRoom: true, StorageRoom: false, computerRoom: false, activationClients: false, useCoordinatesForLocation: false, latitude: "", longitude: "", floor: ""))
		delphi.append(Room(name: "Lerkendal V", building: "Lerkendalsbygget", ID: "38019", A4: true, A3: true, black: true, color: true, xero: false, fuser: false, cardReader: true, printerRoom: true, StorageRoom: false, computerRoom: false, activationClients: false, useCoordinatesForLocation: false, latitude: "", longitude: "", floor: ""))
		delphi.append(Room(name: "Alkymi", building: "Realfagsbygget", ID: "33286", A4: true, A3: false, black: true, color: true, xero: false, fuser: false, cardReader: true, printerRoom: true, StorageRoom: false, computerRoom: false, activationClients: false, useCoordinatesForLocation: false, latitude: "", longitude: "", floor: ""))
		delphi.append(Room(name: "D1-102", building: "Realfagsbygget", ID: "36162", A4: true, A3: false, black: true, color: false, xero: true, fuser: true, cardReader: true, printerRoom: true, StorageRoom: false, computerRoom: false, activationClients: false, useCoordinatesForLocation: false, latitude: "", longitude: "", floor: ""))
		delphi.append(Room(name: "D1-185", building: "Realfagsbygget", ID: "36163", A4: true, A3: false, black: true, color: false, xero: true, fuser: true, cardReader: true, printerRoom: true, StorageRoom: false, computerRoom: false, activationClients: false, useCoordinatesForLocation: false, latitude: "", longitude: "", floor: ""))
		delphi.append(Room(name: "Meru", building: "Realfagsbygget", ID: "35481", A4: true, A3: true, black: true, color: true, xero: false, fuser: false, cardReader: true, printerRoom: true, StorageRoom: false, computerRoom: true, activationClients: false, useCoordinatesForLocation: false, latitude: "", longitude: "", floor: ""))
		delphi.append(Room(name: "Real. Bib", building: "Realfagsbygget", ID: "1053", A4: true, A3: false, black: true, color: false, xero: false, fuser: false, cardReader: true, printerRoom: true, StorageRoom: false, computerRoom: false, activationClients: false, useCoordinatesForLocation: false, latitude: "", longitude: "", floor: ""))
		delphi.append(Room(name: "RA2 - Lager", building: "Realfagsbygget", ID: "", A4: true, A3: true, black: true, color: true, xero: false, fuser: false, cardReader: false, printerRoom: false, StorageRoom: true, computerRoom: false, activationClients: false, useCoordinatesForLocation: true, latitude: "10.4042324", longitude: "63.4154574", floor: "2"))
		delphi.append(Room(name: "Kalahari", building: "Perleporten", ID: "52011", A4: true, A3: true, black: true, color: true, xero: false, fuser: false, cardReader: true, printerRoom: true, StorageRoom: false, computerRoom: false, activationClients: false, useCoordinatesForLocation: false, latitude: "", longitude: "", floor: ""))
		delphi.append(Room(name: "Sahara", building: "Perleporten", ID: "52012", A4: false, A3: false, black: false, color: false, xero: false, fuser: false, cardReader: false, printerRoom: false, StorageRoom: false, computerRoom: true, activationClients: false, useCoordinatesForLocation: false, latitude: "", longitude: "", floor: ""))
		delphi.append(Room(name: "PU-Labben", building: "Perleporten", ID: "52049", A4: true, A3: true, black: true, color: true, xero: false, fuser: false, cardReader: true, printerRoom: true, StorageRoom: false, computerRoom: false, activationClients: false, useCoordinatesForLocation: false, latitude: "", longitude: "", floor: ""))
		delphi.append(Room(name: "2-72B", building: "Materialteknisk", ID: "", A4: true, A3: true, black: true, color: true, xero: false, fuser: false, cardReader: true, printerRoom: true, StorageRoom: false, computerRoom: false, activationClients: false, useCoordinatesForLocation: true, latitude: "10.4096988", longitude: "63.4159922", floor: "2"))
	}
	
	private func initSkrankeArray(){
		skranke.append(Room(name: "P15 - 336", building: "P15", ID: "6223", A4: true, A3: false, black: true, color: false, xero: false, fuser: false, cardReader: true, printerRoom: true, StorageRoom: false, computerRoom: false, activationClients: false, useCoordinatesForLocation: false, latitude: "", longitude: "", floor: ""))
		skranke.append(Room(name: "P15 - 436", building: "P15", ID: "6233", A4: true, A3: false, black: true, color: false, xero: false, fuser: false, cardReader: true, printerRoom: true, StorageRoom: false, computerRoom: false, activationClients: false, useCoordinatesForLocation: false, latitude: "", longitude: "", floor: ""))
		skranke.append(Room(name: "P15 - 524 (Fraggle)", building: "P15", ID: "6239", A4: true, A3: true, black: true, color: true, xero: false, fuser: false, cardReader: true, printerRoom: true, StorageRoom: false, computerRoom: true, activationClients: false, useCoordinatesForLocation: false, latitude: "", longitude: "", floor: ""))
		/*skranke.append(Room(name: "P15 - 521 (Sprokkit)", building: "P15", ID: "6251", A4: true, A3: true, black: true, color: true, xero: false, fuser: false, cardReader: true, printerRoom: true, StorageRoom: false, computerRoom: true, activationClients: false, useCoordinatesForLocation: false, latitude: "", longitude: "", floor: ""))*/
		skranke.append(Room(name: "SB1 - 360", building: "SB1", ID: "33969", A4: true, A3: true, black: true, color: true, xero: false, fuser: false, cardReader: true, printerRoom: true, StorageRoom: false, computerRoom: false, activationClients: false, useCoordinatesForLocation: false, latitude: "", longitude: "", floor: ""))
		skranke.append(Room(name: "SB1 - 315", building: "SB1", ID: "33962", A4: true, A3: true, black: true, color: true, xero: false, fuser: false, cardReader: true, printerRoom: true, StorageRoom: false, computerRoom: false, activationClients: false, useCoordinatesForLocation: false, latitude: "", longitude: "", floor: ""))
		skranke.append(Room(name: "SB1 - 316", building: "SB1", ID: "33952", A4: true, A3: true, black: true, color: true, xero: false, fuser: false, cardReader: true, printerRoom: true, StorageRoom: false, computerRoom: false, activationClients: false, useCoordinatesForLocation: false, latitude: "", longitude: "", floor: ""))
		skranke.append(Room(name: "SB1 - 321", building: "SB1", ID: "34190", A4: true, A3: true, black: true, color: true, xero: false, fuser: false, cardReader: true, printerRoom: true, StorageRoom: false, computerRoom: false, activationClients: false, useCoordinatesForLocation: false, latitude: "", longitude: "", floor: ""))
		skranke.append(Room(name: "Ark. Bib.", building: "SB1", ID: "33889", A4: true, A3: true, black: true, color: true, xero: false, fuser: false, cardReader: true, printerRoom: true, StorageRoom: false, computerRoom: false, activationClients: false, useCoordinatesForLocation: false, latitude: "", longitude: "", floor: ""))
		skranke.append(Room(name: "Tynnklienter", building: "SB1 & SB2", ID: "", A4: false, A3: false, black: false, color: false, xero: false, fuser: false, cardReader: false, printerRoom: false, StorageRoom: false, computerRoom: false, activationClients: true, useCoordinatesForLocation: false, latitude: "", longitude: "", floor: ""))
		skranke.append(Room(name: "Metal. 114", building: "Metalurgibygget", ID: "36125", A4: true, A3: false, black: true, color: false, xero: false, fuser: false, cardReader: true, printerRoom: true, StorageRoom: false, computerRoom: false, activationClients: false, useCoordinatesForLocation: false, latitude: "", longitude: "", floor: ""))
		skranke.append(Room(name: "G112", building: "EL-bygget", ID: "29", A4: true, A3: false, black: true, color: true, xero: false, fuser: false, cardReader: true, printerRoom: true, StorageRoom: false, computerRoom: false, activationClients: false, useCoordinatesForLocation: false, latitude: "", longitude: "", floor: ""))
		skranke.append(Room(name: "G120", building: "EL-bygget", ID: "17", A4: true, A3: false, black: true, color: true, xero: false, fuser: false, cardReader: true, printerRoom: true, StorageRoom: false, computerRoom: false, activationClients: false, useCoordinatesForLocation: false, latitude: "", longitude: "", floor: ""))
		skranke.append(Room(name: "G128", building: "EL-bygget", ID: "7576", A4: true, A3: false, black: true, color: true, xero: false, fuser: false, cardReader: true, printerRoom: true, StorageRoom: false, computerRoom: false, activationClients: false, useCoordinatesForLocation: false, latitude: "", longitude: "", floor: ""))
	}
	
}