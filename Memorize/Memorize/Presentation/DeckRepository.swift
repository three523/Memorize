//
//  DeckRepository.swift
//  Memorize
//
//  Created by 김도현 on 2024/03/26.
//

import CoreData

final class DeckRepository {
    
    enum CoreDataType {
        case inMemory
        case sqlite
    }
    
    private let type: CoreDataType
    private var decks: [Deck] = []
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Memorize")
        
        if self.type == .inMemory {
            let description = NSPersistentStoreDescription()
            description.url = URL(fileURLWithPath: "/dev/null")
            container.persistentStoreDescriptions = [description]
        }

        container.loadPersistentStores { (_, error) in
            if let error = error as NSError? {
                fatalError("Unable to load core data persistent stores: \(error)")
            }
        }

        return container
    }()
    
    private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    init(type: CoreDataType = .inMemory) {
        self.type = type
    }
    
    func allFetch() -> [Deck] {
        let fetchRequest: NSFetchRequest<DeckEntity> = DeckEntity.fetchRequest()
        do {
            let decks = try context.fetch(fetchRequest).map{ convertToDeck(deckEntity: $0) }
            return decks
        } catch {
            print("fetch for update Person error: \(error)")
            return []
        }
    }
    
    //MARK: Deck CRUD
    func fetch(id: UUID) -> Deck? {
        guard let deckEntity: DeckEntity = fetchEntity(id: id) else { return nil }
        return convertToDeck(deckEntity: deckEntity)
    }
    
    private func fetchEntity(id: UUID) -> DeckEntity? {
        let fetchRequest: NSFetchRequest<DeckEntity> = DeckEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        do {
            let deckEntity = try context.fetch(fetchRequest)
            return deckEntity.first
        } catch {
            print("fetch for update Person error: \(error)")
            return nil
        }
    }
    
    func addDeck(deck: Deck) {
        let deckEntity = DeckEntity(context: context)
        deckEntity.id = deck.id
        deckEntity.title = deck.title
        deckEntity.explanation = deck.explanation
        save()
    }
    
    func updateDeck(updateDeck: Deck) -> Bool {
        guard let deckEntity: DeckEntity = fetchEntity(id: updateDeck.id) else { return false }
        deckEntity.id = updateDeck.id
        deckEntity.title = updateDeck.title
        deckEntity.explanation = updateDeck.explanation
        deckEntity.cards = NSOrderedSet(array: updateDeck.cards)
        return true
    }
    
    func removeDeck(deck: Deck) -> Bool {
        guard let deckEntity: DeckEntity = fetchEntity(id: deck.id) else { return false }
        context.delete(deckEntity)
        return true
    }
    
    
    //MARK: CardCRUD
    func fetch(id: UUID) -> Card? {
        guard let cardEntity: CardEntity = fetchEntity(id: id) else { return nil }
        return convertToCard(cardEntity: cardEntity)
    }
    
    private func fetchEntity(id: UUID) -> CardEntity? {
        let fetchRequest: NSFetchRequest<CardEntity> = CardEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        do {
            let cardEntity = try context.fetch(fetchRequest)
            return cardEntity.first
        } catch {
            print("fetch for update Person error: \(error)")
            return nil
        }
    }
    
    func addCard(deck: Deck, card: Card) -> Bool {
        guard let deckEntity: DeckEntity = fetchEntity(id: deck.id) else { return false }
        let cardEntity = convertToCardEntity(card: card)
        deckEntity.addToCards(cardEntity)
        save()
        return true
    }
    
    func updateCard(updateCard: Card) -> Bool {
        guard var cardEntity: CardEntity = fetchEntity(id: updateCard.id) else { return false }
        cardEntity.id = updateCard.id
        cardEntity.front = updateCard.frontText
        cardEntity.back = updateCard.backText
        cardEntity.hint = updateCard.hintText
        save()
        return true
    }
    
    func removeCard(card: Card) -> Bool {
        guard let cardEntity: CardEntity = fetchEntity(id: card.id) else { return false }
        context.delete(cardEntity)
        return true
    }
    
    private func convertToDeck(deckEntity: DeckEntity) -> Deck {
        let cardEntitys = deckEntity.cards?.array as? [CardEntity] ?? []
        let cards: [Card] = cardEntitys.map{ convertToCard(cardEntity: $0) }
        return Deck(id: deckEntity.id!, title: deckEntity.title!, explanation: deckEntity.explanation, cards: cards)
    }
    
    private func convertToCard(cardEntity: CardEntity) -> Card {
        return Card(id: cardEntity.id!, frontText: cardEntity.front!, backText: cardEntity.back!, hintText: cardEntity.hint)
    }
    
    private func convertToDeckEntity(deck: Deck) -> DeckEntity {
        let deckEntity = DeckEntity(context: context)
        deckEntity.id = deck.id
        deckEntity.title = deck.title
        deckEntity.explanation = deck.explanation
        return deckEntity
    }
    
    private func convertToCardEntity(card: Card) -> CardEntity {
        let cardEntity = CardEntity(context: context)
        cardEntity.id = card.id
        cardEntity.front = card.frontText
        cardEntity.back = card.backText
        cardEntity.hint = card.hintText
        return cardEntity
        
    }
    
    private func save() {
        do {
            try context.save()
        } catch let e {
            print(e.localizedDescription)
        }
    }
}
