//
//  EndPoints.swift
//  MexicoInteligente
//
//  Created by Jorge Espinoza on 06/02/24.
//

import Foundation

struct EndPoints {
    
    static let PATH_MAIN = "https://rjempresarial.com/gruporj/"
    
    struct Register {
        static let WS_PHP_SAVE_USER = "saveuser"
        static let WS_PHP_SAVE_NOTE = "savenote"
    }
    
    struct GetInfo {
        static let WS_PHP_GET_NOTES = "getnotesbyuser"
    }
    
    struct Delete {
        static let WS_PHP_DELETE_NOTE = "deletenotebyid"
    }
}
