//
//  SearchDetailViewController.swift
//  KAKAOBANK-SHOH
//
//  Created by Oh Sangho on 2020/09/20.
//  Copyright © 2020 SH-OH. All rights reserved.
//

import UIKit
import ReactorKit
import RxDataSources

final class SearchDetailViewController: BaseViewController, StoryboardView {
    
    // 01.이름
    @IBOutlet private weak var trackImage: UIImageView!
    @IBOutlet private weak var trackNameLabel: UILabel!
    @IBOutlet private weak var subNameLabel: UILabel!
    @IBOutlet private weak var openButton: IBButton!
    @IBOutlet private weak var moreButton: UIButton!
    @IBOutlet private weak var ratingLabel01: UILabel!
    @IBOutlet private weak var ratingCountLabel01: UILabel!
    
    /// 평점 별(채우기 용)
    @IBOutlet private weak var ratingStarImage01: UIImageView!
    @IBOutlet private weak var ratingStarImage02: UIImageView!
    @IBOutlet private weak var ratingStarImage03: UIImageView!
    @IBOutlet private weak var ratingStarImage04: UIImageView!
    @IBOutlet private weak var ratingStarImage05: UIImageView!
    
    @IBOutlet private weak var rankLabel: UILabel!
    @IBOutlet private weak var contentsRatingLabel01: UILabel!
    
    // 02.새로운 기능
    @IBOutlet private weak var curVersionLabel: UILabel!
    @IBOutlet private weak var versionHistoryButton: UIButton!
    @IBOutlet private weak var releaseAgoLabel: UILabel!
    @IBOutlet private weak var releaseNotesLabel: UITextView!
    @IBOutlet private weak var notesMoreButton: UIButton!
    
    // 03.미리보기
    @IBOutlet private weak var screenShotsCV: UICollectionView!
    
    // 04.설명
    @IBOutlet private weak var descriptionLabel: UITextView!
    @IBOutlet private weak var descriptionMoreButton: UIButton!
    @IBOutlet private weak var sellerNameLabel: UILabel!
    @IBOutlet private weak var sellerAppsButton: UIButton!
    
    // 05. 평가 및 리뷰
    @IBOutlet private weak var reviewAllButton: UIButton!
    @IBOutlet private weak var ratingLabel02: UILabel!
    @IBOutlet private weak var ratingCountLabel02: UILabel!
    
    // 06. 평가하기
    @IBOutlet private weak var reviewCV: UICollectionView!
    @IBOutlet private weak var writeReviewButton: UIButton!
    @IBOutlet private weak var supportAppButton: UIButton!
    
