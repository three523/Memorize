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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        axis = .vertical
        alignment = .fill
        distribution = .fill
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
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//#if canImport(SwiftUI) && DEBUG
//import SwiftUI
//
//struct FormViewPreview: PreviewProvider {
//    static var previews: some View {
//        return FormView(frame: .zero).showPreview()
//    }
//}
//#endif

