//
//  BaseViewModel.swift
//  NotesVW
//
//  Created by Devant on 29/09/25.
//
import Foundation
import Combine
import SwiftUI
import UIKit
import GoogleSignIn
import FirebaseAuth
import Network
import CoreData

class BaseViewModel: ObservableObject {
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    @Published var isConnected: Bool = false
    @Published var isLoading: Bool = false
    @Published var alertMessage: String = ""
    @Published var isShowingAlert: Bool = false
    @Published var disableBtn: Bool = true
    @Published var accessTokenValid = false
    @Published var isSuccessSignOut: Bool = false
    @Published var idServer = 0
    @Published var titles = ""
    @Published var descriptin = ""
    @Published var date = ""
    @Published var pendingSave = false
    @Published var status = 0
    
    func saveUser(request: UserRequest, root: BackView) {
        
        self.isLoading = true
        
        let url = ConfigRequest.getUrlWs(endPoint: EndPoints.Register.WS_PHP_SAVE_USER)
        
        guard let jsonData = try? JSONEncoder().encode(request) else {
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
                        
                        if dataResponse.Status {
                            UserDefaultsPref.userId = dataResponse.userId ?? 0
                            UserDefaultsPref.userName = dataResponse.name ?? "Sin nombre"
                            UserDefaultsPref.userEmail = dataResponse.email ?? "Sin email"
                            UserDefaultsPref.userPhoto = dataResponse.photo ?? ""
                            UserDefaultsPref.lastLogin = Date.getDateFormat(date: Date())
                            
                            print("Llendo a home")
                            root.path.append(Routes.Home)//Quitar
                        } else {
                            self.clearUserDefaults()
                        }
                    } catch {
                        
                    }
                    
                case .failure(let failure):
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
                    }
                    
