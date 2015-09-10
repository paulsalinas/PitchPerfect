//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Paul Salinas on 2015-08-31.
//  Copyright (c) 2015 Paul Salinas. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject{
    var filePathUrl: NSURL!
    var title: String!
    
    init(filePathUrl: NSURL!, title: String!) {
        self.filePathUrl = filePathUrl
        self.title  = title
    }
}
