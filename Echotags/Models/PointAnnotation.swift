//
//  PointAnnotation.swift
//  Echotags
//
//  Created by bkzl on 27/06/16.
//  Copyright © 2016 Bartłomiej Kozal. All rights reserved.
//

import Mapbox

class PointAnnotation: MGLPointAnnotation {
    var audio: String?
    var color = "red"
    var visited = false
    
    init(fromPoint point: Point) {
        super.init()
        
        coordinate = CLLocationCoordinate2D(latitude: point.latitude, longitude: point.longitude)
        title = point.title
        audio = point.audio
        color = point.color
        visited = point.visited
    }
}
