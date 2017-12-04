//
//  MoonTimes.swift
//  suncalc-example
//
//  Created by Alex Roberts on 12/3/17.
//

import Foundation

open class MoonTimes {
	open var moonrise:Date
  open var moonset:Date
	open var alwaysUp:Bool
	open var alwaysDown:Bool

  init(moonrise:Date, moonset:Date, alwaysUp:Bool, alwaysDown:Bool) {
		self.moonrise = moonrise
		self.moonset = moonset
		self.alwaysUp = alwaysUp
		self.alwaysDown = alwaysDown
	}

}
