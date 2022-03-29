//
//  DataController.swift
//  RecipeApp
//
//  Created by Aliya Fatihah Mohamed Sidek on 29/03/2022.
//

import CoreData
import SwiftUI

class DataController: ObservableObject {
    //tell which model to load
    let container = NSPersistentContainer(name: "Recipe")
    
    //load the data
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
}
