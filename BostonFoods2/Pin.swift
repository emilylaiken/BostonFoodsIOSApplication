//
//  Pin.swift
//  BostonFoods
//
//  Created by Emily Aiken on 11/29/15.
//  Copyright © 2015 Boston Foods. All rights reserved.
//

import UIKit
import MapKit

//Pin class, a kind of MKAnnotion (a map annotation)
class Pin: NSObject, MKAnnotation  {
    //Title will be displayed upon clicking pin
    var title: String?
    //Location objet has 2 coordinates for latitude and longitutde
    var coordinate: CLLocationCoordinate2D
    init(title: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
        let btn = UIButton(type: .DetailDisclosure)
    }
}