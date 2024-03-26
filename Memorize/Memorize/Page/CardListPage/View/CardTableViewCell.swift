//
//  CardTableViewCell.swift
//  Memorize
//
//  Created by 김도현 on 2024/03/25.
//

import UIKit

final class CardTableViewCell: UITableViewCell {
    
    private let frontTextLabel: UILabel = {
        let label = UILabel()
        label.text = "앞에 보일 내용입니다."
        label.font = .systemFont(ofSize: AppResource.FontSize.contentSubTitle, weight: .regular)
        label.textColor = AppResource.Color.textBlackColor
        label.numberOfLines = 1
        return label
    }()
    private let backTextLabel: UILabel = {
        let label = UILabel()
        label.text = "뒤에 보일 내용입니다."
        label.font = .systemFont(ofSize: AppResource.FontSize.contentSubTitle, weight: .regular)
        label.textColor = AppResource.Color.textSubColor
        label.numberOfLines = 1
        return label
    }()
    private let hintTextLabel: UILabel = {
        let label = UILabel()
        label.text = "힌트: 힌트입니다."
        label.textColor = AppResource.Color.textSubColor
        label.numberOfLines = 1
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(frontTextLabel)
        contentView.addSubview(backTextLabel)
        contentView.addSubview(hintTextLabel)
        
        frontTextLabel.snp.makeConstraints { make in
            make.top.left.right.equalTo(contentView).inset(AppResource.Padding.medium)
        }
        backTextLabel.snp.makeConstraints { make in
            make.top.equalTo(frontTextLabel.snp.bottom).offset(AppResource.Padding.small)
            make.left.right.equalTo(contentView).inset(AppResource.Padding.medium)
        }
        hintTextLabel.snp.makeConstraints { make in
            make.top.equalTo(backTextLabel.snp.bottom).offset(AppResource.Padding.small)
            make.left.right.equalTo(contentView).inset(AppResource.Padding.medium)
            make.bottom.equalTo(contentView).inset(AppResource.Padding.medium)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct CardTableViewCell_Preview: PreviewProvider {
    static var previews: some View {
        return CardTableViewCell(frame: .zero).showPreview()
    }
}
#endif
