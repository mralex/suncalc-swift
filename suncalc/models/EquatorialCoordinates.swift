//
//  EquatorialCoordinates.swift
//  suncalc-example
//
//  Created by Shaun Meredith on 10/2/14.
//  Copyright (c) 2014 Chimani, LLC. All rights reserved.
//

import Foundation

open class EquatorialCoordinates {
	open var rightAscension:Double
	open var declination:Double
	
	init(rightAscension:Double, declination:Double) {
		self.rightAscension = rightAscension
		self.declination = declination
	}
}
