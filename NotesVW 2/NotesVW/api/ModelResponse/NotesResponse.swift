//
//  NotesResponse.swift
//  NotesVW
//
//  Created by Devant on 01/10/25.
//

import Foundation

class NotesResponse: Codable, ObservableObject {
    let Status: Bool
    let Message: String?
    let NotesList: [Note]?
    
    init() {
        self.Status = false
        self.Message = nil
        self.NotesList = nil
    }
}

class Note: Codable {
    let id: Int
    let title: String?
    let description: String?
    let date: String?
}
