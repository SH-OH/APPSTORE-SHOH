//
//  UserdefaultsManager.swift
//  APPSTORE-SHOH
//
//  Created by Oh Sangho on 2020/09/18.
//  Copyright © 2020 SH-OH. All rights reserved.
//

import Foundation

final class UserdefaultsManager {
    enum UserDefaultEnum {
        case 최신검색어히스토리([String] = [])
        
        var name: String {
            let name: String = String(
                "\(self)".prefix(while: { $0 != "(" })
            )
            return name
        }
        
        var value: Any {
            switch self {
            case .최신검색어히스토리(let value):
                return value
            }
        }
    }
    
    class func getStringArray(_ key: UserDefaultEnum) -> [String] {
        return UserDefaults.standard.stringArray(forKey: key.name) ?? []
    }
    
    class func setValue(_ key: UserDefaultEnum) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(key.value, forKey: key.name)
        userDefaults.synchronize()
    }
    
    class func removeKey(_ key: UserDefaultEnum) {
        UserDefaults.standard.removeObject(forKey: key.name)
    }
}
