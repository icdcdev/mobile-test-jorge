//
//  GoogleBtn.swift
//  NotesVW
//
//  Created by Devant on 29/09/25.
//

import SwiftUI
import GoogleSignIn

struct GoogleBtn: UIViewRepresentable {
    
    @Environment(\.colorScheme) var colorScheme
    private var btnGoogle = GIDSignInButton()
    
    func makeUIView(context: Context) -> some GIDSignInButton {
        btnGoogle.colorScheme = colorScheme == .dark ? .dark : .light
        return btnGoogle
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        btnGoogle.colorScheme = colorScheme == .dark ? .dark : .light
    }
}
