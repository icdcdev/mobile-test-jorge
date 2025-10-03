//
//  FloatingBtn.swift
//  NotesVW
//
//  Created by Devant on 30/09/25.
//
import SwiftUI

struct FloatingBtn: View {
    
    let action: () -> ()
    
    var body: some View {
        
        VStack {
            Spacer() // Pushes the button to the bottom
            HStack {
                Spacer() // Pushes the button to the right
                
                Button(action: {
                    action()
                    // Action to perform when the button is tapped
                    print("FAB tapped!")
                }) {
                    Image(systemName: "pencil") // Or any other SF Symbol or custom image
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue) // Customize background color
                        .clipShape(Circle()) // Makes the button circular
                        .shadow(radius: 5) // Adds a subtle shadow for a floating effect
                }
                .padding(.trailing, 20) // Adjust padding from the right edge
                .padding(.bottom, 20) // Adjust padding from the bottom edge
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
            }
        }
        
    }//End body
    
}//End View
