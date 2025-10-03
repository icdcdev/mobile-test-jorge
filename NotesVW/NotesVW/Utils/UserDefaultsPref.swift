//
//  UserDefaults.swift
//  NotesVW
//
//  Created by Jorge Espinoza on 29/09/25.
//

import Foundation
import UIKit

struct UserDefaultsPref {
    
    static var userId: Int {
        get {
            return UserDefaults.standard.integer(forKey: Constants.DEFAULT_USER_ID)
        } set (value) {
            UserDefaults.standard.set(value, forKey: Constants.DEFAULT_USER_ID)
            UserDefaults.standard.synchronize()
        }
    }
    
    static var userName: String {
        get {
            return UserDefaults.standard.string(forKey: Constants.DEFAULT_USER_NAME) ?? ""
        } set (value) {
            UserDefaults.standard.set(value, forKey: Constants.DEFAULT_USER_NAME)
            UserDefaults.standard.synchronize()
        }
    }
    
    static var userEmail: String {
        get {
            return UserDefaults.standard.string(forKey: Constants.DEFAULT_USER_EMAIL) ?? ""
        } set (value) {
            UserDefaults.standard.set(value, forKey: Constants.DEFAULT_USER_EMAIL)
            UserDefaults.standard.synchronize()
        }
    }
    
    static var userPhoto: String {
        get {
            return UserDefaults.standard.string(forKey: Constants.DEFAULT_USER_PHOTO) ?? ""
        } set (value) {
            UserDefaults.standard.set(value, forKey: Constants.DEFAULT_USER_PHOTO)
            UserDefaults.standard.synchronize()
        }
    }
    
    static var tokenIdGoogle: String {
        get {
            return UserDefaults.standard.string(forKey: Constants.DEFAULT_ID_TOKENG) ?? ""
        } set (value) {
            UserDefaults.standard.set(value, forKey: Constants.DEFAULT_ID_TOKENG)
            UserDefaults.standard.synchronize()
        }
    }
    
    static var accessTokenGoogle: String {
        get {
            return UserDefaults.standard.string(forKey: Constants.DEFAULT_ACCESS_TOKENG) ?? ""
        } set (value) {
            UserDefaults.standard.set(value, forKey: Constants.DEFAULT_ACCESS_TOKENG)
            UserDefaults.standard.synchronize()
        }
    }
    
    static var dateExpTokenGoogle : Date {
        get {
            return UserDefaults.standard.object(forKey: Constants.DEFAULT_DATE_EXP_TOKENG) as? Date ?? Date()
        }
        set(value) {
            UserDefaults.standard.set(value, forKey: Constants.DEFAULT_DATE_EXP_TOKENG)
            UserDefaults.standard.synchronize()
        }
    }
    
    static var lastLogin: String {
        get {
            return UserDefaults.standard.string(forKey: Constants.DEFAULT_LAST_LOGIN) ?? "Hoy"
        } set (value) {
            UserDefaults.standard.set(value, forKey: Constants.DEFAULT_LAST_LOGIN)
            UserDefaults.standard.synchronize()
        }
    }
}
