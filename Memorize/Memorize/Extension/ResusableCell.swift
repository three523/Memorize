//
//  Resuseble.swift
//  Memorize
//
//  Created by 김도현 on 2024/03/26.
//

import Foundation
import UIKit

protocol ReusableCell {
    static var resuableIdentifier: String { get }
}

extension ReusableCell {
    static var resuableIdentifier: String {
        return "\(self)"
    }
}

extension UITableViewCell: ReusableCell {
    static var resuableIdentifier: String {
        return "\(self)"
    }
}
