//
//  RecipeEntity.swift
//  Recipe Viewer
//
//  Created by David Mehedinti on 12/10/24.
//

import SwiftData
import Foundation

@Model
class RecipeEntity {
    @Attribute(.unique) var uuid: UUID
    var name: String
    var cuisine: String
    var photoUrlLarge: URL?
    var photoUrlSmall: URL?
    var sourceUrl: URL?
    var youtubeURL: URL?
    
    init(uuid: UUID = UUID(), name: String, cuisine: String, photoUrlLarge: URL?, photoUrlSmall: URL?, sourceUrl: URL?, youtubeURL: URL?) {
        self.uuid = uuid
        self.name = name
        self.cuisine = cuisine
        self.photoUrlLarge = photoUrlLarge
        self.photoUrlSmall = photoUrlSmall
        self.sourceUrl = sourceUrl
        self.youtubeURL = youtubeURL
    }
}
