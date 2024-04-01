//
//  CardAddTableViewCell.swift
//  Memorize
//
//  Created by 김도현 on 2024/03/27.
//

import UIKit
import SnapKit

final class CardAddButtonTableViewCell: UITableViewCell {
    
    private let addButton: UIButton = {
        let button = UIButton()
        button.setTitle("카드 추가하기", for: .normal)
        button.setTitleColor(AppResource.Color.textWhiteColor, for: .normal)
        button.backgroundColor = AppResource.Color.buttonMainColor
        return button
    }()
    
    var addAction: (() -> Void)? = nil

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.center.equalTo(contentView)
            make.height.equalTo(AppResource.ButtonSize.large).priority(999)
            make.top.bottom.equalTo(contentView).inset(AppResource.Padding.medium)
            make.left.right.equalTo(contentView).inset(AppResource.Padding.xLarge)
        }
        
        addButton.addTarget(self, action: #selector(addCard), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func addCard() {
        addAction?()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
