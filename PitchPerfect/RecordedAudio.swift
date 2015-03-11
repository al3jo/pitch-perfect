//
//  RecordedAudio.swift
//  PitchPerfect
//
//  Created by alejo on 3/10/15.
//  Copyright (c) 2015 alejo software. All rights reserved.
//

import Foundation

/// Object that stores metainfo about a recorded audio
class RecordedAudio: NSObject {
    var filePathUrl: NSURL!
    var title: String!
    
    /// Constructor for a RecordedAudio object
    ///
    /// :param: filePathUrl a NSURL to the path of the recorded file
    /// :param: title the title of this audio file
    init(filePathUrl: NSURL!, title: String!) {
        self.filePathUrl = filePathUrl
        self.title = title
    }
}