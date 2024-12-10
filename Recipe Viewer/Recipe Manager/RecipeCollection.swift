//
//  recipe.swift
//  Recipe Viewer
//
//  Created by David Mehedinti on 12/10/24.
//

import Foundation
import SwiftData

struct RecipeCollection: Decodable {
    let recipes: [Recipe]
    
    struct Recipe: Decodable {
        let cuisine: String
        let name: String
        let photoUrlLarge: String?
        let photoUrlSmall: String?
        let uuid: String
        let sourceUrl: String?
        let youtubeUrl: String?
    }
    
    static func fetchRecipes(url: URL) async throws -> RecipeCollection {
        let session = URLSession.shared
        guard let (data, response) = try? await session.data(from: url),
              let response = response as? HTTPURLResponse else {
            throw DownloadError.missingData
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let recipesCollection = try? decoder.decode(RecipeCollection.self, from: data) else {
            throw DownloadError.decodingFailed
        }
        
        return recipesCollection
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

enum DownloadError: Error {
    case wrongDataFormat(error: Error)
    case missingData
    case decodingFailed
}

extension DownloadError: Equatable {
    static func == (lhs: DownloadError, rhs: DownloadError) -> Bool {
        switch (lhs, rhs) {
        case (.wrongDataFormat(let error1), .wrongDataFormat(let error2)):
            return (error1 as NSError).domain == (error2 as NSError).domain &&
                   (error1 as NSError).code == (error2 as NSError).code
        case (.missingData, .missingData):
            return true
        case (.decodingFailed, .decodingFailed):
            return true
        default:
            return false
        }
    }
}

