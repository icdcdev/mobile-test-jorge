//
//  CreateNoteViewModel.swift
//  NotesVW
//
//  Created by Devant on 30/09/25.
//

import Foundation
import SwiftUI
import CoreData

class CreateNoteViewModel: BaseViewModel {
    
    @Published var title: String = "" {
        didSet {
            //print("title changed to: \(title)")
        }
    }
    
    @Published var description: String = "" {
        didSet {
            //print("description changed to: \(description)")
        }
    }
    
    func validateFields() {
        if /*title.count > 0 &&*/ description.count > 0 {
            self.disableBtn = false
        } else {
            self.disableBtn = true
        }
    }
    
    func savePreNote(context: NSManagedObjectContext) {
        self.isLoading = true
        self.previusSignIn()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.isLoading = false
            if self.accessTokenValid {
                self.saveNote(context: context, attemps: 0)
            }
        }
    }//End savePreNote
    
    func saveNote(context: NSManagedObjectContext, attemps: Int) {
        
        let requestNote = NoteRequest(userId: UserDefaultsPref.userId, title: title, description: description, date: Date.getDateFormat(date: Date()))
        
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
                        
                        self.alertMessage = dataResponse.Message ?? ""
                        self.isShowingAlert = true
                    } catch {
                        
                    }
                    
                case .failure(let failure):
                    if attemps == 0 {
                        print("Intento 1 de 2 para WS create note")
                        self.saveNote(context: context, attemps: 1)
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
                            self.isShowingAlert = true
                            print("60: \(self.alertMessage) - self.isShowingAlert:: \(self.isShowingAlert)")
                            
                            self.idServer = 0
                            self.titles = requestNote.title
                            self.descriptin = requestNote.description
                            self.date = requestNote.date
                            self.pendingSave = true
                            self.status = 1
                            self.saveNoteCoreData(context: context)
                        }
                    }
                    
                case nil:
                    print("Fue nil")
                }//End Switch
            }
            
        }//End fetchData
        
    }//End saveNote
}
