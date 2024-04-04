//
//  CardControlStackView.swift
//  Memorize
//
//  Created by 김도현 on 2024/04/04.
//

import UIKit

final class CardControlStackView: UIStackView {
    
    private let failButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = AppResource.Color.buttonWarringColor
        return button
    }()
    private let hintButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "lightbulb"), for: .normal)
        button.tintColor = AppResource.Color.hintColor
        return button
    }()
    private let successButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "circle"), for: .normal)
        button.tintColor = AppResource.Color.buttonMainColor
        return button
    }()
    
    var failAction: (() -> Void)? = nil
    var hintAction: (() -> Void)? = nil
    var successAction: (() -> Void)? = nil

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension CardControlStackView {
    func setup() {
        setupStackView()
        addView()
        buttonAction()
    }
    
    func setupStackView() {
        axis = .horizontal
        alignment = .leading
        distribution = .fillEqually
        spacing = 0
    }
    
    func addView() {
        addArrangedSubview(failButton)
        addArrangedSubview(hintButton)
        addArrangedSubview(successButton)
    }
    
    func buttonAction() {
        failButton.addTarget(self, action: #selector(clickFailButton), for: .touchUpInside)
        hintButton.addTarget(self, action: #selector(clickHintButton), for: .touchUpInside)
        successButton.addTarget(self, action: #selector(clickSuccessButton), for: .touchUpInside)
    }
    
    @objc func clickFailButton() {
        failAction?()
    }
    
    @objc func clickHintButton() {
        hintAction?()
    }
    
    @objc func clickSuccessButton() {
        successAction?()
    }
}
