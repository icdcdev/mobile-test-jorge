//
//  HomeViewModel.swift
//  NotesVW
//
//  Created by Devant on 30/09/25.
//
import Foundation
import SwiftUI
import CoreData
import UIKit

class HomeViewModel: BaseViewModel {
    
    @Published var isShowEmpty: Bool = true
    @Published var isShowingAlertDelete: Bool = false
    @Published var allNotes: [Note] = []
    @Published var noteToDelete: Notes = Notes()
    @Published var noteIndexToDelete: Int = 0
    
    func getPreNotes(context: NSManagedObjectContext, attemps: Int) {
        self.isLoading = true
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.previusSignIn()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.isLoading = false
                if self.accessTokenValid {
                    self.getNotes(context: context, attemps: attemps)
                }
            }
        }
    }//End getPreNotes
    
    func getNotes(context: NSManagedObjectContext, attemps: Int) {
        let url = ConfigRequest.getUrlWs(endPoint: EndPoints.GetInfo.WS_PHP_GET_NOTES)
        let extraQueries = "?userId=\(UserDefaultsPref.userId)"
        
        let request = ConfigRequest.getConfiguration(url: url, type: .get, data: nil, extraQueries: extraQueries)
        ConfigRequest.fetchData(request: request) { (result) in
            
            DispatchQueue.main.async {
                self.isLoading = false
                
                switch result {
                    
                case .success(let response):
                    do {
                        let decoder = JSONDecoder()
                        
                        let dataResponse = try decoder.decode(NotesResponse.self, from: response)
                        
                        self.alertMessage = dataResponse.Message ?? ""
                        self.isShowingAlert = true
                        self.allNotes = dataResponse.NotesList ?? []
                        
                        //Borro la tabla de la base de datos interna para remplazar por la info que viene del WS
                        self.deleteAllRecords(entityName: Constants.TABLE_NOTES, context: context)
                        
                        self.allNotes.forEach { note in
                            self.idServer = note.id
                            self.titles = note.title ?? ""
                            self.descriptin = note.description ?? ""
                            self.date = note.date ?? ""
                            self.pendingSave = false
                            self.status = 1
                            self.saveNoteCoreData(context: context)
                        }
                        
                        if dataResponse.Status {
                            self.isShowEmpty = false
                        } else {
                            self.isShowEmpty = true
                        }
                    } catch {
                        
                    }
                    
                case .failure(let failure):
                    if attemps == 0 {
                        print("Intento 1 de 2 para WS")
                        self.getNotes(context: context, attemps: 1)
                    } else {
                        if failure == NetworkError.error403 {
                            self.alertMessage = "\(failure.errorDescription ?? "")"
                            self.isShowingAlert = true
                            print("56: \(self.alertMessage)")
                        } else if failure == NetworkError.badRequest { // Revisar si corresponde al 409
                            self.alertMessage = "\(failure.errorDescription ?? "")"
                            self.isShowingAlert = true
                            print("58: \(self.alertMessage)")
                        } else {
                            self.alertMessage = "\(failure.errorDescription ?? "")"
                            //self.isShowingAlert = true
                            print("60: \(self.alertMessage) - self.isShowingAlert:: \(self.isShowingAlert)")
                            self.isShowEmpty = false
                            //Ir a base de datos interna por el listado
                        }
                    }
                    
                case nil:
                    print("Fue nil")
                }//End Switch
            }
            
        }//End fetchData
        
    }//End getNotes
    
    func showAlertConfirmDelete(noteIndex: Int, note: Notes) {
        self.noteToDelete = note
        self.noteIndexToDelete = noteIndex
        self.isShowingAlertDelete = true
        self.alertMessage = "¿Esta seguro de eliminar la nota?"
    }
    
    func deleteNote(context: NSManagedObjectContext) {
        print("Note index a eliminar :: \(self.noteIndexToDelete)")
        /*self.allNotes.remove(at: self.noteIndexToDelete)
        
        if self.allNotes.isEmpty {
            self.isShowEmpty = true
        }*/
        
        self.deleteNoteCoreData(item: self.noteToDelete, context: context)
    }
    
    func internetAvailable(isAvailable: Bool) {
        print("Estado de internet:: \(isAvailable)")
    }
    
    func uploadNotesPendingDelete(resultsToUpload: FetchedResults<Notes>, resultsToDelete: FetchedResults<Notes>, context: NSManagedObjectContext) {
        print("Notas pendentes por subir:: \(resultsToUpload.count)")
        resultsToUpload.forEach { note in
            self.saveNote(note: note, context: context)
        }
        
        print("Notas pendentes por eliminar:: \(resultsToDelete.count)")
        resultsToDelete.forEach { note in
            self.deleteNoteById(noteId: Int(note.idServer))
        }
    }
    
    func saveNote(note: Notes, context: NSManagedObjectContext) {
        
        let requestNote = NoteRequest(userId: UserDefaultsPref.userId, title: note.title ?? "", description: note.descriptin ?? "", date: "30-09-2025")
        
        let url = ConfigRequest.getUrlWs(endPoint: EndPoints.Register.WS_PHP_SAVE_NOTE)
        
        guard let jsonData = try? JSONEncoder().encode(requestNote) else {
            print("Error: Trying to convert model to JSON data")
            return
        }
        
        let jsonString = String(data: jsonData, encoding: .utf8)
        debugPrint("Request: \(String(describing: jsonString))")
        
        let request = ConfigRequest.getConfiguration(url: url, type: .post, data: jsonData)
        ConfigRequest.fetchData(request: request) { (result) in
            
            DispatchQueue.main.async {
                self.isLoading = false
                
                switch result {
                    
                case .success(let response):
                    do {
                        let decoder = JSONDecoder()
                        
                        let dataResponse = try decoder.decode(UserResponse.self, from: response)
                        print("Estatus uploadServer::\(dataResponse.Message ?? "")")
                        self.updateUploadNoteCoreData(item: note, context: context)
                    } catch {
                        
                    }
                    
                case .failure(let failure):
                    if failure == NetworkError.error403 {
                        print("56: \(self.alertMessage)")
                    } else if failure == NetworkError.badRequest { // Revisar si corresponde al 409
                        print("58: \(self.alertMessage)")
                    } else {
                        print("60: \(self.alertMessage)")
                        
                        self.idServer = 0
                        self.titles = requestNote.title
                        self.descriptin = requestNote.description
                        self.date = requestNote.date
                        self.pendingSave = true
                        self.status = 1
                        self.saveNoteCoreData(context: context)
                    }
                    
                case nil:
                    print("Fue nil")
                }//End Switch
            }
            
        }//End fetchData
        
    }//End saveNote
}
