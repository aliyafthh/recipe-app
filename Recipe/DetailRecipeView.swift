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
    @State private var showingEditScreen = false

    
    let recipe: Recipe
    
    func deleteRecipe() {
        moc.delete(recipe)
         try? moc.save()
        dismiss()
    }
    
    
    var body: some View {
        ScrollView {
            VStack {
                    Section {
                        Image(uiImage: UIImage(data: recipe.image ?? Data()) ?? UIImage())
                            .resizable()
                            .scaledToFit()
                            .padding(EdgeInsets(top: 15, leading: 15, bottom: 0, trailing: 15))
                        Text("Preparation time: \(recipe.duration) minutes")
                            
                    }
                    Spacer()
                    Section {
                        Text("Ingredients")
                            .fontWeight(.bold)
                        let samples = recipe.ingredients?.components(separatedBy: ",")
                        ForEach(samples ?? [], id: \.self) { sample in
                            Text("◾️ \(sample )")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 0))
                        }
                    }
                    Spacer()
                    Section {
                        Text("Directions")
                            .fontWeight(.bold)
                        Text(recipe.instructions ?? "Unknown")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(EdgeInsets(top: 0, leading: 15, bottom: 20, trailing: 0))
                    }
                
                
            }
            .background(Color.gray.opacity(0.2))
            .multilineTextAlignment(.leading)
            


            
        }
        .navigationTitle(recipe.title ?? "Unknown Recipe")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Delete recipe", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive, action: deleteRecipe)
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure?")
        }
        .sheet(isPresented: $showingEditScreen) {
            EditRecipeView(recipe: recipe, temp: recipe.ingredients?.components(separatedBy: ",") ?? [])
        }
        .toolbar {
            HStack{
                Button {
                    showingEditScreen = true
                } label: {
                    Label("Delete this recipe", systemImage: "square.and.pencil")
                }
                Button {
                    showingDeleteAlert = true
                } label: {
                    Label("Delete this recipe", systemImage: "trash")
                }
            }
            
            
        }
        .padding()
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

extension String {
    init(sep:String, _ lines:String...){
        self = ""
        for (idx, item) in lines.enumerated() {
            self += "\(item)"
            if idx < lines.count-1 {
                self += sep
            }
        }
    }

    init(_ lines:String...){
        self = ""
        for (idx, item) in lines.enumerated() {
            self += "\(item)"
            if idx < lines.count-1 {
                self += "\n"
            }
        }
    }
}
