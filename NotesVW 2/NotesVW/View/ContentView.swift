//
//  ContentView.swift
//  NotesVW
//
//  Created by Devant on 29/09/25.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @ObservedObject var viewModel: BaseViewModel
    @EnvironmentObject var root : BackView
    
    var body: some View {
        
        NavigationStack(path: $root.path) {
            
            Group {
            }//End Group
            .navigationDestination(for: Routes.self) { screen in
                switch screen {
                case .Profile:
                    ProfileView()
                case .CreateNote:
                    CreateNoteView()
                case .Home:
                    HomeView()
                case .Login:
                    LoginView()
                }
            }
            .onAppear() {
                if UserDefaultsPref.userId == 0 {
                    root.path.append(Routes.Login)
                } else {
                    root.path.append(Routes.Home)
                }
            }
        }
        
    }//End body
}
