//
//  CardListViewController.swift
//  Memorize
//
//  Created by 김도현 on 2024/03/25.
//

import UIKit


final class CardListViewController: UIViewController {
    
    private let cardSearchController: UISearchController = UISearchController(searchResultsController: nil)
        
    private let cardTableView: EmptyableTableView = {
        let tableView = EmptyableTableView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        tableView.setMessage(type: .cardEmpty)
        return tableView
    }()
    private let memorizeStartButton: UIButton = {
        let button = UIButton()
        button.setTitle("Memorize", for: .normal)
        button.tintColor = AppResource.Color.whiteColor
        button.backgroundColor = AppResource.Color.mainColor
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        return button
    }()
    private let deckRepository: DeckRepository
    private var deck: Deck
    
    init(repository: DeckRepository, deck: Deck) {
        self.deckRepository = repository
        self.deck = deck
        super.init(nibName: nil, bundle: nil)
        showEmptyMessageView(value: deck.cards.isEmpty)
        memorizeStartButton.isEnabled = !deck.cards.isEmpty
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(cardTableView)
        view.addSubview(memorizeStartButton)
        
        //TODO: 검색기능 추가하기
//        setUpSearchController()
                    
        let safeArea = view.safeAreaLayoutGuide
        cardTableView.snp.makeConstraints { make in
            make.top.left.right.equalTo(safeArea).inset(AppResource.Padding.small)
            make.bottom.equalTo(memorizeStartButton.snp.top).offset(AppResource.Padding.small)
        }
        memorizeStartButton.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(safeArea)
            make.height.equalTo(AppResource.ButtonSize.xLarge)
        }
        
        memorizeStartButton.addTarget(self, action: #selector(startMemorize), for: .touchUpInside)
        cardTableView.delegate = self
        cardTableView.dataSource = self
        cardTableView.register(CardTableViewCell.self, forCellReuseIdentifier: CardTableViewCell.resuableIdentifier)
        cardTableView.register(CardAddButtonTableViewCell.self, forCellReuseIdentifier: CardAddButtonTableViewCell.resuableIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let newDeck: Deck = deckRepository.fetch(id: deck.id) else { return }
        self.deck = newDeck
        showEmptyMessageView(value: deck.cards.isEmpty)
        memorizeStartButton.isEnabled = !deck.cards.isEmpty
        cardTableView.reloadData()
    }
    
    @objc private func startMemorize() {
        if deck.cards.isEmpty {
            //TODO: 카드가 없을 경우 에러처리
        } else {
            navigationController?.pushViewController(MemorizeViewController(cards: deck.cards), animated: true)
        }
    }
    
    private func showEmptyMessageView(value: Bool) {
        cardTableView.state = value ? .empty : .nomarl
        memorizeStartButton.backgroundColor = value ? AppResource.Color.disableColor : AppResource.Color.mainColor
    }
}

extension CardListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deck.cards.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0  {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CardAddButtonTableViewCell.resuableIdentifier, for: indexPath) as? CardAddButtonTableViewCell else { return UITableViewCell() }
            cell.addAction = { [weak self] in
                guard let self = self else { return }
                let vc = CardAddViewController(repository: self.deckRepository, deck: self.deck)
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CardTableViewCell.resuableIdentifier, for: indexPath) as? CardTableViewCell else { return UITableViewCell() }
        let card = deck.cards[indexPath.row - 1]
        cell.frontTextLabel.text = card.frontText
        cell.backTextLabel.text = card.backText
        if let hintText = card.hintText {
            cell.hintTextLabel.isHidden = false
            cell.hintTextLabel.text = hintText
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 { return }
        let card = deck.cards[indexPath.row - 1]
        let vc = CardAddViewController(repository: deckRepository, deck: deck, card: card)
        navigationController?.pushViewController(vc, animated: true)
    }
}


//#if canImport(SwiftUI) && DEBUG
//import SwiftUI
//
//struct CardListViewController_Preview: PreviewProvider {
//    static var previews: some View {
//        let vc = CardListViewController(repository: DeckRepository(), deck: Deck(id: UUID(), title: "덱이름", explanation: "덱설명", cards: [Card(id: UUID(), frontText: "front text", backText: "back text", hintText: "hint text")]))
//        return UINavigationController(rootViewController: vc).showPreview()
//    }
//}
//#endif
