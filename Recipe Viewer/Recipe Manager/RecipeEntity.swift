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
    @Attribute(.unique) var uuid: String
    var name: String
    var cuisine: String
    var photoUrlLarge: URL?
    var photoUrlSmall: URL?
    var sourceUrl: URL?
    var youtubeURL: URL?
    
    init(uuid: String, name: String, cuisine: String, photoUrlLarge: URL?, photoUrlSmall: URL?, sourceUrl: URL?, youtubeUrl: URL?) {
        self.uuid = uuid
        self.name = name
        self.cuisine = cuisine
        self.photoUrlLarge = photoUrlLarge
        self.photoUrlSmall = photoUrlSmall
        self.sourceUrl = sourceUrl
        self.youtubeURL = youtubeUrl
    }
    
    convenience init(from recipe: RecipeCollection.Recipe) {
        self.init(
            uuid: recipe.uuid,
            name: recipe.name,
            cuisine: recipe.cuisine,
            photoUrlLarge: recipe.photoUrlLarge,
            photoUrlSmall: recipe.photoUrlSmall,
            sourceUrl: recipe.sourceUrl,
            youtubeUrl: recipe.youtubeUrl
        )
    }
}
