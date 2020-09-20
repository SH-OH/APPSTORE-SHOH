//
//  UserdefaultsManager.swift
//  KAKAOBANK-SHOH
//
//  Created by Oh Sangho on 2020/09/18.
//  Copyright © 2020 SH-OH. All rights reserved.
//

import Foundation

final class UserdefaultsManager {
    enum UserDefaultEnum: String {
        case 최신검색어히스토리
    }
    
    class func getStringArray(_ key: UserDefaultEnum) -> [String] {
        return UserDefaults.standard.stringArray(forKey: key.rawValue) ?? []
    }
    
    class func setValue(_ key: UserDefaultEnum, value: Any?) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(value, forKey: key.rawValue)
        userDefaults.synchronize()
    }
    
    class func removeKey(_ key: UserDefaultEnum) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }
}
