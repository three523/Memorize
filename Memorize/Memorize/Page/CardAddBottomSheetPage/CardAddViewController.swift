//
//  CardAddViewController.swift
//  Memorize
//
//  Created by 김도현 on 2024/03/26.
//

import UIKit

final class CardAddViewController: UIViewController {
    
    private let topView: PopupTopView = PopupTopView(title: "카드 추가하기")
    private let formView: FormView = FormView()
    private let addCardButton: UIButton = {
        let button = UIButton()
        button.setTitle("카드 저장", for: .normal)
        button.setTitleColor(AppResource.Color.textWhiteColor, for: .normal)
        button.backgroundColor = AppResource.Color.mainColor
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(topView)
        view.addSubview(formView)
        view.addSubview(addCardButton)
        
        view.backgroundColor = .white
        
        let safeArea = view.safeAreaLayoutGuide
        
        topView.snp.makeConstraints { make in
            make.top.left.right.equalTo(safeArea)
        }
        
        formView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom).offset(AppResource.Padding.medium)
            make.left.right.equalTo(safeArea).inset(AppResource.Padding.medium)
        }
        
        addCardButton.snp.makeConstraints { make in
            make.top.equalTo(formView.snp.bottom).offset(AppResource.Padding.xLarge)
            make.left.right.equalTo(safeArea).inset(AppResource.Padding.medium)
            make.height.equalTo(AppResource.ButtonSize.xLarge)
        }
        
        addCardButton.addTarget(self, action: #selector(clickAddCardButton), for: .touchUpInside)

    }
    
    @objc private func clickAddCardButton() {
        
    }

}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct CardAddViewControllerPreview: PreviewProvider {
    static var previews: some View {
        let vc = CardAddViewController()
        return vc.showPreview()
    }
}
#endif
