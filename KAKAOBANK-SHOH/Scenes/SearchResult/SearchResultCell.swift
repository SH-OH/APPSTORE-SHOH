//
//  SearchResultCell.swift
//  KAKAOBANK-SHOH
//
//  Created by Oh Sangho on 2020/09/19.
//  Copyright © 2020 SH-OH. All rights reserved.
//

import UIKit.UICollectionViewCell
import ReactorKit

final class SearchResultCell: UICollectionViewCell, Reusable, StoryboardView {
    
    var disposeBag: DisposeBag = .init()
    
    @IBOutlet private weak var artworkImage: IBImageView!
    @IBOutlet private weak var trackNameLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    @IBOutlet private weak var starRatingImage01: UIImageView!
    @IBOutlet private weak var starRatingImage02: UIImageView!
    @IBOutlet private weak var starRatingImage03: UIImageView!
    @IBOutlet private weak var starRatingImage04: UIImageView!
    @IBOutlet private weak var starRatingImage05: UIImageView!
    @IBOutlet private weak var ratingCountLabel: UILabel!
    
    @IBOutlet private weak var screenShotImage01: IBImageView!
    @IBOutlet private weak var screenShotImage02: IBImageView!
    @IBOutlet private weak var screenShotImage03: IBImageView!
    
    @IBOutlet private weak var openButton: IBButton!
    
    func bind(reactor: SearchResultCellReactor) {
        reactor.state.map { $0.artworkUrl }
            .compactMap { $0 }
            .distinctUntilChanged()
            .bind(to: artworkImage.rx.setImage)
            .disposed(by: disposeBag)
            
        reactor.state.map { $0.trackName }
            .distinctUntilChanged()
            .bind(to: trackNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.description }
            .distinctUntilChanged()
            .bind(to: descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        let sharedRating = reactor.state.map { $0.rating }
            .distinctUntilChanged()
            .share(replay: 1)
            
        sharedRating
            .compactMap { $0[safe: 0] }
            .bind(to: starRatingImage01.rx.ratingImage)
            .disposed(by: disposeBag)
        sharedRating
            .compactMap { $0[safe: 1] }
            .bind(to: starRatingImage02.rx.ratingImage)
            .disposed(by: disposeBag)
        sharedRating
            .compactMap { $0[safe: 2] }
            .bind(to: starRatingImage03.rx.ratingImage)
            .disposed(by: disposeBag)
        sharedRating
            .compactMap { $0[safe: 3] }
            .bind(to: starRatingImage04.rx.ratingImage)
            .disposed(by: disposeBag)
        sharedRating
            .compactMap { $0[safe: 4] }
            .bind(to: starRatingImage05.rx.ratingImage)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.userRatingCount }
            .distinctUntilChanged()
            .bind(to: ratingCountLabel.rx.text)
            .disposed(by: disposeBag)
        
        let sharedUrls = reactor.state.map { $0.screenshotUrls }
            .compactMap { $0 }
            .distinctUntilChanged()
            .share(replay: 1)
        sharedUrls
            .compactMap { $0[safe: 0] }
            .bind(to: screenShotImage01.rx.setImage)
            .disposed(by: disposeBag)
        sharedUrls
            .compactMap { $0[safe: 1] }
            .bind(to: screenShotImage02.rx.setImage)
            .disposed(by: disposeBag)
        sharedUrls
            .compactMap { $0[safe: 2] }
            .bind(to: screenShotImage03.rx.setImage)
            .disposed(by: disposeBag)
    }
}
