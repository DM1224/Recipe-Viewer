//
//  RecipeManager.swift
//  Recipe Viewer
//
//  Created by David Mehedinti on 12/10/24.
//
import Foundation
import Observation
import SwiftData

@Observable
class RecipeManager {
    let modelContainer: ModelContainer
    
    init() {
        do {
            self.modelContainer = try ModelContainer(for: RecipeEntity.self)
        } catch {
            fatalError("Failed to create SwiftData ModelContainer: \(error)")
        }
    }
    
    func fetchRecipes() async throws -> [Recipe] {
        guard let url = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json") else {
            throw URLError(.badURL)
        }
        
        let session = URLSession.shared
        guard let (data, response) = try? await session.data(from: url),
              let response = response as? HTTPURLResponse else {
            throw DownloadError.missingData
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let recipes = try? decoder.decode(RecipesResponse.self, from: data) else {
            throw DownloadError.decodingFailed
        }
        
        return recipes.recipes
    }
}

enum DownloadError: Error {
    case wrongDataFormat(error: Error)
    case missingData
    case decodingFailed
}
