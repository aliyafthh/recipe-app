//
//  RecipeAppApp.swift
//  RecipeApp
//
//  Created by Aliya Fatihah Mohamed Sidek on 29/03/2022.
//

import SwiftUI

@main
struct RecipeApp: App {
    @StateObject private var dataController = DataController()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
