//
//  NotesVWApp.swift
//  NotesVW
//
//  Created by Devant on 29/09/25.
//

import SwiftUI
import Firebase

@main
struct NotesVWApp: App {
    let persistenceController = PersistenceController.shared
    
    init() {
        setUpAuth()
    }
    
    var body: some Scene {
        
        WindowGroup {
            SplashView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }//EndWindowGroup
        
    }//End body
}

extension NotesVWApp {
    
    private func setUpAuth() {
        FirebaseApp.configure()
    }
}
