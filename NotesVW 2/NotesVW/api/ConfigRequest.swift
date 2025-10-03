//
//  ConfigRequest.swift
//  MexicoInteligente
//
//  Created by Jorge Espinoza on 06/02/24.
//

import Foundation
//import MultipartForm
import UIKit
import SwiftUI

class ConfigRequest {
    
    typealias Parameters = [String: String]
    
    public static func getConfiguration(url: String, type: TypeRequest, data: Data?, extraQueries: String = "") -> URLRequest {
        
        let finalUrl = "\(url)\(extraQueries)"
        
        print("WS Url: \(finalUrl)")
        
        let urlWS = URL(string: finalUrl)
        
        // Create the url request
        var request = URLRequest(url: urlWS!)
        
        request.httpMethod = type.rawValue
        
        // the request is JSON
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("*/*", forHTTPHeaderField: "Accept")
        request.setValue("04jrBgCrKYztTTixqvkP5LobndbcE0Z3gdbIqCfc", forHTTPHeaderField: "X-API-KEY")
        
        if type == .post || type == .put {
            request.httpBody = data
        }
        
        request.debug()
        
        return request
    }
    
    public static func getUrlWs(endPoint: String) -> String {
        return "\(EndPoints.PATH_MAIN)\(endPoint)"
    }
    
    public static func fetchData(request: URLRequest, completion: @escaping (Result<Data, NetworkError>?) -> Void) {
        
        if Reachability.isConnectedToNetwork() {
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                
                guard error == nil else {
                    completion(.failure(.error))
                    return
                }
                
                guard let httpResponse = response as! HTTPURLResponse? else {
                    completion(.failure(.error))
                    return
                }
                
                guard httpResponse.statusCode == 200 else {
                    if httpResponse.statusCode == 403 {
                        completion(.failure(.error403))
                    } else if httpResponse.statusCode == 500 {
                        completion(.failure(.internalServerError))
                    } else if httpResponse.statusCode == 503 || httpResponse.statusCode == 404 {
                        completion(.failure(.error503))
                    } else {
                        completion(.failure(.error))
                    }
                    return
                }
                
                guard let data = data else {
                    completion(.failure(.noData))
                    return
                }
                
                let jsonString = String(data: data, encoding: .utf8)
                debugPrint("DataReponse: \(String(describing: jsonString))")
                
                //Convertimos ese string a data para parsear a mi objeto
                let dataFromServer: Data? = jsonString?.data(using: .utf8) //
                completion(.success(dataFromServer!))
                
            }.resume()
            
        } else {
            completion(.failure(.noInternet))
        }
    }//End ftechData
}

//Estructura con los predicados de las operacions http
enum TypeRequest: String {
    case post = "POST"
    case get = "GET"
    case put = "PUT"
    case delete = "DELETE"
}

fileprivate extension URLRequest {
    func debug() {
        print("\(self.httpMethod!) \(self.url!)")
        print("Headers:")
        print(self.allHTTPHeaderFields!)
        print("Body:")
        print(String(data: self.httpBody ?? Data(), encoding: .utf8) ?? "ES get")
    }
}

enum NetworkError: Error, Equatable {
    case noInternet
    case badUrl
    case decodingError
    case noData
    case badRequest
    case error
    case error303
    case error403
    case customError(code: Int, message: String)
    case internalServerError
    case error503
    case noInternetLogin
}//NetworkError

extension NetworkError {
    
    var errorDescription: String? {
        switch self {
        case .noInternet:
            return NSLocalizedString("Sin conexión a internet, se sincronizará despúes.", comment: "")
        case .badUrl:
            return NSLocalizedString("La url está incorrecta", comment: "")
        case .decodingError:
            return NSLocalizedString("Error al decodificar", comment: "")
        case .noData:
            return NSLocalizedString("No hay información", comment: "")
        case .badRequest:
            return NSLocalizedString("Error con la petición (request)", comment: "")
        case .error:
            return NSLocalizedString("Error de comunicaciones.", comment: "")
        case .error303:
            return NSLocalizedString("Se debe enrolar nuevamente.", comment: "")
        case .error403:
            return NSLocalizedString("Por tu seguridad la sesión ha sido cerrada.", comment: "")
        case .customError(_, let message):
            return NSLocalizedString(message, comment: "")
        case .internalServerError:
            return NSLocalizedString("Error de comunicaciones.", comment: "")
        case .error503:
            return NSLocalizedString("Servicio no disponible.", comment: "")
        case .noInternetLogin:
            return NSLocalizedString("Sin conexión a internet, intente más tarde.", comment: "")
        }
    }
}
