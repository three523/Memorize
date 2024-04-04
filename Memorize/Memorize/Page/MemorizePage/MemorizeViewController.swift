//
//  MemorizeViewController.swift
//  Memorize
//
//  Created by 김도현 on 2024/03/26.
//

import UIKit

class MemorizeViewController: UIViewController {

    private let deckView: DeckView
    private let doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("완료", for: .normal)
        button.backgroundColor = AppResource.Color.buttonMainColor
        button.isHidden = true
        return button
    }()
    private let cardControlView: CardControlStackView = CardControlStackView()
    private let againAreaView: SwipeAreaView = SwipeAreaView(title: "Again")
    private let memorizeAreaView: SwipeAreaView = SwipeAreaView(title: "Memorize")
    private var cards: [Card]
        
    private var currentIndex: Int = 0 {
        didSet {
            if currentIndex + 1 > cards.count { return }
            navigationItem.title = "\(currentIndex + 1)/\(cards.count)"
        }
    }
    
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
        setupButton()
        setupCardView(index: 0)
        addCardViewGesture()
        setupCardControlView()
    }
    
    func addViews() {
        view.addSubview(doneButton)
        view.addSubview(deckView)
        view.addSubview(cardControlView)
    }
    
    func setupAutoLayout() {
        let safeArea = view.safeAreaLayoutGuide
        doneButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(AppResource.ButtonSize.xLarge * 2)
            make.height.equalTo(AppResource.ButtonSize.xLarge)
        }
        deckView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        cardControlView.snp.makeConstraints { make in
            make.top.equalTo(deckView.snp.bottom).offset(AppResource.Padding.medium)
            make.horizontalEdges.equalTo(safeArea)
            make.bottom.equalTo(safeArea)
            make.height.equalTo(AppResource.ButtonSize.large)
        }
    }
    
    func setupNavigation() {
        navigationItem.title = "\(currentIndex + 1)/\(cards.count)"
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
    
    func setupButton() {
        doneButton.addTarget(self, action: #selector(done), for: .touchUpInside)
    }
    
    @objc func done() {
        navigationController?.popViewController(animated: true)
    }
    
    func setupCardControlView() {
        cardControlView.failAction = { [weak self] in
            guard let self else { return }
            self.cards.append(cards[currentIndex])
            self.deckView.cards.append(cards[currentIndex])
            self.cardMoveAnimation(moveView: self.deckView.frontCardView, isMemorize: false)
        }
        cardControlView.hintAction = { [weak self] in
            guard let self else { return }
            self.deckView.setHintHiddenToggle()
        }
        cardControlView.successAction = { [weak self] in
            guard let self else { return }
            self.cardMoveAnimation(moveView: self.deckView.frontCardView, isMemorize: true)
        }
    }
    
    func setupCardView(index: Int) {
        if currentIndex >= cards.count {
            deckView.isHidden = true
            doneButton.isHidden = false
            return
        }
        deckView.setupCardView(index: index)
    }
    
    @objc func cardMove(sender: UIPanGestureRecognizer) {
        guard let moveView = sender.view else { return }
        deckView.setCardScrollEnable(isEnable: false)
        let point = sender.translation(in: view)
        moveView.center = CGPoint(x: view.center.x + point.x, y: view.center.y + point.y)
        let distance = moveView.center.x - deckView.backgroundCardView.center.x
        
        if distance >= 0 {
            memorizeAreaView.backgroundColor = .systemGreen.withAlphaComponent(abs(distance)/100)
            againAreaView.backgroundColor = .red.withAlphaComponent(0)
        } else {
            memorizeAreaView.backgroundColor = .systemGreen.withAlphaComponent(0)
            againAreaView.backgroundColor = .red.withAlphaComponent(abs(distance)/100)
        }
                        
        if sender.state == .ended {
            if moveView.center.x < 100 {
                cards.append(cards[currentIndex])
                deckView.cards.append(cards[currentIndex])
                cardMoveAnimation(moveView: moveView, isMemorize: false)
            } else if moveView.center.x > (view.bounds.width - 100) {
                cardMoveAnimation(moveView: moveView, isMemorize: true)
            } else {
                UIView.animate(withDuration: 0.3) {
                    moveView.center = self.deckView.backgroundCardView.center
                }
            }
            self.memorizeAreaView.backgroundColor = .systemGreen.withAlphaComponent(0)
            self.againAreaView.backgroundColor = .red.withAlphaComponent(0)
            self.deckView.setCardScrollEnable(isEnable: true)
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
}
