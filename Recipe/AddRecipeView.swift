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
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Name of recipe", text: $title)
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
                    Picker("Recipe Type", selection: $recipeType) {
                        ForEach(recipeTypes, id: \.self) {
                            Text($0)
                        }
                    }
                    TextField("20 minutes", text: $duration)
                        .keyboardType(.numberPad)
                } header: {
                    Text("Recipe Details")
                }
                Section {
                    ForEach(ingredientNames.indices, id: \.self) { index in
                        TextField("Example: 2 Eggs", text: $ingredientNames[index])
                    }
                    
                    Button(action: {
                        ingredientNames.append("")
                    }) {
                        Image(systemName: "plus.circle")
                            .foregroundColor(Color.black)
                    }
                } header: {
                    Text("Ingredients")
                }


                Section {
                    TextEditor(text: $instructions)
                        .frame(width: 200, height: 200)
                } header: {
                    Text("Directions")
                }
                
                Button(action: {
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

                    try? moc.save()
                    dismiss()
                                   }) {
                                       HStack {
                                           Spacer()
                                           Text("Save")
                                           Spacer()
                                       }
                                   }
                                   .foregroundColor(.white)
                                   .padding(10)
                                   .background(Color.blue.opacity(0.5))
                                   .cornerRadius(8)
                                   .disabled(title.isEmpty || duration.isEmpty || instructions.isEmpty || ingredientNames.isEmpty)

            }
            .navigationTitle("Add Recipe 🍔")
            .padding()
            .background(Color.gray.opacity(0.3))
            .onAppear {
              UITableView.appearance().backgroundColor = .clear
            }
            .onDisappear {
              UITableView.appearance().backgroundColor = .systemGroupedBackground
            }
            .sheet(isPresented: $showImagePicker, onDismiss: loadImage) { ImagePicker(image: self.$inputImage) }
        }
    }
}

struct AddRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        AddRecipeView()
    }
}

