//
//  SwpieAreaView.swift
//  Memorize
//
//  Created by 김도현 on 2024/03/26.
//

import UIKit

final class SwipeAreaView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: AppResource.FontSize.contentTitle, weight: .bold)
        label.textColor = AppResource.Color.textWhiteColor
        label.textAlignment = .center
        return label
    }()

    init(frame: CGRect = .zero, title: String) {
        titleLabel.text = title
        super.init(frame: frame)
        
        backgroundColor = .red.withAlphaComponent(0)
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.left.right.equalToSuperview().inset(AppResource.Padding.small)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
