//
//  AlertView.swift
//  NotesVW
//
//  Created by Devant on 30/09/25.
//
import SwiftUI

struct AlertView: View {
    
    @State private var offset: CGFloat = 1000
    @Binding var isPresented: Bool
    var message: String
    let action: () -> ()
    
    var body: some View {
        
        if isPresented {
        
            VStack {
                
                ZStack(alignment: Alignment(horizontal: .center, vertical: .center)) {
                    
                    VStack {
                        
                        VStack {
                            
                        }.frame(maxWidth: .infinity, maxHeight: 70, alignment: .center)
                            .background(.clear)
                        
                        VStack {
                            
                            VStack(alignment: .center, spacing: 8) {
                                
                                Spacer()
                                
                                Text("Aviso").frame(maxWidth: .infinity, alignment: .center)
                                    .font(.system(size: 33, weight: .regular, design: .default))
                                    .frame(maxWidth: .infinity)
                                    .padding([.top], 32)
                                    .foregroundStyle(Colors.blueTitle)
                                
                                Spacer()
                                
                                Text("\(message)").frame(width: 300, height: 40)
                                    .multilineTextAlignment(.center)
                                    .font(.system(size: 16, weight: .semibold, design: .default))
                                    .foregroundStyle(Colors.textColor)
                                
                                Spacer()
                                
                                HStack(spacing: 16) {
                                    
                                    Button("Aceptar", action: {
                                        action()
                                        closeDialog()
                                    })
                                    .frame(width: 210, height: 15)
                                    .font(.system(size: 18, weight: .regular, design: .default))
                                    .fontWeight(.bold)
                                    .padding()
                                    .foregroundStyle(Color.white)
                                    .background(Colors.blueTitle)
                                    .cornerRadius(8.0)
                                    
                                }.frame(maxWidth: .infinity)
                                    .padding([.bottom], 24)
                            }
                            
                        }.frame(maxWidth: .infinity, maxHeight: 250)
                            .background(.white)
                        
                    }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        .background(.clear)
                    
                    VStack {
                        Image("warning")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 110, height: 110, alignment: .top)
                            .foregroundColor(.gray)
                            .background(Colors.colorIcWarning)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, style: StrokeStyle(lineWidth: 10)))
                    }.padding([.bottom], 190)
                    
                }
                .frame(maxWidth: .infinity, maxHeight: 370, alignment: .center)
                .background(Colors.textColor)
                .cornerRadius(15)
                .padding([.horizontal], 16)
                .overlay {
                    
                    VStack {
                        
                        HStack {
                            
                            Spacer()
                            
                            Button {
                                closeDialog()
                            } label: {
                                Image(systemName: "xmark")
                                    .font(.title2)
                                    .fontWeight(.medium)
                            }.tint(.white)
                        }
                        
                        Spacer()
                    }
                    .padding([.horizontal], 16)
                    .padding()
                }
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black.opacity(0.45).edgesIgnoringSafeArea(.all))
            .offset(x: 0, y: offset)
            .onAppear {
                withAnimation(.spring()) {
                    offset = 0
                }
            }
        
        }
        
    }//End main view
    
    func closeDialog() {
        withAnimation(.spring()) {
            offset = 1000
            self.isPresented = false
        }
    }
}
