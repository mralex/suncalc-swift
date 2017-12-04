//
//  suncalc.swift
//  suncalc
//
//  Created by Shaun Meredith on 10/2/14.
//  Copyright (c) 2014 Chimani, LLC. All rights reserved.
//
//

import Foundation

open class SunCalc {
	let J0:Double = 0.0009

	open var sunrise:Date
	open var sunriseEnd:Date
	open var goldenHourEnd:Date
	open var solarNoon:Date
	open var goldenHour:Date
	open var sunsetStart:Date
	open var sunset:Date
	open var dusk:Date
	open var nauticalDusk:Date
	open var night:Date
	open var nadir:Date
	open var nightEnd:Date
	open var nauticalDawn:Date
	open var dawn:Date
	open var blueHourEnd:Date
	open var blueHour:Date

	open class func getSetJ(_ h:Double, phi:Double, dec:Double, lw:Double, n:Double, M:Double, L:Double) -> Double {
		let w:Double = TimeUtils.getHourAngleH(h, phi: phi, d: dec)
		let a:Double = TimeUtils.getApproxTransitHt(w, lw: lw, n: n)

		return TimeUtils.getSolarTransitJDs(a, M: M, L: L)
	}

	open class func getTimes(_ date:Date, latitude:Double, longitude:Double) -> SunCalc {
		return SunCalc(date:date, latitude:latitude, longitude:longitude)
	}

	open class func getSunPosition(_ timeAndDate:Date, latitude:Double, longitude:Double) -> SunPosition {
		let lw:Double = Constants.RAD() * -longitude
		let phi:Double = Constants.RAD() * latitude
		let d:Double = DateUtils.toDays(timeAndDate)

		let c:EquatorialCoordinates = SunUtils.getSunCoords(d)
		let H:Double = PositionUtils.getSiderealTimeD(d, lw: lw) - c.rightAscension

		return SunPosition(azimuth: PositionUtils.getAzimuthH(H, phi: phi, dec: c.declination), altitude: PositionUtils.getAltitudeH(H, phi: phi, dec: c.declination))
	}

	open class func getMoonPosition(_ timeAndDate:Date, latitude:Double, longitude:Double) -> MoonPosition {
		let lw:Double = Constants.RAD() * -longitude
		let phi:Double = Constants.RAD() * latitude
		let d:Double = DateUtils.toDays(timeAndDate)

		let c:GeocentricCoordinates = MoonUtils.getMoonCoords(d)
		let H:Double = PositionUtils.getSiderealTimeD(d, lw: lw) - c.rightAscension
		var h:Double = PositionUtils.getAltitudeH(H, phi: phi, dec: c.declination)

		// altitude correction for refraction
		h = h + Constants.RAD() * 0.017 / tan(h + Constants.RAD() * 10.26 / (h + Constants.RAD() * 5.10));

		return MoonPosition(azimuth: PositionUtils.getAzimuthH(H, phi: phi, dec: c.declination), altitude: h, distance: c.distance)
	}

	open class func getMoonIllumination(_ timeAndDate:Date) -> MoonIllumination {
		let d:Double = DateUtils.toDays(timeAndDate)
		let s:EquatorialCoordinates = SunUtils.getSunCoords(d)
		let m:GeocentricCoordinates = MoonUtils.getMoonCoords(d)

		let sdist:Double = 149598000; // distance from Earth to Sun in km

		let phi:Double = acos(sin(s.declination) * sin(m.declination) + cos(s.declination) * cos(m.declination) * cos(s.rightAscension - m.rightAscension))
		let inc:Double = atan2(sdist * sin(phi), m.distance - sdist * cos(phi))
		let angle:Double = atan2(cos(s.declination) * sin(s.rightAscension - m.rightAscension), sin(s.declination) * cos(m.declination) - cos(s.declination) * sin(m.declination) * cos(s.rightAscension - m.rightAscension))

		let fraction:Double = (1 + cos(inc)) / 2
		let phase:Double = 0.5 + 0.5 * inc * (angle < 0 ? -1 : 1) / Constants.PI()

		return MoonIllumination(fraction: fraction, phase: phase, angle: angle)
	}

	// calculations for moon rise/set times are based on http://www.stargazing.net/kepler/moonrise.html article

