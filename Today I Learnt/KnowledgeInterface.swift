//
//  KnowledgeInterface.swift
//  Today I Learnt
//
//  Created by Nelson Iván González on 6/30/16.
//  Copyright © 2016 Nelson Iván González. All rights reserved.
//

import UIKit

class KnowledgeInterface: NSObject {

    /**
     Base URL of the web services
     */
    static let sURL = "http://localhost:9000"
    
    /**
     Performs a GET request to the endpoint / to get a list of pieces of knowledge from the cloud.
     - Parameters:
        - handler: handler to be called when a response is received
     */
    static func getKnowledges(handler: (NSData?, NSURLResponse?, NSError?) -> Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: sURL)!)
        request.HTTPMethod = "GET"
        (NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: handler)).resume()
    }
    
    /**
     Performs a POST request to the endpoint / to save a new piece of knowledge to the cloud.
     - Parameters:
        - knowledge: text of new piece of knowledge to be saved in the cloud
        - handler: handler to be called when a reponse is received
     */
    static func postKnowledge(knowledge: String, handler: (NSData?, NSURLResponse?, NSError?) -> Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: sURL)!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let data = ["knowledge": knowledge]
        do {
            let json = try NSJSONSerialization.dataWithJSONObject(data, options: NSJSONWritingOptions(rawValue: 0))
            request.HTTPBody = json
        } catch let JSONError as NSError {
            print("Error: \(JSONError)")
        }
        (NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: handler)).resume()
    }
    
}
