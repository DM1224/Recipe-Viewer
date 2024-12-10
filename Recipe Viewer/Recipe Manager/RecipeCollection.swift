//
//  recipe.swift
//  Recipe Viewer
//
//  Created by David Mehedinti on 12/10/24.
//

import Foundation

struct RecipeCollection: Decodable {
    let recipes: [Recipe]
    
    struct Recipe: Decodable {
        let cuisine: String
        let name: String
        let photoUrlLarge: URL?
        let photoUrlSmall: URL?
        let uuid: UUID
        let sourceUrl: URL?
        let youtubeUrl: URL?
        
        enum CodingKeys: String, CodingKey {
            case cuisine
            case name
            case photoUrlLarge = "photo_url_large"
            case photoUrlSmall = "photo_url_small"
            case uuid
            case sourceUrl = "source_url"
            case youtubeUrl = "youtube_url"
        }
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

