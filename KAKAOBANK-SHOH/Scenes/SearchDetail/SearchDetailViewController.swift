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
    
    private var curIndex: CGFloat = 0
    
    // MARK: - Constraint
    @IBOutlet private weak var newFeatureViewHeight: NSLayoutConstraint!
    @IBOutlet private weak var descriptionViewHeight: NSLayoutConstraint!
    /// 최소 height 440, 최대 510 (호환성: +30, 연령등급 +40)
    @IBOutlet private weak var informationViewHeight: NSLayoutConstraint!
    @IBOutlet private weak var supportedViewHeight: NSLayoutConstraint!
    @IBOutlet private weak var contentsRatingViewHeight: NSLayoutConstraint!
    
    
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
    @IBOutlet private weak var releaseNotesTextView: UITextView!
    @IBOutlet private weak var notesMoreButton: UIButton!
    
    // 03.미리보기
    @IBOutlet private weak var screenShotsCV: UICollectionView!
    
    // 04.설명
    @IBOutlet private weak var descriptionTextView: UITextView!
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
    
    // 07.정보
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
        openButton.rx.tap
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (_) in
                print("osh - 탭 열기")
            }).disposed(by: disposeBag)
        moreButton.rx.tap
            .withLatestFrom(reactor.state.map { $0.trackViewUrl })
            .compactMap { $0 }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (url) in
                let vc = UIActivityViewController(activityItems: [url], applicationActivities: nil)
                reactor.searchViewReactor.navigationController.present(vc, animated: true, completion: nil)
            }).disposed(by: disposeBag)
        versionHistoryButton.rx.tap
            .withLatestFrom(reactor.state)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (state) in
                let makeItems: [VersionHistorySectionItem] = [
                    VersionHistorySectionItem(
                        version: state.version,
                        ago: state.updateAgo,
                        notes: state.releaseNotes
                    )
                ]
                let vc = StoryboardType.VersionHistory.viewController(VersionHistoryViewController.self)
                vc.reactor = VersionHistoryViewReactor(items: makeItems)
                reactor.searchViewReactor.navigationController.pushViewController(vc, animated: true)
            }).disposed(by: disposeBag)
        notesMoreButton.rx.tap
            .compactMap { [weak releaseNotesTextView] in releaseNotesTextView }
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [
                weak notesMoreButton,
                weak newFeatureViewHeight,
                updateTextHeight
                ] (textView) in
                updateTextHeight(textView,
                                 notesMoreButton,
                                 &newFeatureViewHeight)
            }).disposed(by: disposeBag)
        descriptionMoreButton.rx.tap
            .compactMap { [weak descriptionTextView] in descriptionTextView }
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [
                weak descriptionMoreButton,
                weak descriptionViewHeight,
                updateTextHeight
                ] (textView) in
                updateTextHeight(textView,
                                 descriptionMoreButton,
                                 &descriptionViewHeight)
            }).disposed(by: disposeBag)
        sellerAppsButton.rx.tap
            .withLatestFrom(reactor.state.map { $0.artistViewUrl })
            .compactMap { $0 }
            .map { Reactor.Action.openWeb($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        reviewAllButton.rx.tap
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (_) in
                print("osh - 평가 및 리뷰 모두 보기")
            }).disposed(by: disposeBag)
        writeReviewButton.rx.tap
            .withLatestFrom(reactor.state.map { $0.writeReviewUrl })
            .compactMap { $0 }
            .map { Reactor.Action.writeReview($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        supportedDownButton.rx.tap
            .compactMap { [weak supportedLabel] in supportedLabel }
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [
                weak supportedDownButton,
                weak supportedViewHeight,
                weak informationViewHeight,
                updateInfoMoreByDown
                ] (supportedLabel) in
                updateInfoMoreByDown(supportedLabel,
                                     supportedDownButton,
                                     &supportedViewHeight,
                                     &informationViewHeight)
            }).disposed(by: disposeBag)
        contentsRatingDownButton.rx.tap
            .compactMap { [weak contentsRatingLabel02] in contentsRatingLabel02 }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [
                weak contentsRatingDownButton,
                weak contentsRatingViewHeight,
                weak informationViewHeight,
                updateInfoMoreByDown
                ] (labal) in
                updateInfoMoreByDown(labal,
                                     contentsRatingDownButton,
                                     &contentsRatingViewHeight,
                                     &informationViewHeight)
            }).disposed(by: disposeBag)
        contentsRatingMoreButton.rx.tap
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (_) in
                print("osh - 정보 호환성 더보기")
            }).disposed(by: disposeBag)
        Observable.merge(
            supportAppButton.rx.tap.asObservable(),
            developerWebButton.rx.tap.asObservable()
        )
            .withLatestFrom(reactor.state.map { $0.sellerUrl })
            .compactMap { $0 }
            .map { Reactor.Action.openWeb($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        privacyPolicyButton.rx.tap
            .map { "https://m.kakaobank.com/PrivacyPolicy;ctg=privacyManagementPolicy" }
            .compactMap { URL(string: $0) }
            .map { Reactor.Action.openWeb($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
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
        let sharedRatingToDouble = reactor.state.map { $0.ratingToDouble }
            .map { "\($0)" }
            .share(replay: 1)
        sharedRatingToDouble
            .bind(to: ratingLabel01.rx.text)
            .disposed(by: disposeBag)
        sharedRatingToDouble
            .bind(to: ratingLabel02.rx.text)
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
            .bind(to: releaseNotesTextView.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.artistName }
            .bind(to: artistNameLabel.rx.text)
            .disposed(by: disposeBag)
        reactor.state.map { $0.description }
            .bind(to: descriptionTextView.rx.text)
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
    
    private func updateTextHeight(_ textView: UITextView?,
                                  _ actionButton: UIButton?,
                                  _ heightConstraint: inout NSLayoutConstraint?) {
        let height: CGFloat = textView?.intrinsicContentSize.height ?? 0.0
        let increase: CGFloat = height - (textView?.bounds.height ?? 0.0)
        UIView.animate(withDuration: 0.3) { [weak heightConstraint] in
            heightConstraint?.constant += increase
            actionButton?.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
    private func updateInfoMoreByDown(_ label: UILabel?,
                                      _ downButton: UIButton?,
                                      _ parentViewHeightConstraint: inout NSLayoutConstraint?,
                                      _ superViewHeightConstraint: inout NSLayoutConstraint?) {
        var height: CGFloat = label?.intrinsicContentSize.height ?? 0.0
        if downButton == contentsRatingDownButton {
            height = 40
            self.contentsRatingMoreButton.isHidden = false
        }
        label?.isHidden = false
        UIView.animate(withDuration: 0.3) {
            [weak parentViewHeightConstraint, weak superViewHeightConstraint] in
            downButton?.alpha = 0
            label?.alpha = 1
            self.contentsRatingMoreButton.alpha = 1
            parentViewHeightConstraint?.constant += height
            superViewHeightConstraint?.constant += height
            self.view.layoutIfNeeded()
        }
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
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
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
