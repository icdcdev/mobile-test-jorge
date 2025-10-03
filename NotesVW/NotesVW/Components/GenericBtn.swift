//
//  GenericBtn.swift
//  NotesVW
//
//  Created by Devant on 30/09/25.
//

import SwiftUI

struct GenericBtn: View {
    
    var name: String
    @Binding var disableBtn: Bool
    let action: () -> ()
    
    /*init(name: String = "", disableBtn: Bool = false, action: @escaping () -> Void) {
        self.name = name
        self.disableBtn = disableBtn
        self.action = action
    }*/
    
    var body: some View {
        
        VStack {
            
            Button(self.name, action: {
                action()
                print("Boton generico presionado")
             })
            .frame(maxWidth: .infinity, minHeight: 18)
            .font(.system(size: 18, weight: .semibold, design: .default))
             .padding()
             .foregroundStyle(.white)
             .background(disableBtn ? Colors.disableBtn : Colors.blueTitle)
             .cornerRadius(8.0)
             .disabled(disableBtn)
        }
        
    }//End body
    
}//End View
