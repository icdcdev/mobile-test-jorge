//
//  BackView.swift
//  NotesVW
//
//  Created by Devant on 29/09/25.
//

import Foundation

import SwiftUI

class BackView : ObservableObject {
    
    @Published var path = NavigationPath()
    
    func root(){
        path.removeLast(path.count)
    }
}

enum Routes: Hashable {
    case Login
    case Home
    case Profile
    case CreateNote
}
