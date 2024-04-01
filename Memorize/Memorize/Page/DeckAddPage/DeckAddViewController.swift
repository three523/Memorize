//
//  DeckAddBottomSheetViewController.swift
//  Memorize
//
//  Created by 김도현 on 2024/03/25.
//

import UIKit
import SnapKit

final class DeckAddViewController: UIViewController {
        
    private let topDivider: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        return view
    }()
    
    private let deckTitleLabel: UILabel = {
        let view = UILabel()
        view.text = "카드덱 제목"
        view.font = .systemFont(ofSize: AppResource.FontSize.contentSubTitle, weight: .regular)
        return view
    }()
    
    private let deckTitleTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.backgroundColor = AppResource.Color.whiteColor
        textField.placeholder = "카드덱의 이름을 입력해 주세요!"
        textField.becomeFirstResponder()
        return textField
    }()
    
    private let deckExplanationLabel: UILabel = {
        let view = UILabel()
        view.text = "카드덱 설명"
        view.font = .systemFont(ofSize: AppResource.FontSize.contentSubTitle, weight: .regular)
        return view
    }()
    
    private let deckExplanationTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .white
        textField.placeholder = "카드덱 설명을 입력해 주세요!"
        return textField
    }()
    
    private let bottomDivider: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        return view
    }()

    private let addDeckButton: DefaultButton = {
        let button = DefaultButton()
        button.isHidden = true
        button.setTitle("생성", for: .normal)
        button.addTarget(self, action: #selector(addDeck), for: .touchUpInside)
        return button
    }()
    
    private let blankStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()
    private let keyboardHeightView: UIView = UIView()
    
    private let deckRepository: DeckRepository
    private var deck: Deck?
    
    init(repository: DeckRepository, deck: Deck? = nil) {
        self.deckRepository = repository
        self.deck = deck
        super.init(nibName: nil, bundle: nil)
        setupDeck()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(topDivider)
        view.addSubview(deckTitleLabel)
        view.addSubview(deckTitleTextField)
        view.addSubview(deckExplanationLabel)
        view.addSubview(deckExplanationTextField)
        view.addSubview(bottomDivider)
        view.addSubview(addDeckButton)
        view.addSubview(blankStackView)
        
        setupConstraints()
        setupTextField()
        setupNavigation()
    }
    
    private func setupConstraints() {
        
        let padding = AppResource.Padding.medium
        
        topDivider.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(1)
            
        }
        deckTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(topDivider.snp.bottom).offset(padding)
            make.left.equalToSuperview().offset(padding)
        }
        
        deckTitleTextField.snp.makeConstraints { (make) in
            make.top.equalTo(deckTitleLabel.snp.bottom).offset(padding / 2)
            make.left.right.equalTo(view.safeAreaLayoutGuide).inset(AppResource.Padding.medium)
        }
        
        deckExplanationLabel.snp.makeConstraints { make in
            make.top.equalTo(deckTitleTextField.snp.bottom).offset(padding)
            make.left.equalToSuperview().offset(padding)
        }
        
        deckExplanationTextField.snp.makeConstraints { (make) in
            make.top.equalTo(deckExplanationLabel.snp.bottom).offset(padding / 2)
            make.left.right.equalTo(view.safeAreaLayoutGuide).inset(padding)
        }
        
        bottomDivider.snp.makeConstraints { make in
            make.top.equalTo(deckExplanationTextField.snp.bottom).offset(padding)
            make.left.right.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(1)
        }
        
        addDeckButton.snp.makeConstraints { make in
            make.top.equalTo(bottomDivider.snp.bottom).offset(padding)
            make.left.right.equalTo(view.safeAreaLayoutGuide).inset(padding)
        }
    }
    
    private func setupTextField() {
        deckTitleTextField.delegate = self
        deckExplanationTextField.delegate = self
    }
    
    private func setupNavigation() {
        navigationItem.title = "덱 추가"
        if deck != nil {
            let deleteButtonItem = UIBarButtonItem(image: UIImage(systemName: "trash.fill"), style: .done, target: self, action: #selector(deleteDeck))
            deleteButtonItem.tintColor = AppResource.Color.warringColor
            navigationItem.rightBarButtonItem = deleteButtonItem
            
            addDeckButton.setTitle("덱 업데이트", for: .normal)
        }
    }
    
    @objc private func addDeck() {
        var newDeck = Deck(id: UUID(), title: deckTitleTextField.text!, explanation: deckExplanationTextField.text, cards: [])
        if let oldDeck = self.deck {
            newDeck = Deck(id: oldDeck.id, title: newDeck.title, explanation: newDeck.explanation, cards: oldDeck.cards)
            if deckRepository.updateDeck(updateDeck: newDeck) {
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            deckRepository.addDeck(deck: newDeck)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc private func deleteDeck() {
        guard let deck = self.deck else { return }
        if deckRepository.removeDeck(deck: deck) {
            navigationController?.popViewController(animated: true)
        }
    }
    
    func setupDeck() {
        guard let deck else { return }
        deckTitleTextField.text = deck.title
        deckExplanationTextField.text = deck.explanation
    }
    
    func buttonHiddenMotion(toggle:Bool){
        UIView.transition(with: addDeckButton, duration: 0.5, options: .transitionFlipFromTop, animations: { [weak self] in
            if toggle{
                self?.addDeckButton.alpha = 0
            } else {
                self?.addDeckButton.alpha = 1
            }
        })
    }
   
}

extension DeckAddViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if deck == nil && textField == deckExplanationTextField {
            return
        }
        guard let text = textField.text else { return }
        if text.count == 0 {
            addDeckButton.isHidden = true
            buttonHiddenMotion(toggle: addDeckButton.isHidden)
        } else if text.count >= 1{
            if addDeckButton.isHidden {
                addDeckButton.isHidden = false
                buttonHiddenMotion(toggle: addDeckButton.isHidden)
            } else {
                addDeckButton.isHidden = false
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == deckTitleTextField {
            deckExplanationTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI
struct DeckAddBottomSheetViewController_Preview: PreviewProvider {
    static var previews: some View {
        return DeckAddViewController(repository: DeckRepository()).showPreview()
    }
}
#endif
