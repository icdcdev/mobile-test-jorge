//
//  SplashView.swift
//  NotesVW
//
//  Created by Jorge Espinoza on 29/09/25.
//

import Foundation
import DotLottie
import SwiftUI
import CoreData

struct SplashView: View {
    
    @State private var isFinish = false
    @StateObject var viewModel = AuthViewModel()
    @StateObject var homeViewModel = HomeViewModel()
    @StateObject var profileViewModel = ProfileViewModel()
    @StateObject var createNoteViewModel = CreateNoteViewModel()
    
    var body: some View {
        if isFinish {
            ContentView(viewModel: BaseViewModel())
                .environmentObject(BackView())
                .environmentObject(viewModel)
                .environmentObject(homeViewModel)
                .environmentObject(profileViewModel)
                .environmentObject(createNoteViewModel)
        } else {
            VStack {
                Text("Notes")
                    .font(.system(size: 30, weight: .bold, design: .default))
                    .foregroundStyle(Colors.blueTitle)
                    .padding(5)
                
                DotLottieAnimation(fileName: "notes", config: AnimationConfig(autoplay: true, loop: true)).view()
                
                Text("VW")
                    .font(.system(size: 28, weight: .bold, design: .default))
                    .foregroundStyle(Colors.blueTitle)
                    .padding(5)
            }.onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.7) {
                    self.isFinish = true
                }
            }
        }
    }
}
