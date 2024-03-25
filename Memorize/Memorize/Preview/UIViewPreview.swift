//
//  Preview.swift
//  Memorize
//
//  Created by 김도현 on 2024/03/25.
//

import Foundation

#if canImport(SwiftUI) && DEBUG
import SwiftUI
extension UIView {
    private struct Preview: UIViewRepresentable {
        typealias UIViewType = UIView

        let view: UIView

        func makeUIView(context: Context) -> UIView {
            return view
        }

        func updateUIView(_ uiView: UIView, context: Context) {
        }
    }

    func showPreview() -> some View {
        Preview(view: self).previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro"))
    }
}
#endif
