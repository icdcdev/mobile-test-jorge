//
//  LoaderView.swift
//  NotesVW
//
//  Created by Devant on 29/09/25.
//

import SwiftUI
import DotLottie

struct LoaderView: View {
    
    var body: some View {
        VStack {
            DotLottieAnimation(fileName: "notes", config: AnimationConfig(autoplay: true, loop: true)).view()
        }
    }
    
}
