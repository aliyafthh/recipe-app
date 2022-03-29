//
//  ContentView.swift
//  RecipeApp
//
//  Created by Aliya Fatihah Mohamed Sidek on 29/03/2022.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [SortDescriptor(\.title), SortDescriptor(\.recipeType)]) var recipes: FetchedResults<Recipe>
    
    @State private var showingAddScreen = false
    
    
    func deleteBooks(at offsets: IndexSet) {
        for offset in offsets {
            // find this book in our fetch request
            let recipe = recipes[offset]

            // delete it from the context
            moc.delete(recipe)
        }

        // save the context
        try? moc.save()
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(recipes) { recipe in
                    NavigationLink {
                        DetailRecipeView(recipe: recipe)
                    } label: {
                        HStack {
                            Text(recipe.title ?? "Unknown")
                        }
                    }
                }
                .onDelete(perform: deleteBooks)
            }
               .navigationTitle("Recipe")
               .toolbar {
                   ToolbarItem(placement: .navigationBarTrailing) {
                       Button {
                           showingAddScreen.toggle()
                       } label: {
                           Label("Add Recipe", systemImage: "plus")
                       }
                   }
                   ToolbarItem(placement: .navigationBarLeading) {
                       EditButton()
                   }
//                   ToolbarItem() {
//                       Button {
//                           books.nsPredicate = NSPredicate(format: "author == 'Suzanne Collins'")                       } label: {
//                           Label("Add Book", systemImage: "plus")
//                       }
//                   }
                   
               }
               .sheet(isPresented: $showingAddScreen) {
                   AddRecipeView()
               }
       }
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

