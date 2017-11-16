//
//  MoonIllumination.swift
//  suncalc-example
//
//  Created by Shaun Meredith on 10/2/14.
//  Copyright (c) 2014 Chimani, LLC. All rights reserved.
//

import Foundation

open class MoonIllumination {
	open var fraction:Double
	open var phase:Double
	open var angle:Double
	
    init(fraction:Double, phase:Double, angle:Double) {
		self.fraction = fraction
		self.phase = phase
		self.angle = angle
	}
	
}
