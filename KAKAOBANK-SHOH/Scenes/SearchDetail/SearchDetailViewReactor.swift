//
//  SearchDetailViewReactor.swift
//  KAKAOBANK-SHOH
//
//  Created by Oh Sangho on 2020/09/20.
//  Copyright © 2020 SH-OH. All rights reserved.
//

import ReactorKit
import Foundation
import UIKit.UIDevice
import DeviceKit

final class SearchDetailViewReactor: Reactor {
    
    enum Action {
        
    }
    
    enum Mutation {
        
    }
    
    struct State {
        // UI
        var artworkUrl100: URL?
        var trackCensoredName: String
        var ratingArray: [Double]
        var userRatingCount: Int
        var artistName: String
        var fileSizeBytes: String
        var genreName: String
        var contentAdvisoryRating: String
        var version: String
        var updateAgo: String
        var releaseNotes: String
        var screenShotSections: [SearchDetailSection]
        var description: String
        var sellerName: String
        var isSupported: String
        var supported: String
        var languageList: [String]
        var languages: String
        var reviewsSections: [SearchDetailSection]
        
        // Event
        var trackViewUrl: URL?
        var sellerUrl: URL?
        var artistViewUrl: URL?
    }
    
    let initialState: State
    let searchViewReactor: SearchViewReactor
    init(result: SearchResult,
         searchViewReactor: SearchViewReactor) {
        self.searchViewReactor = searchViewReactor
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2
        
        let averageUserRatingForCurrentVersion = numberFormatter
            .string(from: (result.averageUserRatingForCurrentVersion ?? 0) as NSNumber) ?? "0"
        let ratingToDouble = Double(averageUserRatingForCurrentVersion) ?? 0
        
        var ratingArray: [Double] = []
        for index in 0..<5 {
            var rating: Double = ratingToDouble-Double(index)
            rating = rating <= 0 ? 0 : rating
            rating = rating >= 1 ? 1 : rating
            ratingArray.append(rating)
        }
        
        let sizeToInt: Int64 = Int64(result.fileSizeBytes ?? "") ?? 0
        let byteFormatter = ByteCountFormatter()
        byteFormatter.allowedUnits = .useAll
        byteFormatter.includesUnit = true
        let fileSize: String = byteFormatter.string(fromByteCount: sizeToInt)
            .replacingOccurrences(of: " ", with: "")

        let version: String = "버전 \(result.version ?? "")"
        
        let dateToString = result.currentVersionReleaseDate ?? "2020-09-13T01:15:04Z"
        let isoFormat = ISO8601DateFormatter()
        let today: Date = Date()
        let updateDate: Date = isoFormat.date(from: dateToString) ?? today
        
        let screenshotUrls: [URL]? = result.screenshotUrls?
            .compactMap { URL(string: $0) }
        let makeSectionItems = screenshotUrls?
            .map { SearchDetailSectionItem.screenShot($0) } ?? []
        let screenShotSections = [SearchDetailSection.screenShots(makeSectionItems)]
        
        let myOsVersion = UIDevice.current.systemVersion
        let minimumOsVersion = result.minimumOsVersion ?? "0"
        let compareVersion = myOsVersion.compare(minimumOsVersion, options: .numeric)
        let compare: Bool = compareVersion == .orderedDescending
            || compareVersion == .orderedSame
        
        let supportedDevices = result.supportedDevices ?? []
        
        var supported: String = "iOS \(minimumOsVersion) 버전 이상이 필요."
        var availableIphone: Bool = false
        var availableIPad: Bool = false
        var availableIPod: Bool = false
        for device in supportedDevices {
            if device.contains("iPhone"), !availableIphone {
                availableIphone = true
                supported.append(" iPhone")
            }
            if device.contains("iPad"), !availableIPad {
                availableIPad = true
                supported.append(", iPad")
            }
            if device.contains("iPod"), !availableIPod {
                availableIPod = true
                supported.append(" 및 iPod touch")
            }
        }
        supported.append("와(과) 호환.")
        
        var _isSupported: Bool = false
        let device = Device.current
        if device.isPhone {
            _isSupported = compare && availableIphone
        } else if device.isPad {
            _isSupported = compare && availableIPad
        } else {
            _isSupported = compare && availableIPod
        }
        let model = UIDevice.current.model
        let isSupported: String = _isSupported
            ? "이 \(model)와(과) 호환"
            : "이 앱은 \(model)의 App Store에서만 사용할 수 있습니다."
        
        let languageISO: [String] = result.languageCodesISO2A ?? []
        let languageList = languageISO.compactMap({ (iso) -> String? in
            let locale = Locale(identifier: iso)
            return (locale as NSLocale).displayName(forKey: .identifier, value: locale.identifier)
        })
        var languages: String = ""
        switch languageList.count {
        case 2:
            languages = languageList.joined(separator:  " 및 ")
        case 3...:
            languages = languageList.joined(separator:  ", ")
        default:
            languages = languageList.first ?? ""
        }
        
        self.initialState = State(
            artworkUrl100: URL(string: result.artworkUrl100 ?? ""),
            trackCensoredName: result.trackCensoredName ?? "",
            ratingArray: ratingArray,
            userRatingCount: result.userRatingCountForCurrentVersion ?? 0,
            artistName: result.artistName ?? "",
            fileSizeBytes: fileSize,
            genreName: result.genres?.first ?? "",
            contentAdvisoryRating: result.contentAdvisoryRating ?? "",
            version: version,
            updateAgo: updateDate.ago ?? "",
            releaseNotes: result.releaseNotes ?? "",
            screenShotSections: screenShotSections,
            description: result.description ?? "",
            sellerName: result.sellerName ?? "",
            isSupported: isSupported,
            supported: supported,
            languageList: languageList,
            languages: languages,
            reviewsSections: [SearchDetailSection.reviews([
                .review,
                .review
            ])],
            trackViewUrl: URL(string: result.trackViewUrl ?? ""),
            sellerUrl: URL(string: result.sellerUrl ?? ""),
            artistViewUrl: URL(string: result.artistViewUrl ?? "")
        )
    }
    
}
