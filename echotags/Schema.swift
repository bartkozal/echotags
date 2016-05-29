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

class Point: Object {
    dynamic var title: String?
    dynamic var latitude = 0.0
    dynamic var longitude = 0.0
    let triggers = List<Trigger>()
}

class Marker: Object {
    dynamic var point: Point?
    dynamic var category: Category?
    
    static func visible() -> [Object] {
        return Data.db.objects(Marker).filter("category.visible = true").uniqueObject("point")
    }
}

class Category: Object {
    dynamic var title: String?
    dynamic var visible = true
    
    static func all() -> Results<Category> {
        return Data.db.objects(Category)
    }
    
    static func findByTitle(title: String) -> Category? {
        return Data.db.objects(Category).filter("title = %@", title).first ?? nil
    }
    
    func updateVisibility(value: Bool) {
        try! Data.db.write {
            visible = value
        }
    }
}

class Trigger: Object {
    dynamic var latitude = 0.0
    dynamic var longitude = 0.0
}