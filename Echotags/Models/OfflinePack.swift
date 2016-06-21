//
//  OfflinePack.swift
//  Echotags
//
//  Created by bkzl on 21/06/16.
//  Copyright © 2016 Bartłomiej Kozal. All rights reserved.
//

import Foundation
import Mapbox

struct OfflinePack {
    let pack: MGLOfflinePack
    
    var isReady: Bool {
        return completedResources == expectedResources
    }
    
    var completedResources: UInt64 {
        return pack.progress.countOfResourcesCompleted
    }
    
    var expectedResources: UInt64 {
        return pack.progress.countOfResourcesExpected
    }
    
    var byteCount: String {
        return NSByteCountFormatter.stringFromByteCount(Int64(pack.progress.countOfBytesCompleted), countStyle: .Memory)
    }
    
    var progressPercentage: Float {
        let progress = pack.progress
        let completedResources = progress.countOfResourcesCompleted
        let expectedResources = progress.countOfResourcesExpected
        return round(Float(completedResources) / Float(expectedResources) * 100)
    }
}
