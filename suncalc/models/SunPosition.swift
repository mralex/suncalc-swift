//
//  SunPosition.swift
//  suncalc-example
//
//  Created by Shaun Meredith on 10/2/14.
//  Copyright (c) 2014 Chimani, LLC. All rights reserved.
//

import Foundation

open class SunPosition {
	open var azimuth:Double
	open var altitude:Double
    open var date: Date = Date()
    
    open var azimuthDec:Double {
        return azimuth * 180 / .pi
    }
    open var altitudeDec:Double {
        return altitude * 180 / .pi
    }
	
    init(azimuth:Double, altitude:Double) {
		self.azimuth = azimuth
		self.altitude = altitude
	}
}
