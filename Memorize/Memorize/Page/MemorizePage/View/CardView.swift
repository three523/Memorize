//
//  CardView.swift
//  Memorize
//
//  Created by 김도현 on 2024/03/26.
//

import UIKit
import SnapKit

final class CardView: UIView {
    
    let topLineStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        return stackView
    }()
    let wordCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .lightGray
        return label
    }()
    private let cardStateStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 12
        return stackView
    }()
    private let wordStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 12
        return stackView
    }()
    let frontLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: AppResource.FontSize.contentSubTitle, weight: .regular)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    let backLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: AppResource.FontSize.contentSubTitle, weight: .regular)
        label.textAlignment = .center
        label.textColor = .black
        label.isHidden = true
        return label
    }()
    
    private let inset: CGFloat = 24

    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension CardView {
    func setup() {
        backgroundColor = .white
        addViews()
        autoLayoutSetup()
    }
    
    func addViews() {
        addSubview(topLineStackView)
        topLineStackView.addArrangedSubview(wordCountLabel)
        topLineStackView.addArrangedSubview(cardStateStackView)
        addSubview(wordStackView)
        wordStackView.addArrangedSubview(frontLabel)
        wordStackView.addArrangedSubview(backLabel)
    }
    
    func autoLayoutSetup() {
        topLineStackView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(inset)
        }

        wordStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
