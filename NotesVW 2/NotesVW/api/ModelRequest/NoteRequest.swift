//
//  NoteRequest.swift
//  NotesVW
//
//  Created by Devant on 30/09/25.
//

struct NoteRequest: Codable {
    
    let userId: Int
    let title: String
    let description: String
    let date: String
}
