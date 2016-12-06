//
//  ViewController.swift
//  suncalc-example
//
//  Created by Shaun Meredith on 10/2/14.
//  Copyright (c) 2014 Chimani, LLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	@IBOutlet weak var timeLabel: UILabel!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		let date:Date = Date()
		let sunCalc:SunCalc = SunCalc.getTimes(date, latitude: 51.5, longitude: -0.1)
		
		let formatter:DateFormatter = DateFormatter()
		formatter.dateFormat = "HH:mm"
		formatter.timeZone = TimeZone(abbreviation: "GMT")
		let sunriseString:String = formatter.string(from: sunCalc.sunrise)
		timeLabel.text = sunriseString
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

