//
//  Queries.swift
//  Echotags
//
//  Created by bkzl on 16/06/16.
//  Copyright © 2016 Bartłomiej Kozal. All rights reserved.
//

import CoreLocation
import RealmSwift

extension Point {
    static func findBy(title: String) -> Point? {
        return Database().db.objects(Point.self).filter("title = %@", title).first ?? nil
    }
    
    static func markAllAsUnvisited() {
        let points = Database().db.objects(Point.self)
        try! Database().db.write {
            points.setValue(false, forKeyPath: "visited")
        }
    }
    
    static func unvisited() -> Results<Point> {
        return Database().db.objects(Point.self).filter("visited = true")
    }
    
    func markAsVisited() {
        try! Database().db.write {
            visited = true
        }
    }
}

extension Marker {
    static func visible() -> [Object] {
        return Database().db.objects(Marker.self).filter("category.visible = true").uniqueObject("point")
    }
    
    static func nearby(location: CLLocationCoordinate2D) -> [Object] {
        let range = 0.0015
        let minLat = location.latitude - range
        let maxLat = location.latitude + range
        let minLng = location.longitude - range
        let maxLng = location.longitude + range
        
        return Database().db.objects(Marker.self).filter("category.visible = true AND point.visited = false AND point.latitude BETWEEN {%@, %@} AND point.longitude BETWEEN {%@, %@}", minLat, maxLat, minLng, maxLng).uniqueObject("point")
    }
}

extension Category {
    static func all() -> Results<Category> {
        return Database().db.objects(Category.self)
    }
    
    static func findBy(name: String) -> Category? {
        return Database().db.objects(Category.self).filter("name = %@", name).first ?? nil
    }
    
    func updateVisibility(to value: Bool) {
        try! Database().db.write {
            visible = value
        }
    }
}

extension Trigger {
    static func findBy(id: String) -> Trigger? {
        return Database().db.objects(Trigger.self).filter("id = %@", id).first ?? nil
    }
}
