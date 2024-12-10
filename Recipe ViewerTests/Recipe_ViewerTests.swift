//
//  Recipe_ViewerTests.swift
//  Recipe ViewerTests
//
//  Created by David Mehedinti on 12/10/24.
//

import Testing
@testable import Recipe_Viewer
import Foundation

struct Recipe_ViewerTests {

    @Test func fetchRecipes() async throws {
        let url = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")!
        let recipeCollection = try await RecipeCollection.fetchRecipes(url: url)
        #expect(recipeCollection.recipes.count > 0)
    }
    
    @Test func fetchRecipesWithInvalidURL() async throws {
        let url = URL(string: "https://www.google.com")!

        await #expect(throws: DownloadError.decodingFailed) {
            try await RecipeCollection.fetchRecipes(url: url)
        }
    }
    
    @Test func fetchRecipesWithNoData() async throws {
        let url = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json")!
        let recipeCollection = try await RecipeCollection.fetchRecipes(url: url)
        
        #expect(recipeCollection.recipes.count == 0)
    }
    
    @Test func fetchRecipesWithInvalidJSON() async throws {
        let url = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json")!
        
        await #expect(throws: DownloadError.decodingFailed) {
            try await RecipeCollection.fetchRecipes(url: url)
        }
    }
}
