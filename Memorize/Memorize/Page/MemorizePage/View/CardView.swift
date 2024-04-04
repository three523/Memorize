//
//  CardView.swift
//  Memorize
//
//  Created by 김도현 on 2024/03/26.
//

import UIKit
import SnapKit

final class CardView: UIView {
    private let cardScrollView: UIScrollView = UIScrollView()
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
        label.numberOfLines = 0
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
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setScrollEnable(isEnable: Bool) {
        cardScrollView.isScrollEnabled = isEnable
    }
    
}

private extension CardView {
    func setup() {
        backgroundColor = .white
        addViews()
        autoLayoutSetup()
        setupScrollView()
    }
    
    func addViews() {
        addSubview(cardScrollView)
        cardScrollView.addSubview(wordStackView)
        wordStackView.addArrangedSubview(frontLabel)
        wordStackView.addArrangedSubview(backLabel)
    }
    
    func autoLayoutSetup() {
        cardScrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        wordStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(AppResource.Padding.medium)
            make.left.right.equalTo(cardScrollView.frameLayoutGuide).inset(AppResource.Padding.medium)
        }
    }
    
    func setupScrollView() {
        cardScrollView.showsVerticalScrollIndicator = false
    }
}
