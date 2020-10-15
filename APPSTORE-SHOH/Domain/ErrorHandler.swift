//
//  ErrorHandler.swift
//  APPSTORE-SHOH
//
//  Created by Oh Sangho on 2020/09/18.
//  Copyright © 2020 SH-OH. All rights reserved.
//

import Foundation

final class ErrorHandler {
    static func check(_ error: Error?) -> Error {
        let _error: Error = error != nil
        ? error!
        : NSError(domain: "Unknown Error - by Local",
                  code: 0,
                  userInfo: nil) as Error
        return _error
    }
}
