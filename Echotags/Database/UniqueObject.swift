//
//  UniqueObject.swift
//  echotags
//
//  Created by bkzl on 30/05/16.
//  Copyright © 2016 bkzl. All rights reserved.
//

import RealmSwift

extension Results {
    func uniqueObject(_ paramKey: String)->[Object]{
        var uniqueObjects = [Object]()
        
        for obj in self {
            if let val = obj.valueForKeyPath(paramKey) {
                let uniqueObj: Object = val as! Object
                if !uniqueObjects.contains(uniqueObj) {
                    uniqueObjects.append(uniqueObj)
                }
            }
        }
        
        return uniqueObjects
    }
}
