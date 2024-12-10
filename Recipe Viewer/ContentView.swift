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
//    @State private var selectedId: RecipeEntity.ID = nil

    var body: some View {
        NavigationSplitView {
            ScrollViewReader { proxy in
                List {
                    ForEach(recipes) { item in
                        NavigationLink {
                            Text("\(item.name)")
                        } label: {
                            Text(item.name)
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
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

    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(recipes[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
