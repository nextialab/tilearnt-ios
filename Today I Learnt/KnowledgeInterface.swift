//
//  KnowledgeInterface.swift
//  Today I Learnt
//
//  Created by Nelson Iván González on 6/30/16.
//  Copyright © 2016 Nelson Iván González. All rights reserved.
//

import UIKit

class KnowledgeInterface: NSObject {

    static let sURL = "http://localhost:9000"
    
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
