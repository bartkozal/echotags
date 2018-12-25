//
//  OfflinePack.swift
//  Echotags
//
//  Created by bkzl on 21/06/16.
//

import Foundation
import Mapbox

struct OfflinePack {
    let pack: MGLOfflinePack
    
    var downloaded: Bool {
        return completedResources == expectedResources
    }
    
    var completedResources: UInt64 {
        return pack.progress.countOfResourcesCompleted
    }
    
    var expectedResources: UInt64 {
        return pack.progress.countOfResourcesExpected
    }
    
    var byteCount: String {
        return ByteCountFormatter.string(fromByteCount: Int64(pack.progress.countOfBytesCompleted), countStyle: .memory)
    }
    
    var progressPercentage: Float {
        let progress = pack.progress
        let completedResources = progress.countOfResourcesCompleted
        let expectedResources = progress.countOfResourcesExpected
        return round(Float(completedResources) / Float(expectedResources) * 100)
    }
}