                case nil:
                    print("Fue nil")
                }//End Switch
            }
            
        }//End fetchData
        
    }//End saveUser
    
    func signOut(root: BackView, context: NSManagedObjectContext? = nil) {
        GIDSignIn.sharedInstance.signOut()
        do{
            print("Limpiando todo para cerrar sesion")
            try Auth.auth().signOut()
            self.clearUserDefaults()
            
            if let newContext = context {
                //Borro la tabla de la base de datos interna
                self.deleteAllRecords(entityName: Constants.TABLE_NOTES, context: newContext)
            }
            
            root.path.append(Routes.Login)
        }catch {
            print(error.localizedDescription)
        }
    }
    
    func clearUserDefaults() {
        UserDefaultsPref.accessTokenGoogle = ""
        UserDefaultsPref.tokenIdGoogle = ""
        UserDefaultsPref.userName = ""
        UserDefaultsPref.userPhoto = ""
        UserDefaultsPref.userId = 0
        UserDefaultsPref.dateExpTokenGoogle = Date()
    }
    
    func previusSignIn(){
        if GIDSignIn.sharedInstance.hasPreviousSignIn() {
            //Existe registro previo
            GIDSignIn.sharedInstance.restorePreviousSignIn() { [unowned self] user, error in
                
                let dateTokenFirebaseCodi = UserDefaultsPref.dateExpTokenGoogle
                let dateToday = Date()
                
                print("Fecha de expiracion:: \(dateTokenFirebaseCodi)")
                print("Fecha actual:: \(dateToday)")
                
                if dateToday > dateTokenFirebaseCodi {
                    print("Access Token expirado, obteniendo otro")
                    refreshAccessTokenIfNeeded(user: user!)
                } else {
                    print("Access Token valido, continuando peticion")
                    self.accessTokenValid = true
                }
            }
        }
    }//End previusSignIn
    
    func refreshAccessTokenIfNeeded(user: GIDGoogleUser) {
        user.refreshTokensIfNeeded { refreshedUser, error in
            DispatchQueue.main.async {
                if let refreshedUser = refreshedUser {
                    self.accessTokenValid = true
                    UserDefaultsPref.accessTokenGoogle = refreshedUser.accessToken.tokenString
                    UserDefaultsPref.dateExpTokenGoogle = refreshedUser.accessToken.expirationDate ?? Date()
                    print("Access token refreshed successfully.")
                } else {
                    self.accessTokenValid = false
                    print("Error refreshing access token: \(error?.localizedDescription ?? "unknown error")")
                    //self.signOut() // Example: sign out if refresh fails
                }
            }
        }
    }
    
    //*********************************Monitoring Internet*******************//
    func startMonitoring() {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.isConnected = path.status == .satisfied
                print("Internet connection: \(self.isConnected)") // For debugging
            }
        }
        monitor.start(queue: queue)
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
    
    //*********************************Core Data*****************************//
    func saveNoteCoreData(context: NSManagedObjectContext) {
        let newNote = Notes(context: context)
        newNote.idServer = Int64(idServer)
        newNote.title = titles
        newNote.descriptin = descriptin
        newNote.date = date
        newNote.pendingSave = pendingSave
        newNote.status = Int16(status)
        
        do {
            try context.save()
            print("Nota guardada en CoreData, esperando a sincronizar")
        } catch let error as NSError {
            print("No guardo", error.localizedDescription)
        }
    }//End saveNoteCoreData
    
    func deleteNoteCoreData(item: Notes, context: NSManagedObjectContext) {
        //Borrado correcto de Base de datos
        //context.delete(item)
        
        //Borrado solo updateando el status = 0
        item.status = 0
        do {
            try context.save()
            print("Nota eliminada de CoreData, esperando a sincronizar")
            
            self.deleteNoteById(noteId: Int(item.idServer))
        } catch let error as NSError {
            print("No elimino", error.localizedDescription)
        }
    }//End deleteNoteCoreData
    
    func deleteAllRecords(entityName: String, context: NSManagedObjectContext) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(batchDeleteRequest)
            context.reset()
            try context.save()
            print("Se trunco la tabla para que se pueda llenar con el WS")
        } catch {
            print("Error deleting records from \(entityName): \(error.localizedDescription)")
        }
    }//End deleteAllRecords
    
    func deleteNoteById(noteId: Int) {
        let url = ConfigRequest.getUrlWs(endPoint: EndPoints.Delete.WS_PHP_DELETE_NOTE)
        let extraQueries = "?noteId=\(noteId)"
        
        let request = ConfigRequest.getConfiguration(url: url, type: .get, data: nil, extraQueries: extraQueries)
        ConfigRequest.fetchData(request: request) { (result) in
            
            DispatchQueue.main.async {
                
                switch result {
                    
                case .success(let response):
                    do {
                        let decoder = JSONDecoder()
                        
                        let dataResponse = try decoder.decode(NotesResponse.self, from: response)
                        
                        if dataResponse.Status {
                            print("Se elimino la nota del server")
                        } else {
                            print("No se pudo eliminar la nota del server")
                        }
                    } catch {
                        
                    }
                    
                case .failure(let failure):
                    if failure == NetworkError.error403 {
                        print("56: \(self.alertMessage)")
                    } else if failure == NetworkError.badRequest { // Revisar si corresponde al 409
                        print("58: \(self.alertMessage)")
                    } else {
                        print("60: \(self.alertMessage) - self.isShowingAlert:: \(self.isShowingAlert)")
                    }
                    
                case nil:
                    print("Fue nil")
                }//End Switch
            }
            
        }//End fetchData
        
    }//End deleteNoteById
    
    func updateUploadNoteCoreData(item: Notes, context: NSManagedObjectContext) {
        //updateando el pendingSave = 0, ya se fue al server
        item.pendingSave = false
        do {
            try context.save()
            print("Nota se guardo en el server")
            
            self.deleteNoteById(noteId: Int(item.idServer))
        } catch let error as NSError {
            print("Error al actualizar pendingSave", error.localizedDescription)
        }
    }//End updateUploadNoteCoreData
}
