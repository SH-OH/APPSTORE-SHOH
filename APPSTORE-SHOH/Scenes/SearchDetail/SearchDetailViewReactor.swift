//
//  SearchDetailViewReactor.swift
//  APPSTORE-SHOH
//
//  Created by Oh Sangho on 2020/09/20.
//  Copyright © 2020 SH-OH. All rights reserved.
//

import ReactorKit
import Foundation
import UIKit.UIDevice
import DeviceKit
import StoreKit

final class SearchDetailViewReactor: Reactor {
    
    enum Action {
        case openWeb(URL)
        case writeReview(URL)
    }
    
    enum Mutation {
        
    }
    
    struct State {
        // UI
        var artworkUrl100: URL?
        var trackCensoredName: String
        var ratingToDouble: Double
        var ratingArray: [Double]
        var userRatingCount: Int
        var artistName: String
        var fileSizeBytes: String
        var genreName: String
        var contentAdvisoryRating: String
        var version: String
        var updateDate: Date
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
        var writeReviewUrl: URL?
    }
    
    let initialState: State
    let searchViewReactor: SearchViewReactor
    init(result: SearchResult,
         searchViewReactor: SearchViewReactor) {
        self.searchViewReactor = searchViewReactor
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = 1
        numberFormatter.maximumFractionDigits = 1
        
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
        
        var artistViewUrlString = result.artistViewUrl ?? ""
        var artistViewUrl = URL(string: artistViewUrlString)
        if let query = artistViewUrl?.query {
            artistViewUrlString = artistViewUrlString.replacingOccurrences(of: "?\(query)", with: "")
        }
        artistViewUrl = URL(string: artistViewUrlString)
        
        self.initialState = State(
            artworkUrl100: URL(string: result.artworkUrl100 ?? ""),
            trackCensoredName: result.trackCensoredName ?? "",
            ratingToDouble: ratingToDouble,
            ratingArray: ratingArray,
            userRatingCount: result.userRatingCountForCurrentVersion ?? 0,
            artistName: result.artistName ?? "",
            fileSizeBytes: fileSize,
            genreName: result.genres?.first ?? "",
            contentAdvisoryRating: result.contentAdvisoryRating ?? "",
            version: version,
            updateDate: updateDate,
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
            artistViewUrl: artistViewUrl,
            writeReviewUrl: URL(string: "itms-apps://itunes.apple.com/app/itunes-u/id\(result.trackId ?? 0)?ls=1&mt=8&action=write-review")
        )
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .openWeb(let url):
            _ = Observable.just(url)
                .filter { UIApplication.shared.canOpenURL($0) }
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { (url) in
                    UIApplication.shared.open(url,
                                              options: [:],
                                              completionHandler: nil)
                })
            return .empty()
        case .writeReview(let url):
            _ = Observable.just(url)
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { (url) in
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url,
                                                  options: [:],
                                                  completionHandler: nil)
                    } else {
                        SKStoreReviewController.requestReview()
                    }
                })
            return .empty()
        }
    }
    
}
