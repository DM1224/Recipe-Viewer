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
    var photoLarge: Data?
    var photoSmall: Data?
    var sourceUrl: URL?
    var youtubeUrl: URL?
    
    init(uuid: String, name: String, cuisine: String, photoUrlLarge: URL?, photoUrlSmall: URL?, sourceUrl: URL?, youtubeUrl: URL?) {
        self.uuid = uuid
        self.name = name
        self.cuisine = cuisine
        self.photoUrlLarge = photoUrlLarge
        self.photoUrlSmall = photoUrlSmall
        self.sourceUrl = sourceUrl
        self.youtubeUrl = youtubeUrl
    }
    
    convenience init(from recipe: RecipeCollection.Recipe) {
        let photoUrlLarge = recipe.photoUrlLarge.flatMap(URL.init)
        let photoUrlSmall = recipe.photoUrlSmall.flatMap(URL.init)
        let sourceUrl = recipe.sourceUrl.flatMap(URL.init)
        let youtubeUrl = recipe.youtubeUrl.flatMap(URL.init)

        self.init(
            uuid: recipe.uuid,
            name: recipe.name,
            cuisine: recipe.cuisine,
            photoUrlLarge: photoUrlLarge,
            photoUrlSmall: photoUrlSmall,
            sourceUrl: sourceUrl,
            youtubeUrl: youtubeUrl
        )
    }
    
    @MainActor
    func fetchImage(forSmallImage isSmall: Bool) async {
        let imageURL = isSmall ? photoUrlSmall : photoUrlLarge
        guard let url = imageURL, (isSmall ? photoSmall : photoLarge) == nil else {
            return
        }

        do {
            let data = try await fetchImageData(from: url)
            if isSmall {
                self.photoSmall = data
            } else {
                self.photoLarge = data
            }
        } catch {
            print("Error fetching image: \(error)")
        }
    }

    private func fetchImageData(from url: URL) async throws -> Data {
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }
}
