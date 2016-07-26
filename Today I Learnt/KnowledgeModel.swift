//
//  KnowledgeModel.swift
//  Today I Learnt
//
//  Created by Nelson Iván González on 6/30/16.
//  Copyright © 2016 Nelson Iván González. All rights reserved.
//

import UIKit

class KnowledgeModel: NSObject {

    /**
     Contains the text of a piece of knowledge
     */
    var text: String
    /**
     If true then the piece of knowledge is in sync with the cloud
     */
    var published: Bool
    
    init(text: String?, published: Bool) {
        if let mText = text {
            self.text = mText
        } else {
            self.text = ""
        }
        self.published = published
    }
    
}
