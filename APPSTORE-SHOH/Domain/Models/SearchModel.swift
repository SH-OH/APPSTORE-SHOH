//
//  SearchModel.swift
//  APPSTORE-SHOH
//
//  Created by Oh Sangho on 2020/09/18.
//  Copyright © 2020 SH-OH. All rights reserved.
//

import Foundation

struct SearchModel: Decodable {
    let resultCount: Int?
    let results: [SearchResult]?
}

struct SearchResult: Decodable {
    let advisories: [String]?
    let supportedDevices: [String]?
    let isGameCenterEnabled: Bool?
    let screenshotUrls: [String]?
    let ipadScreenshotUrls: [String]?
    let appletvScreenshotUrls: [String]?
    let artworkUrl60: String?
    let artworkUrl100: String?
    let artworkUrl512: String?
    let artistViewUrl: String?
    let kind: String?
    let features: [String]?
    let sellerName: String?
    let primaryGenreId: Int?
    let trackId: Int?
    let trackName: String?
    let releaseNotes: String?
    let releaseDate: String?
    let formattedPrice: String?
    let genreIds: [String]?
    let isVppDeviceBasedLicensingEnabled: Bool?
    let primaryGenreName: String?
    let currentVersionReleaseDate: String?
    let minimumOsVersion: String?
    let currency: String?
    let fileSizeBytes: String?
    let sellerUrl: String?
    let averageUserRating: Double?
    let contentAdvisoryRating: String?
    let averageUserRatingForCurrentVersion: Double?
    let userRatingCountForCurrentVersion: Int?
    let trackViewUrl: String?
    let trackContentRating: String?
    let trackCensoredName: String?
    let languageCodesISO2A: [String]?
    let version: String?
    let wrapperType: String?
    let genres: [String]?
    let price: Double?
    let artistId: Int?
    let artistName: String?
    let description: String?
    let bundleId: String?
    let userRatingCount: Int?
}

extension SearchResult: Hashable {}
