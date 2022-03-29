//
//  AddRecipeView.swift
//  RecipeApp
//
//  Created by Aliya Fatihah Mohamed Sidek on 29/03/2022.
//

import SwiftUI

struct AddRecipeView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    @State private var title = ""
    @State private var recipeType = ""
    @State private var ingredients = ""
    @State private var instructions = ""
    @State private var duration = ""
    
    let recipeTypes = ["Appetiser", "Breakfast", "Lunch", "Dinner", "Dessert"]
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Name of recipe", text: $title)
                    Picker("Recipe Type", selection: $recipeType) {
                        ForEach(recipeTypes, id: \.self) {
                            Text($0)
                        }
                    }
                    TextField("Duration", text: $duration)

                }

                Section {
                    TextEditor(text: $instructions)
                } header: {
                    Text("Write a review")
                }

                Section {
                    Button("Save") {
                        let newRecipe = Recipe(context: moc)
                        newRecipe.id = UUID()
                        newRecipe.title = title
                        newRecipe.recipeType = recipeType
                        newRecipe.duration = Int16(duration) ?? 0
                        newRecipe.ingredients = ingredients
                        newRecipe.instructions = instructions

                        try? moc.save()
                        dismiss()
                    }
                }
                .disabled(title.isEmpty || duration.isEmpty || instructions.isEmpty)
            }
            .navigationTitle("Add Recipe")
        }
    }
}

struct AddBookView_Previews: PreviewProvider {
    static var previews: some View {
        AddRecipeView()
    }
}

