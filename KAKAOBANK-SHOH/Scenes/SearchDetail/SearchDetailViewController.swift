//
//  SearchDetailViewController.swift
//  KAKAOBANK-SHOH
//
//  Created by Oh Sangho on 2020/09/20.
//  Copyright © 2020 SH-OH. All rights reserved.
//

import UIKit
import ReactorKit

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
    
    // 07.정보 min height 350. max 420 (호환성: +30, 연령등급 +40)
    @IBOutlet private weak var artistNameLabel: UILabel!
    @IBOutlet private weak var fileSizeLabel: UILabel!
    @IBOutlet private weak var categoryLabel: UILabel!
    @IBOutlet private weak var supportedDownButton: UIButton!
    @IBOutlet private weak var supportedLabel: UILabel! {
        didSet { supportedLabel.isHidden = true }
    }
    @IBOutlet private weak var languageLabel: UIStackView!
    @IBOutlet private weak var contentsRatingDownButton: UIButton!
    @IBOutlet private weak var contentsRatingLabel: UILabel! {
        didSet { contentsRatingLabel.isHidden = true }
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
        
    }
}
