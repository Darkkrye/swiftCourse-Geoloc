//
//  APIController.swift
//  TP1Geoloc
//
//  Created by etudiant on 16/11/2016.
//  Copyright © 2016 etudiant. All rights reserved.
//

import Foundation

protocol APIControllerDelegate {
    func returnedInformation(data: Data, statusCode: Int)
}

class APIController {
    static let sharedInstance = APIController()
    static let ENDPOINT = "http://10.33.0.135:8888/ESGI/2016-2017/MOC/4A/"
    
    var delegate: APIControllerDelegate?
    
    private init() {}
    
    func getInformation() {
        var request = URLRequest(url: URL(string: APIController.ENDPOINT)!)
        
        request.httpMethod = "GET"
        request.addValue("Content-Type", forHTTPHeaderField: "application/json")
        
        let session = URLSession.shared
        session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            if (error != nil) {
                print("ERREUR : \(error)")
            } else {
                let realResponse = response as! HTTPURLResponse
                if let delegate = self.delegate {
                    delegate.returnedInformation(data: data!, statusCode: realResponse.statusCode)
                }
            }
            
        }).resume()
    }
}
