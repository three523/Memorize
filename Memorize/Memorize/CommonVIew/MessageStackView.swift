//
//  EmptyView.swift
//  Memorize
//
//  Created by 김도현 on 2024/03/27.
//

import UIKit

enum MessageType {
    case networkError
    case deckEmpty
    case cardEmpty
    case custom(image: UIImage?, title: String?, description: String?)
}

final class MessageStackView: UIStackView {
    let basicImageView: CircleImageView = .init()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: AppResource.FontSize.contentSubTitle, weight: .regular)
        label.textColor = AppResource.Color.textBlackColor
        label.textAlignment = .center
        return label
    }()

    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: AppResource.FontSize.contentSubTitle, weight: .regular)
        label.textColor = AppResource.Color.disableColor
        label.textAlignment = .center
        return label
    }()

    var type: MessageType = .custom(image: nil, title: nil, description: nil) {
        didSet {
            updateAtType()
        }
    }

    var imageSize: CGFloat {
        didSet {
            imageSizeUpdate()
        }
    }

    init(_ imageSize: CGFloat = 60) {
        self.imageSize = imageSize
        super.init(frame: .zero)
        axis = .vertical
        alignment = .center
        distribution = .fillProportionally
        spacing = 12
        setup()
    }

    convenience init(imageSize: CGFloat = 60, messageType: MessageType) {
        self.init(imageSize)
        self.type = messageType
        updateAtType()
    }

    convenience init(imageSize: CGFloat = 60, image: UIImage?) {
        self.init(imageSize)
        basicImageView.imageView.image = image
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MessageStackView {
    func setImage(image: UIImage?) {
        basicImageView.imageView.image = image
    }

    func setColor(color: UIColor) {
        basicImageView.tintColor = color
    }
}

private extension MessageStackView {
    func setup() {
        addViews()
        autoLayoutSetup()
        imageViewSetup()
    }

    func addViews() {
        addArrangedSubview(basicImageView)
        addArrangedSubview(titleLabel)
        addArrangedSubview(descriptionLabel)
    }

    func autoLayoutSetup() {
        basicImageView.snp.makeConstraints { make in
            make.width.height.equalTo(imageSize)
        }
    }

    func imageViewSetup() {
        basicImageView.backgroundColor = AppResource.Color.mainColor
        basicImageView.layer.cornerRadius = imageSize / 2
    }

    func imageSizeUpdate() {
        basicImageView.layer.cornerRadius = imageSize / 2
        basicImageView.snp.remakeConstraints { make in
            make.width.height.equalTo(imageSize)
        }
    }
}

private extension MessageStackView {
    func updateAtType() {
        switch type {
        case .networkError:
            basicImageView.imageView.image = UIImage(systemName: "wifi.exclamationmark")
            setColor(color: .red.withAlphaComponent(0.5))
            titleLabel.text = "인터넷 연결이 불안정 합니다"
            descriptionLabel.text = "인터넷을 연결하고 다시시도해주세요"
        case .deckEmpty:
            setImage(image: UIImage(systemName: "questionmark.folder"))
            titleLabel.text = "덱이 없습니다."
            descriptionLabel.text = "덱을 생성해주세요"
        case .cardEmpty:
            setImage(image: UIImage(systemName: "questionmark.square.fill"))
            titleLabel.text = "선택한 덱에 카드가 없습니다."
            descriptionLabel.text = "카드를 추가해주세요"
        case .custom(let image, let title, let description):
            setImage(image: image)
            titleLabel.text = title
            descriptionLabel.text = description
        }
    }
}

