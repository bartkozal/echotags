//
//  Queries.swift
//  Echotags
//
//  Created by bkzl on 16/06/16.
//  Copyright © 2016 Bartłomiej Kozal. All rights reserved.
//

import RealmSwift

extension Point {
    static func findByTitle(title: String) -> Point? {
        return Database().db.objects(Point).filter("title = %@", title).first ?? nil
    }
    
    func markAsVisited() {
        try! Database().db.write {
            visited = true
        }
    }
}

extension Marker {
    static func visible() -> [Object] {
        return Database().db.objects(Marker).filter("category.visible = true").uniqueObject("point")
    }
    
    static func unvisited() -> [Object] {
        return Database().db.objects(Marker).filter("category.visible = true AND point.visited = false").uniqueObject("point")
    }
}

extension Category {
    static func all() -> Results<Category> {
        return Database().db.objects(Category)
    }
    
    static func findByName(name: String) -> Category? {
        return Database().db.objects(Category).filter("name = %@", name).first ?? nil
    }
    
    func updateVisibility(value: Bool) {
        try! Database().db.write {
            visible = value
        }
    }
}

extension Trigger {
    static func findById(id: String) -> Trigger? {
        return Database().db.objects(Trigger).filter("id = %@", id).first ?? nil
    }
}
