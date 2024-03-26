//
//  CardAddViewController.swift
//  Memorize
//
//  Created by 김도현 on 2024/03/26.
//

import UIKit

final class CardAddViewController: UIViewController {
    
    private let cardScrollView: UIScrollView = UIScrollView()
    private let topView: PopupTopView = PopupTopView(title: "카드 추가하기")
    private let formView: FormView = FormView()
    private let addCardButton: UIButton = {
        let button = UIButton()
        button.setTitle("카드 저장", for: .normal)
        button.setTitleColor(AppResource.Color.textWhiteColor, for: .normal)
        button.backgroundColor = AppResource.Color.mainColor
        return button
    }()
    
    private var previusOffset: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(topView)
        view.addSubview(cardScrollView)
        cardScrollView.addSubview(formView)
        view.addSubview(addCardButton)
        
        view.backgroundColor = .white
        
        let safeArea = view.safeAreaLayoutGuide
        
        topView.snp.makeConstraints { make in
            make.top.left.right.equalTo(safeArea)
        }
        
        cardScrollView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom).offset(AppResource.Padding.medium)
            make.left.right.equalTo(safeArea)
            make.bottom.equalTo(addCardButton.snp.top).offset(-AppResource.Padding.medium)
        }
        
        formView.snp.makeConstraints { make in
            make.top.equalTo(cardScrollView.snp.top).offset(AppResource.Padding.medium)
            make.left.right.equalTo(safeArea).inset(AppResource.Padding.medium)
            make.bottom.equalTo(cardScrollView.snp.bottom).inset(AppResource.Padding.medium)
        }
        
        addCardButton.snp.makeConstraints { make in
            make.left.right.equalTo(safeArea).inset(AppResource.Padding.medium)
            make.height.equalTo(AppResource.ButtonSize.xLarge)
            make.bottom.equalTo(safeArea).inset(AppResource.ButtonSize.xLarge)
        }
                
        addCardButton.addTarget(self, action: #selector(clickAddCardButton), for: .touchUpInside)
        
        formView.updateTextViewHeight = { [weak self] height in
            //TODO: 텍스트뷰의 사이즈가 변경될때 스크롤 위치가 변경되도록 구현하기 키보드도 생각해야함
            guard let self = self,
            self.cardScrollView.contentSize.height >=  self.cardScrollView.bounds.height else { return }
            var contentOffset = self.cardScrollView.contentOffset
            contentOffset.y += height
            print(contentOffset)
            self.cardScrollView.setContentOffset(contentOffset, animated: true)
        }

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
