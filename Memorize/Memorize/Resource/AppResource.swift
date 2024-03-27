//
//  Color.swift
//  Memorize
//
//  Created by 김도현 on 2024/03/25.
//

import UIKit
struct AppResource {
    static let screenSize: CGSize = UIScreen.main.bounds.size
    
    enum Color {
        static let mainColor = UIColor.systemGreen
        
        static let buttonMainColor = UIColor.systemGreen
        static let buttonSubColor = UIColor.darkGray
        static let buttonWarringColor = UIColor.red
        static let disableColor = UIColor.systemGray
        
        static let textBackgroundColor = UIColor.systemGray4
        static let textBlackColor = UIColor.darkText
        static let textSubColor = UIColor.systemGray
        static let textWhiteColor = UIColor.white
        
        static let borderColor = UIColor.systemGray
        
        static let whiteColor = UIColor.white
        static let blackColor = UIColor.black
        static let warringColor = UIColor.red
    }
    
    enum Padding {
        static let small: CGFloat = 8
        static let medium: CGFloat = 16
        static let large: CGFloat = 24
        static let xLarge: CGFloat = 32
    }
    
    enum FontSize {
        static let contentSubTitle: CGFloat = 18
        static let contentTitle: CGFloat = 24
        static let title: CGFloat = 30
    }
    
    enum ButtonSize {
        static let small: CGFloat = 24
        static let medium: CGFloat = 36
        static let large: CGFloat = 48
        static let xLarge: CGFloat = 60
    }
}

