//
//  ProfileViewModel.swift
//  NotesVW
//
//  Created by Devant on 30/09/25.
//

import Foundation
import SwiftUI

class ProfileViewModel: BaseViewModel {
    
    @Published var name: String = UserDefaultsPref.userName
    @Published var email: String = UserDefaultsPref.userEmail
    @Published var photo: String = UserDefaultsPref.userPhoto
    @Published var disableBtnSession: Bool = false
 
}
