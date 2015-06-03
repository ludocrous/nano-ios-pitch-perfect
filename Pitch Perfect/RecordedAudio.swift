//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Derek Crous on 02/06/2015.
//  Copyright (c) 2015 Ludocrous Software. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {
    var filePathUrl : NSURL!
    var title : String!
    
    init(filePathUrl : NSURL, title : String) {
        self.filePathUrl = filePathUrl
        self.title = title
    }
}
