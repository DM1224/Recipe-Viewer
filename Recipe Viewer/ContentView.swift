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
    
    func recipePage(recipe: RecipeEntity) -> some View {
        VStack {
            HStack {
                if let data = recipe.photoLarge, let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .frame(width: 200, height: 200)
                        .clipShape(Circle())
                } else {
                    Image(systemName: "fork.knife.circle.fill") // Placeholder
                        .resizable()
                        .frame(width: 200, height: 200)
                        .foregroundColor(.gray)
                }
            }
            .onAppear {
                if recipe.photoLarge == nil {
                    Task {
                        await recipe.fetchImage(forSmallImage: false)
                    }
                }
            }
            Text(recipe.name)
                .font(.title)
            Text("Cuisine: \(recipe.cuisine)")
            Button(action: {
                if let url = recipe.sourceUrl {
                    UIApplication.shared.open(url)
                }
            }) {
                HStack {
                    Image(systemName: "safari")
                        .font(.headline)
                    Text("Visit Website")
                        .fontWeight(.bold)
                }
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .cornerRadius(10)
            }
            .padding()
            Button(action: {
                if let url = recipe.youtubeUrl {
                    UIApplication.shared.open(url)
                }
            }) {
                HStack {
                    Image(systemName: "video")
                        .font(.headline)
                    Text("Watch YouTube Video")
                        .fontWeight(.bold)
                }
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .cornerRadius(10)
            }
            .padding()
            Spacer()
        }
    }
    
    func recipeList() -> some View {
        ScrollViewReader { proxy in
            List {
                ForEach(recipes) { recipe in
                    NavigationLink {
                        recipePage(recipe: recipe)
                    } label: {
                        HStack {
                            if let data = recipe.photoSmall, let uiImage = UIImage(data: data) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                            } else {
                                Image(systemName: "fork.knife.circle.fill")
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
        .navigationTitle("Recipes")
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
