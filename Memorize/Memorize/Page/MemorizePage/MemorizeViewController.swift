//
//  MemorizeViewController.swift
//  Memorize
//
//  Created by 김도현 on 2024/03/26.
//

import UIKit

class MemorizeViewController: UIViewController {

    private let deckView: DeckView
    private let cards: [Card]
    
    private let margin: CGFloat = 24
    
    private var currentIndex: Int = 0
    
    init(cards: [Card]) {
        self.cards = cards
        self.deckView = DeckView(cards: cards)
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
}

private extension MemorizeViewController {
    func setup() {
        addViews()
        setupAutoLayout()
        setupNavigation()
        setupCardView(index: 0)
        addCardViewGesture()
    }
    
    func addViews() {
        view.addSubview(deckView)
    }
    
    func setupAutoLayout() {
        deckView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setupNavigation() {
        let leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .done, target: self, action: #selector(popViewController))
        leftBarButtonItem.tintColor = .black
        navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationItem.title = "단어보기"
    }
    
    @objc private func popViewController() {
        dismiss(animated: true)
    }
    
    func addCardViewGesture() {
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(cardMove(sender:)))
        deckView.frontCardView.addGestureRecognizer(panGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleBackLabel))
        deckView.frontCardView.isUserInteractionEnabled = true
        deckView.frontCardView.addGestureRecognizer(tapGesture)
    }
    
    @objc func toggleBackLabel() {
        deckView.frontCardView.backLabel.isHidden.toggle()
    }
    
    func keyboardReturn() {
        cardMoveAnimation(moveView: deckView.frontCardView, isMemorize: true)
    }
    
    func setupCardView(index: Int) {
        if currentIndex == cards.count - 1 {
            deckView.isHidden = true
            navigationController?.popViewController(animated: true)
            return
        }
        deckView.setupCardView(index: index)
    }
    
    func navigationPushQuizCompletePage() {
    }
    
    @objc func cardMove(sender: UIPanGestureRecognizer) {
        guard let moveView = sender.view else { return }
        let point = sender.translation(in: view)
        moveView.center = CGPoint(x: view.center.x + point.x, y: view.center.y + point.y)
                        
        if sender.state == .ended {
            if moveView.center.x < 100 {
                cardMoveAnimation(moveView: moveView, isMemorize: false)
            } else if moveView.center.x > (view.bounds.width - 100) {
                cardMoveAnimation(moveView: moveView, isMemorize: true)
            } else {
                UIView.animate(withDuration: 0.3) {
                    moveView.center = self.deckView.backgroundCardView.center
                }
            }
        }
    }
    
    private func cardMoveAnimation(moveView: UIView, isMemorize: Bool) {
        let animationPositionX = isMemorize ? moveView.center.x + moveView.bounds.width : moveView.center.x - moveView.bounds.width
        UIView.animate(withDuration: 0.3) {
            moveView.center = CGPoint(x: animationPositionX, y: moveView.center.y)
        } completion: { _ in
            self.currentIndex += 1
            self.setupCardView(index: self.currentIndex)
        }
    }
    
    private func failedWordSetup() {
        navigationPushQuizCompletePage()
    }
}
