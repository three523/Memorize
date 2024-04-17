//
//  DeckTest.swift
//  Memorize
//
//  Created by 김도현 on 2024/04/16.
//

import XCTest
@testable import Debug_MemorizeCard

final class DeckTest: XCTestCase {
    
    private func createDeck(cardCount: Int) -> Deck {
        return Deck(id: UUID(), title: "테스트 덱", explanation: "설명", cards: createCards(count: cardCount))
    }
    
    private func createCards(count: Int) -> [Card] {
        var cards = [Card]()
        for i in 0..<count {
            cards.append(Card(id: UUID(), frontText: "front \(i)", backText: "back \(i)", hintText: "hint \(i)"))
        }
        return cards
    }
    
    func test_deck에_카드가_없을때_현재카드를_가져오면_nil을_반환해야함() {
        let deckController = DeckController(deck: createDeck(cardCount: 0), deckRepository: DeckRepository(type: .inMemory))
        XCTAssertNil(deckController.getCurrentCard())
    }
    
    func test_다음_카드를_호출시_다음카드가_없을경우_nil() {
        let deckController = DeckController(deck: createDeck(cardCount: 0), deckRepository: DeckRepository(type: .inMemory))
        XCTAssertNil(deckController.getNextCard()?.frontText)
    }
    
    func test_다음_카드를_호출시_다음카드를_가져옴() {
        let deckController = DeckController(deck: createDeck(cardCount: 5), deckRepository: DeckRepository(type: .inMemory))
        XCTAssertNotNil(deckController.getNextCard()?.frontText)
    }
    
    func test_이전_카드를_호출시_이전카드가_없을경우_nil() {
        let deckController = DeckController(deck: createDeck(cardCount: 5), deckRepository: DeckRepository(type: .inMemory))
        XCTAssertNil(deckController.getPreviousCard()?.frontText)
    }
    
    func test_이전_카드를_호출시_이전카드를_가져옴() {
        let deckController = DeckController(deck: createDeck(cardCount: 5), deckRepository: DeckRepository(type: .inMemory))
        deckController.next()
        XCTAssertNotNil(deckController.getPreviousCard()?.frontText, "front 0")
    }
    
    func test_카드_append시_현재_위치의_카드를_추가_시킴() {
        let deckController = DeckController(deck: createDeck(cardCount: 5), deckRepository: DeckRepository(type: .inMemory))
        let memorizedCardCount = deckController.getMemorizedCardCount()
        let memorizingCardCount = deckController.getMemorizingCardCount()
        deckController.appendCard()
        XCTAssertEqual(deckController.getMemorizedCardCount(), memorizedCardCount)
        XCTAssertEqual(deckController.getMemorizingCardCount(), memorizingCardCount + 1)
    }

}
