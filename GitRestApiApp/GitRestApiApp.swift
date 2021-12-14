//
//  GitRestApiApp.swift
//  GitRestApiApp
//
//  Created by Ryusei Wada on 2021/12/14.
//

import SwiftUI

@main
struct GitRestApiAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
