//
//  CardControler.swift
//  Memorize
//
//  Created by 김도현 on 2024/04/15.
//

import Foundation

final class DeckController {
    private var deck: Deck
    private let deckRepository: DeckRepository
    private var currentIndex: Int = 0
    
    init(deck: Deck, deckRepository: DeckRepository) {
        self.deck = deck
        self.deckRepository = deckRepository
        self.deck = shuffle(deck: deck, currentIndex: currentIndex)
    }
    
    func getCurrentCard() -> Card? {
        return getCard(index: currentIndex)
    }
    
    func getNextCard() -> Card? {
        guard let nextCard = getCard(index: currentIndex + 1) else {
            return nil
        }
        return nextCard
    }
    
    func getPreviousCard() -> Card? {
        guard let previousCard = getCard(index: currentIndex - 1) else {
            return nil
        }
        return previousCard
    }
    
    func next() {
        currentIndex += 1
    }
    
    func previous() {
        currentIndex -= 1
    }
    
    func appendCard() {
        deck.cards.append(deck.cards[currentIndex])
    }
    
    func getMemorizingCardCount() -> Int {
        return getMemorizingCards().count
    }
    
    func getMemorizedCardCount() -> Int {
        return getMemorizedCards().count
    }
    
    func getCardCount() -> Int {
        return deck.cards.count
    }
    
    private func shuffle(deck: Deck, currentIndex: Int) -> Deck {
        let currentCards = getMemorizedCards()
        let shuffledCards = getMemorizingCards().shuffled()
        let newCards = currentCards + shuffledCards
        return copyAndUpdateCards(deck: deck, updateCards: newCards)
    }
    
    private func getMemorizingCards() -> [Card] {
        return deck.cards.isOutOfRange(index: currentIndex) ? [] : Array(deck.cards[currentIndex + 1..<deck.cards.count])
    }
    
    private func getMemorizedCards() -> [Card] {
        return deck.cards.isOutOfRange(index: currentIndex) ? [] : Array(deck.cards[0...currentIndex])
    }
    
    private func updateCard(updatedCard: Card) {
        if saveCard(updateCard: updatedCard) {
            self.deck = updateDeck(updatedCard: updatedCard)
            return
        }
        print("error")
    }
    
    private func saveDeck(updateDeck: Deck) -> Bool {
        return deckRepository.updateDeck(updateDeck: updateDeck)
    }
    
    private func saveCard(updateCard: Card) -> Bool {
        return deckRepository.updateCard(updateCard: updateCard)
    }
    
    private func updateDeck(updatedCard: Card) -> Deck {
        let newCards = deck.cards.map{ card in
            return card.id == updatedCard.id ? updatedCard : card
        }
        return copyAndUpdateCards(deck: deck, updateCards: newCards)
    }
    
    private func getCard(index: Int) -> Card? {
        return deck.cards.isOutOfRange(index: index) ? nil : deck.cards[index]
    }
    
    private func copyAndUpdateCards(deck: Deck, updateCards: [Card]) -> Deck {
        return Deck(id: deck.id, title: deck.title, explanation: deck.explanation, cards: updateCards)
    }
}
