//
//  AddRecipeView.swift
//  RecipeApp
//
//  Created by Aliya Fatihah Mohamed Sidek on 29/03/2022.
//

import SwiftUI
import CoreData

struct EditRecipeView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    let recipe: Recipe
    let temp: [String]

    @State private var title = ""
    @State private var recipeType = ""
    @State private var ingredients = ""
    @State private var instructions = ""
    @State private var duration = ""
    @State var ingredientNames = [""]
    @State private var showImagePicker = false
    @State private var inputImage: UIImage?
    @State private var image: Image?
    @State private var showingAddButton = false


    let recipeTypes = ["Appetiser", "Breakfast", "Lunch", "Dinner", "Dessert"]
    
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField(recipe.title ?? "Unknown", text: $title)
                    Section {
                        if image != nil {
                            image!
                                .resizable()
                                .scaledToFit()
                                .onTapGesture { self.showImagePicker.toggle() }
                        } else {
                            
                            Image(uiImage: UIImage(data: recipe.image ?? Data()) ?? UIImage())
                                .resizable()
                                .scaledToFit()
                                .onTapGesture { self.showImagePicker.toggle() }
                        }
                    }
                    Picker("Recipe Type", selection: $recipeType) {
                        ForEach(recipeTypes, id: \.self) {
                            Text($0)
                        }
                    }
                    TextField("\(recipe.duration)", text: $duration)
                }
                
                Section {
                    
                    Button(action: {
                        for i in temp.indices{
                            if(i == temp.count-1){
                                
                            }else{
                                ingredientNames.append("")
                            }
                        }
                        showingAddButton = true
                    }) {
                        Text("Show ingredients")
                    }
                    
                    let sample = recipe.ingredients?.components(separatedBy: ",")
                    ForEach(ingredientNames.indices, id: \.self) { index in
                        if(ingredientNames.count > 1 && index != (sample?.count ?? 1)){
                            TextField(sample?[index] ?? "Ingredient", text: $ingredientNames[index])
                        }

                    }
                

                Section {
//                    TextEditor(text: $instructions)
                    ZStack(alignment: .leading) {
                        if instructions.isEmpty {
                            Text(recipe.instructions ?? "Instructions")
                                .padding(.all)
                                .opacity(0.5)
                        }
                        
                        TextEditor(text: $instructions)
                            .padding(.all)
                    }
                } header: {
                    Text("Instructions")
                }

                Section {
                    Button("Save") {
                        
                        for i in ingredientNames.indices {
                           
                            if(i == ingredientNames.count - 1){
                                ingredients = ingredients + "\(ingredientNames[i])"
                            }else {
                                ingredients = ingredients + "\(ingredientNames[i]),"
                            }
                            
                        }
                        
                        if(title.isEmpty){
                            
                        }else{
                            recipe.title = title
                        }
                        
                        if(duration.isEmpty){
                            
                        }else{
                            recipe.duration = Int16(duration) ?? 0
                        }
                        
                        if(recipeType.isEmpty){
                            
                        }else{
                            recipe.recipeType = recipeType
                        }
                        
                        if(ingredients.isEmpty){
                            
                        }else{
                            recipe.ingredients = ingredients
                        }
                        
                        if(instructions.isEmpty){
                            
                        }else{
                            recipe.instructions = instructions
                        }
                        
                        if(((inputImage?.jpegData(compressionQuality: 1.0)) != nil)){
                            recipe.image = inputImage?.jpegData(compressionQuality: 1.0)

                        }
                                               
                        try? moc.save()
                        dismiss()
                    }
                }
            }
            .navigationTitle(recipe.title ?? "Unknown")
            .sheet(isPresented: $showImagePicker, onDismiss: loadImage) { ImagePicker(image: self.$inputImage) }
        }
    }
}
}

struct EditRecipeView_Previews: PreviewProvider {
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)

    static var previews: some View {
        let recipe = Recipe(context: moc)
        let temp = [""]
        recipe.title = "Test recipe"

        return NavigationView {
            EditRecipeView(recipe: recipe, temp: temp)
        }
    }
}