	open func getMoonTimes(_ timeAndDate:Date, latitude:Double, longitude:Double) -> MoonTimes {
		let t = Calendar.current.startOfDay(for: timeAndDate)

		let hc:Double = 0.133 * Constants.RAD()

		var hc = 0.133 * rad
    var h0 = SunCalc.getMoonPosition(t, latitude, longitude).altitude - hc,
        h1:Double, h2:Double, moonrise:Double, moonset:Double, a:Double, b:Double, xe:Double, ye:Double, d:Double, roots:Double, x1:Double, x2:Double, dx:Double

		for i in stride(from: 1, to: 24, by: 2) {
			h1 = SunCalc.getMoonPosition(DateUtils.hoursLater(t, i), latitude, longitude).altitude - hc
			h2 = SunCalc.getMoonPosition(DateUtils.hoursLater(t, i + 1), latitude, longitude).altitude - hc

			a = (h0 + h2) / 2 - h1
			b = (h2 - h0) / 2
			xe = -b / (2 * a)
			ye = (a * xe + b) * xe + h1
			d = b * b - 4 * a * h1
			roots = 0

			if (d >= 0) {
					dx = sqrt(d) / (abs(a) * 2)
					x1 = xe - dx
					x2 = xe + dx
					if (abs(x1) <= 1) roots += 1
					if (abs(x2) <= 1) roots += 1
					if (x1 < -1) x1 = x2

					if (roots === 1) {
	            if (h0 < 0) moonrise = i + x1
	            else moonset = i + x1

	        } else if (roots === 2) {
	            moonrise = i + (ye < 0 ? x2 : x1)
	            moonset = i + (ye < 0 ? x1 : x2)
	        }

	        if (rise && set) break

	        h0 = h2
			}

			var alwaysUp = false
			var alwaysDown = false

			if (!moonrise && !moonset) {
				if ye > 0 {
					alwaysUp = true
				} else {
					alwaysDown = true
				}
			}

			return MoonTimes(DateUtils.hoursLater(t, moonrise), DateUtils.hoursLater(t, moonset), alwaysUp, alwaysDown)
		}
	}

	public init(date:Date, latitude:Double, longitude:Double) {
		let lw:Double = Constants.RAD() * -longitude
		let phi:Double = Constants.RAD() * latitude
		let d:Double = DateUtils.toDays(date)

		let n:Double = TimeUtils.getJulianCycleD(d, lw: lw)
		let ds:Double = TimeUtils.getApproxTransitHt(0, lw: lw, n: n)

		let M:Double = SunUtils.getSolarMeanAnomaly(ds)
		let L:Double = SunUtils.getEclipticLongitudeM(M)
		let dec:Double = PositionUtils.getDeclinationL(L, b: 0)

		let Jnoon:Double = TimeUtils.getSolarTransitJDs(ds, M: M, L: L)

		self.solarNoon = DateUtils.fromJulian(Jnoon)
		self.nadir = DateUtils.fromJulian(Jnoon - 0.5)

		// sun times configuration (angle, morning name, evening name)
		// unrolled the loop working on this data:
		// var times = [
		//             [-0.83, 'sunrise',       'sunset'      ],
		//             [ -0.3, 'sunriseEnd',    'sunsetStart' ],
		//             [   -6, 'dawn',          'dusk'        ],
		//             [  -12, 'nauticalDawn',  'nauticalDusk'],
		//             [  -18, 'nightEnd',      'night'       ],
		//             [    6, 'goldenHourEnd', 'goldenHour'  ]
		//             ];

		var h:Double = -0.83
		var Jset:Double = SunCalc.getSetJ(h * Constants.RAD(), phi: phi, dec: dec, lw: lw, n: n, M: M, L: L)
		var Jrise:Double = Jnoon - (Jset - Jnoon)

		self.sunrise = DateUtils.fromJulian(Jrise)
		self.sunset = DateUtils.fromJulian(Jset)

		h = -0.3;
		Jset = SunCalc.getSetJ(h * Constants.RAD(), phi: phi, dec: dec, lw: lw, n: n, M: M, L: L)
		Jrise = Jnoon - (Jset - Jnoon)
		self.sunriseEnd = DateUtils.fromJulian(Jrise)
		self.sunsetStart = DateUtils.fromJulian(Jset)

		h = -6;
		Jset = SunCalc.getSetJ(h * Constants.RAD(), phi: phi, dec: dec, lw: lw, n: n, M: M, L: L)
		Jrise = Jnoon - (Jset - Jnoon)
		self.dawn = DateUtils.fromJulian(Jrise)
		self.dusk = DateUtils.fromJulian(Jset)

		h = -12;
		Jset = SunCalc.getSetJ(h * Constants.RAD(), phi: phi, dec: dec, lw: lw, n: n, M: M, L: L)
		Jrise = Jnoon - (Jset - Jnoon)
		self.nauticalDawn = DateUtils.fromJulian(Jrise)
		self.nauticalDusk = DateUtils.fromJulian(Jset)

		h = -18;
		Jset = SunCalc.getSetJ(h * Constants.RAD(), phi: phi, dec: dec, lw: lw, n: n, M: M, L: L)
		Jrise = Jnoon - (Jset - Jnoon)
		self.nightEnd = DateUtils.fromJulian(Jrise)
		self.night = DateUtils.fromJulian(Jset)

		h = 6;
		Jset = SunCalc.getSetJ(h * Constants.RAD(), phi: phi, dec: dec, lw: lw, n: n, M: M, L: L)
		Jrise = Jnoon - (Jset - Jnoon)
		self.goldenHourEnd = DateUtils.fromJulian(Jrise)
		self.goldenHour = DateUtils.fromJulian(Jset)

		h = -4;
		Jset = SunCalc.getSetJ(h * Constants.RAD(), phi: phi, dec: dec, lw: lw, n: n, M: M, L: L)
		Jrise = Jnoon - (Jset - Jnoon)
		self.blueHourEnd = DateUtils.fromJulian(Jrise)
		self.blueHour = DateUtils.fromJulian(Jset)

	}
}
