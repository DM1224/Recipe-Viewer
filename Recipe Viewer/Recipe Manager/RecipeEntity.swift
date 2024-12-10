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
    
    init(uuid: UUID = UUID(), name: String, cuisine: String, photoUrlLarge: URL?, photoUrlSmall: URL?, sourceUrl: URL?, youtubeUrl: URL?) {
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
    
    @MainActor
    static func refresh(modelContext: ModelContext) async {
        do {
            let url = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")!
            let recipeCollection = try await RecipeCollection.fetchRecipes(url: url)
            
            for recipe in recipeCollection.recipes {
                let recipeEntity = RecipeEntity(from: recipe)
                
                modelContext.insert(recipeEntity)
            }
        } catch let error {
            print("Error refreshing recipes: \(error)")
        }
    }
}
