//
//  DetailRecipeView.swift
//  RecipeApp
//
//  Created by Aliya Fatihah Mohamed Sidek on 29/03/2022.
//

import SwiftUI
import CoreData

struct DetailRecipeView: View {
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    @State private var showingDeleteAlert = false
    
    let recipe: Recipe
    
    func deleteRecipe() {
        moc.delete(recipe)
         try? moc.save()
        dismiss()
    }
    
    var body: some View {
        ScrollView {
            VStack {
                Text("Preparation time: \(recipe.duration)")
                Section {
                    Text("Ingredients")
                    Text(recipe.ingredients ?? "Unknown")
                }
                
                Section {
                    Text(recipe.instructions ?? "Unknown")
                }
            }
            


            
        }
        .navigationTitle(recipe.title ?? "Unknown Recipe")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Delete recipe", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive, action: deleteRecipe)
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure?")
        }
        .toolbar {
            Button {
                showingDeleteAlert = true
            } label: {
                Label("Delete this recipe", systemImage: "trash")
            }
        }
    }
}

struct DetailRecipeView_Previews: PreviewProvider {
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)

    static var previews: some View {
        let recipe = Recipe(context: moc)
        recipe.title = "Test recipe"

        return NavigationView {
            DetailRecipeView(recipe: recipe)
        }
    }
}

