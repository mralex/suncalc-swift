//
//  MoonPosition.swift
//  suncalc-example
//
//  Created by Shaun Meredith on 10/2/14.
//  Copyright (c) 2014 Chimani, LLC. All rights reserved.
//

import Foundation

open class MoonPosition {
	open var azimuth:Double
	open var altitude:Double
	open var distance:Double
	
    init(azimuth:Double, altitude:Double, distance:Double) {
		self.azimuth = azimuth
		self.altitude = altitude
		self.distance = distance
	}
}
