//
//  AuthViewModel.swift
//  NotesVW
//
//  Created by Jorge Espinoza on 29/09/25.
//

import Foundation
import SwiftUI
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

class AuthViewModel: BaseViewModel {
    
    @Published var loginState = false
    
    //Primera vez
    func firstSignIn(root: BackView) {
        
        if Reachability.isConnectedToNetwork() {
            guard let clientID = FirebaseApp.app()?.options.clientID else { return }
            
            let configuration = GIDConfiguration(clientID: clientID)
            GIDSignIn.sharedInstance.configuration = configuration
            
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
            
            guard let rootViewController = windowScene.windows.first?.rootViewController else { return }
            
            GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { [unowned self] user, error in
                authUser(user: user, error: error, root: root)
            }
        } else {
            self.alertMessage = "\(NetworkError.noInternetLogin.errorDescription ?? "")"
            self.isShowingAlert = true
            print(NetworkError.noInternetLogin.errorDescription!)
        }
    }
    
    //Se llama en el primer login cuando se instala la app
    func authUser(user: GIDSignInResult?, error: Error?, root: BackView){
        
        if let error = error {
            print("Error al iniciar sesion: ", error.localizedDescription)
            setUpAlertError(message: "Los servicios de Google no estan disponibles.")
            //self.isLoading = false
            return
        }
        
        guard let authentication = user?.user, let idToken = authentication.idToken?.tokenString else { return }
        
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken.tokenString)
        
        Auth.auth().signIn(with: credential) { [unowned self] (_, error) in
            if let error = error {
                print("Error al iniciar sesion: ",error.localizedDescription)
                setUpAlertError(message: "Los servicios de Google no estan disponibles.")
            } else {
                DispatchQueue.main.async {
                    //Aqui esta el problema del login a home
                    self.loginState = true
                    self.accessTokenValid = true
                    UserDefaultsPref.tokenIdGoogle = idToken
                    UserDefaultsPref.accessTokenGoogle = authentication.accessToken.tokenString
                    UserDefaultsPref.dateExpTokenGoogle = authentication.accessToken.expirationDate ?? Date()

                    let user = GIDSignIn.sharedInstance.currentUser
                    
                    let request = UserRequest(name: user?.profile?.name ?? "Example Perez", email: user?.profile?.email ?? "example@gmail.com", photo: user?.profile?.imageURL(withDimension: 200)?.absoluteString ?? "")
                    
                    self.saveUser(request: request, root: root)
                }
            }
        }
    }//End AuthUser
    
    func setUpAlertError(message: String) {
        self.alertMessage = message
        self.isShowingAlert = true
    }
}
