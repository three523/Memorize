//
//  DeckTableViewCell.swift
//  Memorize
//
//  Created by 김도현 on 2024/03/25.
//

import UIKit
import SnapKit

final class DeckTableViewCell: UITableViewCell {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "타이틀"
        label.font = .systemFont(ofSize: AppResource.FontSize.contentTitle, weight: .regular)
        label.textColor = AppResource.Color.textBlackColor
        return label
    }()
    let explanationLabel: UILabel = {
        let label = UILabel()
        label.text = "카드 갯수: 8"
        label.font = .systemFont(ofSize: AppResource.FontSize.contentSubTitle, weight: .regular)
        label.textColor = AppResource.Color.textSubColor
        return label
    }()
    private let editButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "pencil"), for: .normal)
        button.tintColor = AppResource.Color.mainColor
        return button
    }()
    
    var editAction: (() -> Void)? = nil

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        contentView.addSubview(explanationLabel)
        contentView.addSubview(editButton)
        titleLabel.snp.makeConstraints { make in
            make.top.left.equalTo(contentView).inset(AppResource.Padding.medium)
        }
        explanationLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(AppResource.Padding.small)
            make.left.bottom.equalTo(contentView).inset(AppResource.Padding.medium)
        }
        editButton.snp.makeConstraints { make in
            make.top.right.equalTo(contentView).inset(AppResource.Padding.medium)
        }
        
        editButton.addTarget(self, action: #selector(clickEditButton), for: .touchUpInside)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func clickEditButton() {
        editAction?()
    }

}
