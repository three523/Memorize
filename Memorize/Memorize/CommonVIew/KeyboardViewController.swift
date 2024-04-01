//
//  KeyboardViewController.swift
//  Memorize
//
//  Created by 김도현 on 2024/04/01.
//

import UIKit

class KeyboardViewController: UIViewController {
    
    var keyboardHeight: CGFloat = 0 {
        didSet {
            updateUI()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeKeyboardEvent()
    }
    
    deinit {
        removeKeyboardEvent()
    }
    
    func updateUI() {}

}

extension KeyboardViewController {
    private func initializeKeyboardEvent() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func removeKeyboardEvent() {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func keyboardWillShow(_ notification: Notification) {
           if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
               let keyboardSize = keyboardFrame.cgRectValue.size
               keyboardHeight = keyboardSize.height
           }
       }

    @objc func keyboardWillHide(_ notification: Notification) {
       keyboardHeight = 0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
