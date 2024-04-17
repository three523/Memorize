//
//  Array.swift
//  Memorize
//
//  Created by 김도현 on 2024/04/17.
//

import Foundation

extension Array {
    func isOutOfRange(index: Int) -> Bool {
        return index < 0 || index > count - 1
    }
}
