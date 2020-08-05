//
//  Hype.swift
//  utube
//
//  Created by ILJOO CHAE on 8/5/20.
//  Copyright © 2020 ILJOO CHAE. All rights reserved.
//

import Foundation
import CloudKit

struct HypeConstants {
     static let recordTypeKey = "Hype"
    fileprivate static let bodyKey = "body"
    fileprivate static let timestampKey = "timestamp"
}

class Hype {
    var body: String
    var timestamp: Date
    
    init(body: String, timestamp: Date = Date()) {
        self.body = body
        self.timestamp = timestamp
    }
}


//take Hype and convert to CkRecord
extension CKRecord {
    convenience init(hype: Hype) {
        self.init(recordType: HypeConstants.recordTypeKey)
//        Option 1
//        self.init(recordType: HypeConstants.recordTypeKey)
//        self.setValue(hype.body, forKey: HypeConstants.bodyKey)
//        self.setValue(hype.timestamp, forKey: HypeConstants.timestampKey)

//        Option 2
        self.setValuesForKeys([
            HypeConstants.bodyKey : hype.body,
            HypeConstants.timestampKey : hype.timestamp
        ])
    }
}

//Taks CKRecord and covert to Hype
extension Hype {
    convenience init?(ckRecord: CKRecord) {
        guard let body = ckRecord[HypeConstants.bodyKey] as? String,
            let timestamp = ckRecord[HypeConstants.timestampKey] as? Date else {return nil}
    
        self.init(body: body, timestamp: timestamp)
    }
}
