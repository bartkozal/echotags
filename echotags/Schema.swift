//
//  RealmSchema.swift
//  echotags
//
//  Created by bkzl on 22/05/16.
//  Copyright © 2016 bkzl. All rights reserved.
//

import RealmSwift

// Point has many Categories through Markers
// Category has many Points through Markers
// Point has many Triggers
// Trigger belongs to Point

class Point: Object {
    dynamic var title = ""
    dynamic var latitude = 0.0
    dynamic var longitude = 0.0
    dynamic var audio = ""
    dynamic var visited = false
    let triggers = List<Trigger>()
    
    static func findByTitle(title: String) -> Point? {
        return Database().db.objects(Point).filter("title = %@", title).first ?? nil
    }
}

class Marker: Object {
    dynamic var point: Point?
    dynamic var category: Category?
    
    static func visible() -> [Object] {
        return Database().db.objects(Marker).filter("category.visible = true").uniqueObject("point")
    }
}

class Category: Object {
    dynamic var name = ""
    dynamic var visible = true
    
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

class Trigger: Object {
    dynamic var latitude = 0.0
    dynamic var longitude = 0.0
    let point = LinkingObjects(fromType: Point.self, property: "triggers")
}