    // 07.정보 min height 440. max 510 (호환성: +30, 연령등급 +40)
    @IBOutlet private weak var artistNameLabel: UILabel!
    @IBOutlet private weak var fileSizeLabel: UILabel!
    @IBOutlet private weak var categoryLabel: UILabel!
    @IBOutlet private weak var supportedDownButton: UIButton!
    @IBOutlet private weak var supportedLabel: UILabel! {
        didSet { supportedLabel.isHidden = true }
    }
    @IBOutlet private weak var languageLabel: UILabel!
    @IBOutlet private weak var contentsRatingDownButton: UIButton!
    @IBOutlet private weak var contentsRatingLabel02: UILabel! {
        didSet { contentsRatingLabel02.isHidden = true }
    }
    @IBOutlet private weak var contentsRatingMoreButton: UIButton! {
        didSet { contentsRatingMoreButton.isHidden = true }
    }
    @IBOutlet private weak var copyrightLabel: UILabel!
    @IBOutlet private weak var developerWebButton: UIButton!
    @IBOutlet private weak var privacyPolicyButton: UIButton!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    func bind(reactor: SearchDetailViewReactor) {
        
        reactor.state.map { $0.artworkUrl100 }
            .compactMap { $0 }
            .bind(to: trackImage.rx.setImage)
            .disposed(by: disposeBag)
        reactor.state.map { $0.trackCensoredName }
            .bind(to: trackNameLabel.rx.text)
            .disposed(by: disposeBag)
        reactor.state.map { $0.artistName }
            .bind(to: subNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        let sharedRating = reactor.state.map { $0.ratingArray }
            .share(replay: 1)
        sharedRating
            .compactMap { $0[safe: 0] }
            .bind(to: ratingStarImage01.rx.ratingImage)
            .disposed(by: disposeBag)
        sharedRating
            .compactMap { $0[safe: 1] }
            .bind(to: ratingStarImage02.rx.ratingImage)
            .disposed(by: disposeBag)
        sharedRating
            .compactMap { $0[safe: 2] }
            .bind(to: ratingStarImage03.rx.ratingImage)
            .disposed(by: disposeBag)
        sharedRating
            .compactMap { $0[safe: 3] }
            .bind(to: ratingStarImage04.rx.ratingImage)
            .disposed(by: disposeBag)
        sharedRating
            .compactMap { $0[safe: 4] }
            .bind(to: ratingStarImage05.rx.ratingImage)
            .disposed(by: disposeBag)
        
        let sharedUserRatingCount = reactor.state.map { $0.userRatingCount }
            .share(replay: 1)
        sharedUserRatingCount
            .map { $0.userCountToSpell }
            .map { "\($0)개의 평가" }
            .bind(to: ratingCountLabel01.rx.text)
            .disposed(by: disposeBag)
        sharedUserRatingCount
            .map { "\($0.toDecimal)개의 평가" }
            .bind(to: ratingCountLabel02.rx.text)
            .disposed(by: disposeBag)
        
        let sharedContentsRating = reactor.state.map { $0.contentAdvisoryRating }
            .share(replay: 1)
        sharedContentsRating
            .bind(to: contentsRatingLabel01.rx.text)
            .disposed(by: disposeBag)
        sharedContentsRating
            .bind(to: contentsRatingLabel02.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.version }
            .bind(to: curVersionLabel.rx.text)
            .disposed(by: disposeBag)
        reactor.state.map { $0.updateAgo }
            .bind(to: releaseAgoLabel.rx.text)
            .disposed(by: disposeBag)
        reactor.state.map { $0.releaseNotes }
            .bind(to: releaseNotesLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.description }
            .bind(to: descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        reactor.state.map { $0.sellerName }
            .bind(to: sellerNameLabel.rx.text)
            .disposed(by: disposeBag)
        reactor.state.map { $0.fileSizeBytes }
            .bind(to: fileSizeLabel.rx.text)
            .disposed(by: disposeBag)
        reactor.state.map { $0.genreName }
            .bind(to: categoryLabel.rx.text)
            .disposed(by: disposeBag)
        reactor.state.map { $0.isSupported }
            .bind(to: supportedDownButton.rx.title(for: .normal))
            .disposed(by: disposeBag)
        reactor.state.map { $0.supported }
            .bind(to: supportedLabel.rx.text)
            .disposed(by: disposeBag)
        reactor.state.map { $0.languages }
            .bind(to: languageLabel.rx.text)
            .disposed(by: disposeBag)
        
        bindCV(reactor)
    }
    
    private func bindCV(_ reactor: SearchDetailViewReactor) {
        screenShotsCV.rx.setDelegate(self)
            .disposed(by: disposeBag)
        reviewCV.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.screenShotSections }
            .bind(to: screenShotsCV.rx.items(dataSource: dataSource()))
            .disposed(by: disposeBag)
        reactor.state.map { $0.reviewsSections }
            .bind(to: reviewCV.rx.items(dataSource: dataSource()))
            .disposed(by: disposeBag)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SearchDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case screenShotsCV:
            return CGSize(width: 196, height: 348)
        case reviewCV:
            let width: CGFloat = collectionView.bounds.width - 30
            return CGSize(width: width, height: 145)
        default:
            return .zero
        }
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 15, bottom: 0, right: 15)
    }
}

// MARK: - DataSources
extension SearchDetailViewController {
    private func dataSource() -> RxCollectionViewSectionedReloadDataSource<SearchDetailSection> {
        return .init(configureCell: { (ds, cv, ip, item) -> UICollectionViewCell in
            switch item {
            case .screenShot(let url):
                let cell = cv.dequeue(SearchDetailCell.self, for: ip)
                cell.configure(url)
                return cell
            case .review:
                let cell = cv.dequeueReusableCell(withReuseIdentifier: "SearchReviewCell", for: ip)
                return cell
            }
        })
    }
}
