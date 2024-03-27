//
//  Deck.swift
//  Memorize
//
//  Created by 김도현 on 2024/03/25.
//

import Foundation

struct Deck {
    let id: UUID
    let title: String
    let explanation: String?
    let cards: [Card]
}
