//
//  ProfileView.swift
//  NotesVW
//
//  Created by Devant on 30/09/25.
//

import SwiftUI
import CoreData

struct ProfileView: View {

    @EnvironmentObject var viewModel: ProfileViewModel
    @EnvironmentObject var root: BackView
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        
        VStack() {
            
            AsyncImage(url: URL(string: viewModel.photo)) { phase in
                    switch phase {
                    case .empty:
                        Text("Imagen no disponible")
                    case .failure:
                        Text("Imagen no disponible")
                    case .success(let image):
                        // Apply modifiers to the loaded image
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    @unknown default:
                        Divider()
                            .padding([.leading, .trailing], 16)
                    }
            }
            .frame(width: 350, height: 200)
            .padding([.bottom], 8)
            
            //Name and email
            VStack {
                
                HStack {
                    
                    VStack {
                        
                        Text("\(viewModel.name)")
                            .font(.system(size: 23, weight: .bold, design: .default))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding([.leading, .trailing], 16)
                                .foregroundColor(Colors.textColor)
                    }
                    
                    Image("user", bundle: nil)
                      .resizable()
                      .scaledToFill()
                      .frame(width: 60, height: 60, alignment: .leading)
                      .padding(10)
                    
                }
                
                Divider()
                    .padding([.leading, .trailing], 16)
                
                VStack {
                    
                    Text("Email registrado")
                        .font(.system(size: 17, weight: .regular, design: .default))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding([.top], 4)
                        .padding([.leading, .trailing], 16)
                            .foregroundColor(Colors.textColor)
                    
                    Text("\(viewModel.email)")
                        .font(.system(size: 20, weight: .bold, design: .default))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding([.top], 1)
                        .padding([.leading, .trailing], 16)
                        .padding([.bottom], 16)
                        .foregroundColor(Colors.textColor)
                    
                }
                
                Divider()
                    .padding([.leading, .trailing], 16)
                
                VStack {
                    
                    Text("Ultimo inicio de sesión")
                        .font(.system(size: 17, weight: .regular, design: .default))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding([.top], 4)
                        .padding([.leading, .trailing], 16)
                            .foregroundColor(Colors.textColor)
                    
                    Text("\(UserDefaultsPref.lastLogin)")
                        .font(.system(size: 16, weight: .bold, design: .default))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding([.top], 1)
                        .padding([.leading, .trailing], 16)
                        .padding([.bottom], 16)
                        .foregroundColor(Colors.textColor)
                    
                }
            }
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .shadow(color: Color(red: 150/255, green: 150/255, blue: 150/255, opacity: 0.7), radius: 10, x: 1, y: 2)
            
            GenericBtn(name: "Cerrar sesión", disableBtn: $viewModel.disableBtnSession) {
                viewModel.signOut(root: root, context: viewContext)
            }
            .padding([.top], 16)
            
            Spacer()
            
        }//End VStack
        .padding(16)
        .frame(maxWidth: .infinity)
        .navigationBarTitle("Mi perfil")
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(leading: Button(action: {
            root.path.removeLast()
        }){Image("back").font(Font.system(size:10, design: .serif)).padding(.leading,-6)})
        .onAppear {
            // Código ejecutado cuando aparece la vista
            print("Mostrando vista")
            //viewModel.setUpInfoUser()
        }
        .onDisappear {
            // Código ejecutado cuando desaparece la vista
            print("Matando vista")
        }
    }
}
