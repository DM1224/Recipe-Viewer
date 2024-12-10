//
//  ContentView.swift
//  Recipe Viewer
//
//  Created by David Mehedinti on 12/10/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var recipes: [RecipeEntity]
    
    func recipeList() -> some View {
        ScrollViewReader { proxy in
            List {
                ForEach(recipes) { recipe in
                    NavigationLink {
                        Text(recipe.name)
                    } label: {
                        HStack {
                            if let data = recipe.photoSmall, let uiImage = UIImage(data: data) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                            } else {
                                Image(systemName: "fork.knife.circle.fill") // Placeholder
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.gray)
                            }
                            Text(recipe.name)
                        }
                        .onAppear {
                            if recipe.photoSmall == nil {
                                Task {
                                    await recipe.fetchImage(forSmallImage: true)
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    var body: some View {
        NavigationSplitView {
            recipeList()
            .onAppear {
                if recipes.isEmpty {
                    Task {
                        await RecipeCollection.refresh(modelContext: modelContext)
                    }
                }
            }
            .refreshable {
                await RecipeCollection.refresh(modelContext: modelContext)
            }
        } detail: {
            Text("Select an item")
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: RecipeEntity.self, inMemory: true)
}
