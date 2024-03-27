//
//  DeckView.swift
//  Memorize
//
//  Created by 김도현 on 2024/03/26.
//

import UIKit
import SnapKit

class DeckView: UIView {

    let frontCardView: CardView = CardView()
    let backgroundCardView: CardView = CardView()
    private let margin: CGFloat = 24
    private var currentIndex: Int = 0
    var cards: [Card]
        
    init(cards: [Card]) {
        self.cards = cards
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension DeckView {
    func setup() {
        addViews()
        initCardView()
        setupCardView(index: 0)
        setupAutoLayout()
    }
    
    func addViews() {
        addSubview(backgroundCardView)
        addSubview(frontCardView)
    }
    
    func initCardView() {
        frontCardView.layer.borderWidth = 1
        frontCardView.layer.borderColor = UIColor.black.cgColor
        frontCardView.layer.cornerRadius = 10
        frontCardView.layer.masksToBounds = true
        
        backgroundCardView.layer.borderWidth = 1
        backgroundCardView.layer.borderColor = UIColor.black.cgColor
        backgroundCardView.layer.cornerRadius = 10
        backgroundCardView.layer.masksToBounds = true
    }
    
    func setupCardView(index: Int) {
        
        if cards.count <= index {
            frontCardView.isHidden = true
            return
        }
        
        let card = cards[index]
        frontCardView.center = backgroundCardView.center
        frontCardView.frontLabel.text = card.frontText
        frontCardView.backLabel.text = card.backText
        
        frontCardView.backLabel.isHidden = true
        
        if cards.count > index + 1 {
            let nextCard = cards[index + 1]
            backgroundCardView.frontLabel.text = nextCard.frontText
            backgroundCardView.backLabel.text = nextCard.backText
            
            backgroundCardView.backLabel.isHidden = true
        } else {
            backgroundCardView.isHidden = true
        }
    }
    
    func setupAutoLayout() {
        let safeArea = safeAreaLayoutGuide
        
        frontCardView.snp.makeConstraints { make in
            make.top.bottom.equalTo(safeArea).inset(margin)
            make.left.right.equalTo(safeArea).inset(margin)
        }
        backgroundCardView.snp.makeConstraints { make in
            make.edges.equalTo(frontCardView)
        }
    }
}
