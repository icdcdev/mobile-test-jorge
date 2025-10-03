//
//  NoteRow.swift
//  NotesVW
//
//  Created by Devant on 30/09/25.
//

import SwiftUI

struct NoteRow: View {
    
    var note: Note
    let action: () -> ()
    
    var body: some View {
        
        ZStack() {
            
            VStack {
                
                HStack {
                    
                    Spacer()
                    
                    Text(note.date ?? "Sin fecha")
                        .font(.system(size: 16, weight: .semibold, design: .default))
                        .foregroundStyle(Colors.textColor)
                        .frame(width: 170, alignment: .trailing)
                        .padding([.leading, .trailing], 8)
                }
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                
                VStack(spacing: 8) {
                    Text(note.title ?? "").frame(maxWidth: .infinity, alignment: .leading)
                        .font(.system(size: 15, weight: .semibold, design: .default))
                        .foregroundStyle(Colors.blueTitle)
                        .padding([.leading, .trailing], 8)
                    
                    Text(note.description ?? "").frame(maxWidth: .infinity, alignment: .leading)
                        .font(.system(size: 14, weight: .regular, design: .default))
                        .padding([.top, .bottom], 4)
                        .padding([.leading, .trailing], 8)
                }
            }
            .frame(maxWidth: .infinity)
            .background(Image("note", bundle: nil)
                .resizable()
                .scaledToFill())
            .padding([.top, .bottom], 8)
            .padding([.leading, .trailing], 12)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(color: Color(red: 150/255, green: 150/255, blue: 150/255, opacity: 0.7), radius: 10, x: 2, y: 3)
            
            Button(action: {
                action()
                print("Custom image button tapped!")
            }) {
                Image("borrar")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
            }
            .padding(.trailing, 20) // Adjust padding from the right edge
            .padding(.bottom, 20) // Adjust padding from the bottom edge
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
        }//End ZStack
        
        
        
    }//End body
}

struct NoteRow2: View {
    
    var note: Notes
    let action: () -> ()
    
    var body: some View {
        
        ZStack() {
            
            VStack {
                
                HStack {
                    
                    Spacer()
                    
                    Text(note.date ?? "Sin fecha")
                        .font(.system(size: 16, weight: .semibold, design: .default))
                        .foregroundStyle(Colors.textColor)
                        .frame(width: 170, alignment: .trailing)
                        .padding([.leading, .trailing], 8)
                }
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                
                VStack(spacing: 8) {
                    Text(note.title ?? "").frame(maxWidth: .infinity, alignment: .leading)
                        .font(.system(size: 15, weight: .semibold, design: .default))
                        .foregroundStyle(Colors.blueTitle)
                        .padding([.leading, .trailing], 8)
                    
                    Text(note.descriptin ?? "").frame(maxWidth: .infinity, alignment: .leading)
                        .font(.system(size: 14, weight: .regular, design: .default))
                        .padding([.top, .bottom], 4)
                        .padding([.leading, .trailing], 8)
                        .lineLimit(3)
                }
            }
            .frame(maxWidth: .infinity)
            .background(Image("note", bundle: nil)
                .resizable()
                .scaledToFill())
            .padding([.top, .bottom], 8)
            .padding([.leading, .trailing], 12)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(color: Color(red: 150/255, green: 150/255, blue: 150/255, opacity: 0.7), radius: 10, x: 2, y: 3)
            
            Button(action: {
                action()
                print("Custom image button tapped!")
            }) {
                Image("borrar")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
            }
            .padding(.trailing, 20) // Adjust padding from the right edge
            .padding(.bottom, 20) // Adjust padding from the bottom edge
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
        }//End ZStack
        
        
        
    }//End body
}
