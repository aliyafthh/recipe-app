//
//  AddRecipeView.swift
//  RecipeApp
//
//  Created by Aliya Fatihah Mohamed Sidek on 29/03/2022.
//

import SwiftUI
import CoreData

struct AddRecipeView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    @State private var title = ""
    @State private var recipeType = ""
    @State private var ingredients = ""
    @State private var instructions = ""
    @State private var duration = ""
    @State var ingredientNames = [""]
    @State private var showImagePicker = false
    @State private var inputImage: UIImage?
    @State private var image: Image?

    let recipeTypes = ["Appetiser", "Breakfast", "Lunch", "Dinner", "Dessert"]
    
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
    }
    
//    func save() {
//        let pickedImage = inputImage?.jpegData(compressionQuality: 1.0)
//        let entityName =  NSEntityDescription.entity(forEntityName: "Test", in: moc)!
//        let image = NSManagedObject(entity: entityName, insertInto: moc)
//        image.setValue(pickedImage, forKeyPath: "image")
//        do {
//          try moc.save()
//            print("saved")
//        } catch let error as NSError {
//          print("Could not save. \(error), \(error.userInfo)")
//        }
//    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Name of recipe", text: $title)
                    Section(header: Text("Picture", comment: "Section Header - Picture")) {
                        if image != nil {
                            image!
                                .resizable()
                                .scaledToFit()
                                .onTapGesture { self.showImagePicker.toggle() }
                        } else {
                            Button(action: { self.showImagePicker.toggle() }) {
                                Text("Select Image", comment: "Select Image Button")
                                    .accessibility(identifier: "Select Image")
                            }
                        }
                    }
                    Picker("Recipe Type", selection: $recipeType) {
                        ForEach(recipeTypes, id: \.self) {
                            Text($0)
                        }
                    }
                    TextField("Duration", text: $duration)
                }
                
                Section {
                    ForEach(ingredientNames.indices, id: \.self) { index in
                        TextField("Example Field", text: $ingredientNames[index]) 
                    }
                    
                    Button(action: {
                        ingredientNames.append("")
                    }) {
                        Image(systemName: "plus.circle")
                            .foregroundColor(Color.black)
                    }
                }

                Section {
                    TextEditor(text: $instructions)
                } header: {
                    Text("Write a review")
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
                        
                        let newRecipe = Recipe(context: moc)
                        newRecipe.id = UUID()
                        newRecipe.title = title
                        newRecipe.recipeType = recipeType
                        newRecipe.duration = Int16(duration) ?? 0
                        newRecipe.ingredients = ingredients
                        newRecipe.instructions = instructions
                        newRecipe.image = inputImage?.jpegData(compressionQuality: 1.0)
                        
//                        let pickedImage = inputImage?.jpegData(compressionQuality: 1.0)
//                        let entityName =  NSEntityDescription.entity(forEntityName: "Recipe", in: moc)!
//                        let image = NSManagedObject(entity: entityName, insertInto: moc)
//                        image.setValue(pickedImage, forKeyPath: "image")
//                        image.setValue(title, forKey: "title")

                        try? moc.save()
                        dismiss()
                    }
                }
                .disabled(title.isEmpty || duration.isEmpty || instructions.isEmpty)
            }
            .navigationTitle("Add Recipe")
            .sheet(isPresented: $showImagePicker, onDismiss: loadImage) { ImagePicker(image: self.$inputImage) }
        }
    }
}

struct AddRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        AddRecipeView()
    }
}

