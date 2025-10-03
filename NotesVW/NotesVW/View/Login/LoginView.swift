//
//  LoginView.swift
//  NotesVW
//
//  Created by Jorge Espinoza on 29/09/25.
//

import SwiftUI

struct LoginView: View {
    
    //@EnvironmentObject var viewModel: AuthViewModel
    @StateObject private var viewModel = AuthViewModel()
    @EnvironmentObject var root: BackView
    
    var body: some View {
        
        ZStack() {
            
            VStack(alignment: .center){
                
                Text("Bienvenido")
                    .fontWeight(.black)
                    .foregroundColor(Colors.textColor)
                    .font(.largeTitle)
                
                Text("Por favor inicia sesión con tu cuenta de google.").frame(maxWidth: .infinity)
                    .multilineTextAlignment(.leading)
                    .font(.system(size: 20, weight: .regular, design: .default))
                    .frame(maxWidth: .infinity)
                        .padding([.top], 24)
                        .foregroundColor(Colors.textColor)
                
                GoogleBtn()
                    .frame(maxWidth: .infinity)
                        .padding([.top], 24)
                    .onTapGesture {
                        viewModel.firstSignIn(root: root)
                    }
            }.padding()
            
            if viewModel.isLoading {
                GeometryReader { _ in
                    LoaderView()
                }.background(Color.black.opacity(0.45).edgesIgnoringSafeArea(.all))
            }
            
            AlertView(isPresented: $viewModel.isShowingAlert, message: viewModel.alertMessage){
                
            }
            
        }//End ZStack
        .navigationBarTitle("")
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        
    }//End Body
    
}
