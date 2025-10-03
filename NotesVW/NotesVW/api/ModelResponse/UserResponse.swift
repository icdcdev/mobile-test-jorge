//
//  UserResponse.swift
//  NotesVW
//
//  Created by Devant on 29/09/25.
//

class UserResponse: Codable {
    
    let Status: Bool
    let Message: String?
    let userId: Int?
    let name: String?
    let email: String?
    let photo: String?
    
    init() {
        self.Status = false
        self.Message = nil
        self.userId = nil
        self.name = nil
        self.email = nil
        self.photo = nil
    }
}
