//
//  Item.swift
//  Recipe Viewer
//
//  Created by David Mehedinti on 12/10/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
