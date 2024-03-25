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
    
    private let exitButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = AppResource.Color.blackColor
        return button
    }()
    
    weak var delegate: DismissDelegate?
        
    init(title: String) {
        super.init(frame: CGRect.zero)
        titleLabel.text = title
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
    }
    
    func setupAddViews() {
        addSubview(titleLabel)
        addSubview(titledivider)
        addSubview(exitButton)
    }
    
    func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(AppResource.Padding.medium / 2)
            make.centerX.equalToSuperview()
        }
        exitButton.snp.makeConstraints { make in
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
        exitButton.addTarget(self, action: #selector(exit), for: .touchUpInside)
    }
    
    @objc func exit() {
        delegate?.dismiss()
    }
}

