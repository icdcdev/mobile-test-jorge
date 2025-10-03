//
//  CreateNoteView.swift
//  NotesVW
//
//  Created by Devant on 30/09/25.
//

import SwiftUI

struct CreateNoteView: View {

    @StateObject var viewModel = CreateNoteViewModel()
    @EnvironmentObject var root : BackView
    @Environment(\.managedObjectContext) var viewContext
    
    var body: some View {
        
        ZStack {
            
            ScrollView() {
                
                VStack(spacing: 25) {
                    
                    ZStack(alignment: .leading) {
                        
                        Text("Titulo de la nota")
                            .font(.system(size: 16, weight: .medium, design: .default))
                            .foregroundColor(viewModel.title.isEmpty ? Color(.placeholderText) : Colors.blueTitle)
                            .offset(y: viewModel.title.isEmpty ? 0 : -36)
                            .scaleEffect(viewModel.title.isEmpty ? 1 : 0.9, anchor: .leading)
                            .padding([.horizontal], 8)
                        
                        TextField("Titulo de la nota (opcional)", text: $viewModel.title).onChange(of: viewModel.title) { newValue in
                            viewModel.validateFields()
                        }
                        .frame(height: 45)
                        .font(.system(size: 16, weight: .regular, design: .default))
                        .accentColor(.gray)
                        .textFieldStyle(PlainTextFieldStyle())
                        .disableAutocorrection(true)
                        .padding([.horizontal], 16)
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
                        .background(.white)
                    }
                    .padding([.top], 8)
                    
                    Text("Escribe tu nota abajo")
                        .font(.system(size: 16, weight: .semibold, design: .default))
                        .foregroundStyle(Colors.textColor)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding([.leading, .trailing], 8)
                    
                    ZStack(alignment: .leading) {
                        
                        Image("note")
                            .resizable()
                            .frame(maxWidth: .infinity, maxHeight: 200)
                            .scaledToFill()
                                        
                        TextEditor(text: $viewModel.description).onChange(of: viewModel.description) { newValue in
                            viewModel.validateFields()
                        }
                        .frame(maxHeight: 200)
                        .font(.system(size: 16, weight: .regular, design: .default))
                        .accentColor(.gray)
                        .textFieldStyle(PlainTextFieldStyle())
                        .disableAutocorrection(true)
                        .padding([.horizontal], 16)
                        .scrollContentBackground(.hidden) // Hides the default background
                        .background(Color.clear) //
                        /*.background(Image("note", bundle: nil)
                            .resizable()
                            .scaledToFill())*/
                    }
                    
                    Spacer()
                    
                    GenericBtn(name: "Guardar", disableBtn: $viewModel.disableBtn) {
                        viewModel.savePreNote(context: viewContext)
                    }
                    
                }//End VStack
                .padding(16)
                .frame(maxWidth: .infinity)
                .navigationBarTitle("Crear nota")
                .navigationBarBackButtonHidden()
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(leading: Button(action: {
                    root.path.removeLast()
                }){Image("back").font(Font.system(size:10, design: .serif)).padding(.leading,-6)})
                
            }//End Scrollview
            .onAppear {
                // Código ejecutado cuando aparece la vista
                print("Mostrando vista")
            }
            .onDisappear {
                // Código ejecutado cuando desaparece la vista
                print("Matando vista")
            }
            .onTapGesture {
                self.hideKeyboard()
            }
            
            if viewModel.isLoading {
                GeometryReader { _ in
                    LoaderView()
                }.background(Color.black.opacity(0.45).edgesIgnoringSafeArea(.all))
            }
            
            AlertView(isPresented: $viewModel.isShowingAlert, message: viewModel.alertMessage){
                root.path.removeLast()
            }
        }
        
        
    }
}
