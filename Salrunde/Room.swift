//
//  Room.swift
//  Salrunde
//
//  Created by Jan Matias Ørstavik on 04/02/15.
//  Copyright (c) 2015 Jan Matias Ørstavik. All rights reserved.
//

import Foundation

class Room {
	
	// Boolean declarations
	let A4, A3, black, color, xero, fuser, cardReader : Bool
	let printerRoom, StorageRoom, computerRoom, activationClients : Bool
	let useCoordinatesForLocation : Bool
	
	// String declarations
	let name, building, ID, latitude, longitude, floor : String
	// Static initializers
	init(name : String, building : String, ID : String,  A4 : Bool, A3: Bool, black : Bool, color : Bool, xero : Bool, fuser : Bool, cardReader : Bool, printerRoom : Bool, StorageRoom : Bool, computerRoom : Bool, activationClients : Bool, useCoordinatesForLocation : Bool, latitude : String, longitude : String, floor : String){

		self.name = name
		self.building = building
		self.ID = ID
		self.A4 = A4
		self.A3 = A3
		self.black = black
		self.color = color
		self.xero = xero
		self.fuser = fuser
		self.cardReader = cardReader
		self.printerRoom = printerRoom
		self.StorageRoom = StorageRoom
		self.computerRoom = computerRoom
		self.activationClients = activationClients
		self.useCoordinatesForLocation = useCoordinatesForLocation
		self.latitude = latitude
		self.longitude = longitude
		self.floor = floor
	}
	
	
	
	
}