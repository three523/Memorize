//
//  PopUpTopView.swift
//  Memorize
//
//  Created by 김도현 on 2024/03/25.
//
import UIKit
import SnapKit

final class PopupTopView: UIView {

    let titleLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.font = .systemFont(ofSize: AppResource.FontSize.contentTitle, weight: .regular)
        return view
    }()
    
    private let titledivider: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        return view
    }()
    
    private let rightButton: UIButton = {
        let button = UIButton()
        button.tintColor = AppResource.Color.blackColor
        return button
    }()
    
    var deleteAction: (() -> Void)? = nil
    var dismissAction: (() -> Void)? = nil
    
    var isUpdate: Bool = false
        
    init(title: String, isUpdate: Bool) {
        super.init(frame: CGRect.zero)
        titleLabel.text = title
        self.isUpdate = isUpdate
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension PopupTopView {
    
    func setup() {
        setupAddViews()
        setupConstraints()
        setupAction()
        setupButton()
    }
    
    func setupAddViews() {
        addSubview(titleLabel)
        addSubview(titledivider)
        addSubview(rightButton)
    }
    
    func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(AppResource.Padding.medium / 2)
            make.centerX.equalToSuperview()
        }
        rightButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(AppResource.Padding.medium / 2)
            make.right.equalToSuperview().inset(AppResource.Padding.medium)
            make.height.equalTo(30)
        }
        titledivider.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(AppResource.Padding.medium / 2)
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        }
    }
    
    func setupAction() {
        rightButton.addTarget(self, action: #selector(exit), for: .touchUpInside)
    }
    
    func setupButton() {
        if isUpdate {
            rightButton.setImage(UIImage(systemName: "trash.fill"), for: .normal)
            rightButton.tintColor = AppResource.Color.buttonWarringColor
        } else {
            rightButton.setImage(UIImage(systemName: "xmark"), for: .normal)
            rightButton.tintColor = AppResource.Color.blackColor
        }
    }
    
    @objc func exit() {
        isUpdate ? deleteAction?() : dismissAction?()
    }
}

