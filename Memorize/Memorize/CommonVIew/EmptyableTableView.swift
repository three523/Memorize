//
//  EmptyableTableView.swift
//  Memorize
//
//  Created by 김도현 on 2024/03/27.
//

import UIKit

final class EmptyableTableView: UITableView {
    
    enum CellCountState {
        case nomarl
        case empty
    }
    
    let emptyMessageView: MessageStackView = MessageStackView()
    
    var state: CellCountState = .nomarl {
        didSet {
            emptyMessageView.isHidden = state == .nomarl
        }
    }

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setMessage(type: MessageType) {
        emptyMessageView.type = type
    }
    
    func setMessage(image: UIImage?, imageSize: CGFloat = 60, title: String?, description: String?) {
        emptyMessageView.setImage(image: image)
        emptyMessageView.imageSize = imageSize
        emptyMessageView.titleLabel.text = title
        emptyMessageView.descriptionLabel.text = description
    }
}

private extension EmptyableTableView {
    private func setup() {
        addSubview(emptyMessageView)
        emptyMessageView.isHidden = true
        emptyMessageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
