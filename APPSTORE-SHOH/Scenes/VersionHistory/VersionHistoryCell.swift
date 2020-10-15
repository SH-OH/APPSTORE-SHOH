//
//  VersionHistoryCell.swift
//  APPSTORE-SHOH
//
//  Created by Oh Sangho on 2020/09/21.
//  Copyright © 2020 SH-OH. All rights reserved.
//

import UIKit.UICollectionViewCell

final class VersionHistoryCell: UICollectionViewCell, Reusable {
    
    @IBOutlet private weak var versionLabel: UILabel!
    @IBOutlet private weak var agoLabel: UILabel!
    @IBOutlet private weak var notesTextView: UITextView!
    @IBOutlet private weak var moreButton: UIButton!
    
    func configure(_ item: VersionHistorySectionItem) {
        versionLabel.text = item.version
        agoLabel.text = item.ago
        notesTextView.text = item.notes
        
        _ = moreButton.rx.tap
            .subscribe(onNext: { [updateCellSize] (_) in
                updateCellSize()
            })
    }
    
    private func updateCellSize() {
        let height: CGFloat = notesTextView.intrinsicContentSize.height
        let increase: CGFloat = height - notesTextView.bounds.height
        let resultHeight = self.bounds.height + increase
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3) {
                self.moreButton.alpha = 0
                self.frame.size = .init(width: self.bounds.width, height: resultHeight)
                self.notesTextView.layoutIfNeeded()
            }
        }
    }
    
}
