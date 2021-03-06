//
//  HypeError.swift
//  utube
//
//  Created by ILJOO CHAE on 8/5/20.
//  Copyright © 2020 ILJOO CHAE. All rights reserved.
//

import Foundation

enum HypeError: LocalizedError {
    
    case ckError(Error)
    case couldNotUnwrap
    case unableToDeleteRecord
    
    var errorDescription: String? {
        switch self {
        case .ckError(let error):
            return error.localizedDescription
        case .couldNotUnwrap:
            return "Unable to get this Hype."
        case .unableToDeleteRecord:
            return "Unable to delete hype record form the cloud"
        }
    }
}
