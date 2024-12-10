//
//  Recipe_ViewerTests.swift
//  Recipe ViewerTests
//
//  Created by David Mehedinti on 12/10/24.
//

import Testing
@testable import Recipe_Viewer

struct Recipe_ViewerTests {

    @Test func fetchRecipes() async throws {
        let manager = RecipeManager()
        let response = try await manager.fetchRecipes()
        #expect(response.count > 0)
    }
}
