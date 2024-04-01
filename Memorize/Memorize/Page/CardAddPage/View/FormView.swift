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
    private let frontWarringLabel: UILabel = {
        let label = UILabel()
        label.text = "필수로 입력해야합니다."
        label.font = .systemFont(ofSize: AppResource.FontSize.contentSubTitle, weight: .regular)
        label.textColor = AppResource.Color.warringColor
        label.isHidden = true
        return label
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
    private let backWarringLabel: UILabel = {
        let label = UILabel()
        label.text = "필수로 입력해야합니다."
        label.font = .systemFont(ofSize: AppResource.FontSize.contentSubTitle, weight: .regular)
        label.textColor = AppResource.Color.warringColor
        label.isHidden = true
        return label
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
    
    var updateTextViewHeight: ((CGRect) -> Void)? = nil
    var formTextViewBeginEditing: ((CGPoint) -> Void)? = nil
    
    private var isTextViewHeightUpdate = false
    private var previousContentHeight: CGFloat = 0
    private var contentAllHeight: CGFloat {
        return frontTextView.bounds.height + backTextView.bounds.height + hintTextView.bounds.height
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        axis = .vertical
        alignment = .fill
        distribution = .fill
        spacing = AppResource.Padding.medium
        layoutMargins = .init(top: 0, left: 0, bottom: AppResource.Padding.small, right: 0)
        isLayoutMarginsRelativeArrangement = true
        
        addArrangedSubview(frontFormStackView)
        addArrangedSubview(backFormStackView)
        addArrangedSubview(hintFormStackView)
        
        frontFormStackView.addArrangedSubview(frontLable)
        frontFormStackView.addArrangedSubview(frontTextView)
        frontFormStackView.addArrangedSubview(frontWarringLabel)
        
        backFormStackView.addArrangedSubview(backLable)
        backFormStackView.addArrangedSubview(backTextView)
        backFormStackView.addArrangedSubview(backWarringLabel)
        
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
              frontText.isEmpty == false else {
            frontWarringLabel.isHidden = false
            return nil
        }
        guard let backText = backTextView.text,
              backText.isEmpty == false else {
            backWarringLabel.isHidden = false
            return  nil
        }
        return Card(id: UUID(), frontText: frontText, backText: backText, hintText: hintTextView.text)
    }
    
    private func allWarringLabelHidden() {
        frontWarringLabel.isHidden = true
        backWarringLabel.isHidden = true
    }
    
    func updateText(card: Card) {
        frontTextView.text = card.frontText
        backTextView.text = card.backText
        hintTextView.text = card.hintText
    }
    
}

extension FormView: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        if isTextViewHeightUpdate {
            updateTextViewHeight?(textView.frame)
            isTextViewHeightUpdate = false
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "" || text == "\n" {
            isTextViewHeightUpdate = true
        }
        return true
    }
    
    private func getCursorPosition(for textView: UITextView) -> CGPoint? {
        guard let selectedTextRange = textView.selectedTextRange else {
            return nil
        }
        
        let selectedRect = textView.caretRect(for: selectedTextRange.start)
        let cursorPoint = CGPoint(x: selectedRect.minX, y: selectedRect.minY)
        print("position: \(cursorPoint)")
        return cursorPoint
    }
    
    private func getCursorRect(for textView: UITextView) -> CGRect? {
        guard let selectedTextRange = textView.selectedTextRange else {
            return nil
        }
        
        let selectedRect = textView.caretRect(for: selectedTextRange.start)
        return selectedRect
    }
}
