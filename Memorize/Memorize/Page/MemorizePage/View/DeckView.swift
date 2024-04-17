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
//    private var currentIndex: Int = 0
//    var cards: [Card]
        
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCardScrollEnable(isEnable: Bool) {
        frontCardView.setScrollEnable(isEnable: isEnable)
    }
    
    func setHintHiddenToggle() {
        frontCardView.hintLabel.isHidden.toggle()
    }
    
    func setupCardView(frontCard: Card?, nextCard: Card?) {
        
        guard let frontCard else {
            frontCardView.isHidden = true
            return
        }
        
        frontCardView.center = backgroundCardView.center
        frontCardView.frontLabel.text = frontCard.frontText
        frontCardView.backLabel.text = frontCard.backText
        frontCardView.hintLabel.text = frontCard.hintText
        
        frontCardView.backLabel.isHidden = true
        
        if let nextCard {
            backgroundCardView.frontLabel.text = nextCard.frontText
            backgroundCardView.backLabel.text = nextCard.backText
            backgroundCardView.backLabel.text = nextCard.hintText
            
            backgroundCardView.backLabel.isHidden = true
            backgroundCardView.hintLabel.isHidden = true
        } else {
            backgroundCardView.isHidden = true
        }
    }
    
}

private extension DeckView {
    func setup() {
        addViews()
        initCardView()
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
    
    func setupAutoLayout() {
        let safeArea = safeAreaLayoutGuide
        
        frontCardView.snp.makeConstraints { make in
            make.top.bottom.equalTo(safeArea).inset(AppResource.Padding.large)
            make.left.right.equalTo(safeArea).inset(AppResource.Padding.large)
        }
        backgroundCardView.snp.makeConstraints { make in
            make.edges.equalTo(frontCardView)
        }
    }
}
