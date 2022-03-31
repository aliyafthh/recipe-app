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
    @State private var showingFilterScreen = false
    @State private var recipeType = ""
    let recipeTypes = ["Show All","Appetiser", "Breakfast", "Lunch", "Dinner", "Dessert"]
    @Environment(\.dismiss) var dismiss
    
    func filterRecipes(recipeType: String) {
        if(recipeType == "Show All"){
            recipes.nsPredicate = NSPredicate(format: "recipeType IN %@", recipeTypes)
        }else{
            recipes.nsPredicate = NSPredicate(format: "recipeType == '\(recipeType)'")

        }
    }
    
    
    func deleteRecipes(at offsets: IndexSet) {
        for offset in offsets {
            let recipe = recipes[offset]
            moc.delete(recipe)
        }

        // save the context
        try? moc.save()
    }
    
    var body: some View {
        
        
        NavigationView {
            VStack{
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
                .onDelete(perform: deleteRecipes)
            }
            .navigationTitle("Recipes 🥘")
               .toolbar {
                   ToolbarItem(placement: .navigationBarTrailing) {
                       Button {
                           showingFilterScreen = true
                       } label: {
                           Label("Filter", systemImage: "line.3.horizontal.decrease.circle")
                       }
                   }
                   ToolbarItem(placement: .navigationBarLeading) {
                       EditButton()
                   }
                   
               }
               .sheet(isPresented: $showingAddScreen) {
                   AddRecipeView()
               }
               .sheet(isPresented: $showingFilterScreen) {
                   
                   Text("Filter By")
                       .fontWeight(.bold)
                       .padding()
                   Section {
                      Text("Show All 🍱")
                           .padding()
                           .frame(maxWidth: .infinity)
                   }
//                   .background(Color.pink)
                   .onTapGesture {
                       filterRecipes(recipeType: "Show All")
                       showingFilterScreen = false
                   }
                   Section {
                      Text("Appetiser 🍲")
                           .padding()
                           .frame(maxWidth: .infinity)
                   }
                   .onTapGesture {
                       filterRecipes(recipeType: "Appetiser")
                       showingFilterScreen = false
                   }
                   Section {
                      Text("Breakfast 🥐")
                           .padding()
                           .frame(maxWidth: .infinity)
                   }
                   .onTapGesture {
                       filterRecipes(recipeType: "Breakfast")
                       showingFilterScreen = false
                   }
                   Section {
                      Text("Lunch 🍛")
                           .padding()
                           .frame(maxWidth: .infinity)
                   }
                   .onTapGesture {
                       filterRecipes(recipeType: "Lunch")
                       showingFilterScreen = false
                   }
                   Section {
                      Text("Dinner 🍗")
                           .padding()
                           .frame(maxWidth: .infinity)
                   }
                   .onTapGesture {
                       filterRecipes(recipeType: "Dinner")
                       showingFilterScreen = false
                   }
                   Section {
                      Text("Dessert 🍧")
                           .padding()
                           .frame(maxWidth: .infinity)
                   }
                   .onTapGesture {
                       filterRecipes(recipeType: "Dessert")
                       showingFilterScreen = false
                   }
                   
//                   Picker("Recipe Type", selection: $recipeType) {
//                       ForEach(recipeTypes, id: \.self) {
//                           Text($0)
//                       }
//                   }

                    
               }
                Button {
                    showingAddScreen.toggle()
                    recipes.nsPredicate = NSPredicate(format: "recipeType IN %@", recipeTypes)
                } label: {
                    Label("Add Recipe", systemImage: "plus")
                }
                .padding()
       }
            
        }
        
        }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

