//
//  Extensions.swift
//  NotesVW
//
//  Created by Devant on 29/09/25.
//

import Foundation
import SwiftUI
import UIKit

extension View {
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
}

extension Date {
    
    static func getDateFormat(date: Date) -> String {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, HH:mm a"
        dateFormatter.locale = Locale(identifier: "es_MX")
        
        return dateFormatter.string(from: date)
    }
    
}
