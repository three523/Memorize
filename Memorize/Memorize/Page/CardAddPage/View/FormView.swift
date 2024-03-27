//
//  FormView.swift
//  Memorize
//
//  Created by 김도현 on 2024/03/26.
//

import UIKit

final class FormView: UIStackView {
    
    private let frontFormStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = AppResource.Padding.small
        return stackView
    }()
    private let frontLable: UILabel = {
        let label = UILabel()
        label.text = "앞에 나올 내용"
        label.font = .systemFont(ofSize: AppResource.FontSize.contentSubTitle, weight: .regular)
        label.textColor = AppResource.Color.textBlackColor
        return label
    }()
    private let frontTextView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: AppResource.FontSize.contentSubTitle, weight: .regular)
        textView.isScrollEnabled = false
        textView.layer.borderWidth = 0.5
        textView.layer.borderColor = AppResource.Color.borderColor.cgColor
        return textView
    }()
    
    private let backFormStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = AppResource.Padding.small
        return stackView
    }()
    private let backLable: UILabel = {
        let label = UILabel()
        label.text = "뒤에 나올 내용"
        label.font = .systemFont(ofSize: AppResource.FontSize.contentSubTitle, weight: .regular)
        label.textColor = AppResource.Color.textBlackColor
        return label
    }()
    private let backTextView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: AppResource.FontSize.contentSubTitle, weight: .regular)
        textView.isScrollEnabled = false
        textView.layer.borderWidth = 0.5
        textView.layer.borderColor = AppResource.Color.borderColor.cgColor
        return textView
    }()
    
    private let hintFormStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = AppResource.Padding.small
        return stackView
    }()
    private let hintLable: UILabel = {
        let label = UILabel()
        label.text = "힌트"
        label.font = .systemFont(ofSize: AppResource.FontSize.contentSubTitle, weight: .regular)
        label.textColor = AppResource.Color.textBlackColor
        return label
    }()
    private let hintTextView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: AppResource.FontSize.contentSubTitle, weight: .regular)
        textView.isScrollEnabled = false
        textView.layer.borderWidth = 0.5
        textView.layer.borderColor = AppResource.Color.borderColor.cgColor
        return textView
    }()
    
    var updateTextViewHeight: ((CGFloat) -> Void)? = nil
    private var previousContentHeight: CGFloat = 0
    private var contentAllHeight: CGFloat {
        return frontTextView.bounds.height + backTextView.bounds.height + hintTextView.bounds.height
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        axis = .vertical
        alignment = .fill
        distribution = .fillProportionally
        spacing = AppResource.Padding.medium
        
        addArrangedSubview(frontFormStackView)
        addArrangedSubview(backFormStackView)
        addArrangedSubview(hintFormStackView)
        
        frontFormStackView.addArrangedSubview(frontLable)
        frontFormStackView.addArrangedSubview(frontTextView)
        
        backFormStackView.addArrangedSubview(backLable)
        backFormStackView.addArrangedSubview(backTextView)
        
        hintFormStackView.addArrangedSubview(hintLable)
        hintFormStackView.addArrangedSubview(hintTextView)
        
        frontTextView.delegate = self
        backTextView.delegate = self
        hintTextView.delegate = self
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getCard() -> Card? {
        guard let frontText = frontTextView.text,
              let backText = backTextView.text else { return  nil }
        return Card(id: UUID(), frontText: frontText, backText: backText, hintText: hintTextView.text)
    }
    
    func updateText(card: Card) {
        frontTextView.text = card.frontText
        backTextView.text = card.backText
        hintTextView.text = card.hintText
    }
    
}

extension FormView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let height = textView.sizeThatFits(textView.bounds.size).height - textView.bounds.height
        if height != 0 {
            updateTextViewHeight?(height)
        }
    }
}
