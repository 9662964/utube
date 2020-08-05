//
//  DateExtension.swift
//  utube
//
//  Created by ILJOO CHAE on 8/5/20.
//  Copyright © 2020 ILJOO CHAE. All rights reserved.
//

import Foundation
extension Date {
    func dateAsString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        
        return formatter.string(from: self)
    }
}
