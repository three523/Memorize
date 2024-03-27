//
//  CardAddViewController.swift
//  Memorize
//
//  Created by 김도현 on 2024/03/26.
//

import UIKit

final class CardAddViewController: UIViewController {
    
    private let cardScrollView: UIScrollView = UIScrollView()
    private let formView: FormView = FormView()
    private let addCardButton: UIButton = {
        let button = UIButton()
        button.setTitle("카드 저장", for: .normal)
        button.setTitleColor(AppResource.Color.textWhiteColor, for: .normal)
        button.backgroundColor = AppResource.Color.mainColor
        return button
    }()
    
    private var previusOffset: CGFloat = 0
    
    private let deckRepository: DeckRepository
    private let deck: Deck
    private var card: Card?
    
    init(repository: DeckRepository, deck: Deck, card: Card? = nil) {
        self.deckRepository = repository
        self.deck = deck
        self.card = card
        super.init(nibName: nil, bundle: nil)
        setupCard()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(cardScrollView)
        cardScrollView.addSubview(formView)
        view.addSubview(addCardButton)
        
        view.backgroundColor = .white
        
        navigationItem.title = "카드 저장"
        if card != nil {
            let deleteButtonItem = UIBarButtonItem(image: UIImage(systemName: "trash.fill"), style: .done, target: self, action: #selector(deleteCard))
            deleteButtonItem.tintColor = AppResource.Color.warringColor
            navigationItem.rightBarButtonItem = deleteButtonItem
            
            addCardButton.setTitle("카드 업데이트", for: .normal)
        }
        
        let safeArea = view.safeAreaLayoutGuide
        
        cardScrollView.snp.makeConstraints { make in
            make.top.equalTo(safeArea).offset(AppResource.Padding.medium)
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
                
        addCardButton.addTarget(self, action: #selector(addCard), for: .touchUpInside)
        
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
    
    @objc private func addCard() {
        guard var newCard = formView.getCard() else { return }
        if let oldCard = self.card {
            newCard = Card(id: oldCard.id, frontText: newCard.frontText, backText: newCard.backText, hintText: newCard.hintText)
            if deckRepository.updateCard(updateCard: newCard) {
                navigationController?.popViewController(animated: true)
            }
        } else {
            if deckRepository.addCard(deck: deck, card: newCard) {
                navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @objc private func deleteCard() {
        guard let card = self.card else { return }
        if deckRepository.removeCard(card: card) {
            navigationController?.popViewController(animated: true)
        }
    }
    
    func setupCard() {
        guard let card else { return }
        formView.updateText(card: card)
    }

}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct CardAddViewControllerPreview: PreviewProvider {
    static var previews: some View {
        let vc = CardAddViewController(repository: DeckRepository(), deck: Deck(id: UUID(), title: "Test", explanation: "test", cards: [Card(id: UUID(), frontText: "앞의 내용 테스트", backText: "뒤의 내용 테스트", hintText: "힌트: test")]))
        return vc.showPreview()
    }
}
#endif
