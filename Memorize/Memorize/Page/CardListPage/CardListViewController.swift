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
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.setMessage(type: .cardEmpty)
        return tableView
    }()
    private let addDeckButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = AppResource.Color.whiteColor
        button.backgroundColor = AppResource.Color.buttonSubColor
        button.layer.cornerRadius = AppResource.ButtonSize.xLarge / 2
        button.clipsToBounds = true
        return button
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(cardTableView)
        view.addSubview(addDeckButton)
        view.addSubview(memorizeStartButton)
        
        //TODO: 검색기능 추가하기
//        setUpSearchController()
                    
        let safeArea = view.safeAreaLayoutGuide
        cardTableView.snp.makeConstraints { make in
            make.top.left.right.equalTo(safeArea).inset(AppResource.Padding.small)
            make.bottom.equalTo(memorizeStartButton.snp.top).offset(AppResource.Padding.small)
        }
        addDeckButton.snp.makeConstraints { make in
            make.right.equalTo(safeArea).inset(AppResource.Padding.large)
            make.width.height.equalTo(AppResource.ButtonSize.xLarge)
        }
        memorizeStartButton.snp.makeConstraints { make in
            make.top.equalTo(addDeckButton.snp.bottom).offset(AppResource.Padding.medium)
            make.left.right.bottom.equalTo(safeArea)
            make.height.equalTo(AppResource.ButtonSize.xLarge)
        }
        
        addDeckButton.addTarget(self, action: #selector(addCard), for: .touchUpInside)
        memorizeStartButton.addTarget(self, action: #selector(startMemorize), for: .touchUpInside)
        cardTableView.delegate = self
        cardTableView.dataSource = self
        cardTableView.register(CardTableViewCell.self, forCellReuseIdentifier: CardTableViewCell.resuableIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let newDeck: Deck = deckRepository.fetch(id: deck.id) else { return }
        self.deck = newDeck
        showEmptyMessageView(value: deck.cards.isEmpty)
        cardTableView.reloadData()
    }
    
//    func setUpSearchController() {
//        navigationItem.titleView = cardSearchController.searchBar
//
//        cardSearchController.delegate = self
//        cardSearchController.searchBar.placeholder = "카드 내용 검색"
//        cardSearchController.hidesNavigationBarDuringPresentation = false
//        cardSearchController.searchResultsUpdater = self
//
//
//        definesPresentationContext = true
//    }
    
    @objc private func addCard() {
        let vc = CardAddViewController(repository: deckRepository, deck: deck)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func startMemorize() {
        let cards = [Card(id: UUID(),frontText: "테스트", backText: "Test", hintText: nil),Card(id: UUID(), frontText: "테스트1", backText: "Test1", hintText: nil),Card(id: UUID(), frontText: "테스트2", backText: "Test2", hintText: nil),Card(id: UUID(), frontText: "테스트3", backText: "Test3", hintText: nil)]
        navigationController?.pushViewController(MemorizeViewController(cards: cards), animated: true)
    }
    
    private func showEmptyMessageView(value: Bool) {
        cardTableView.state = value ? .empty : .nomarl
    }
}

extension CardListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deck.cards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CardTableViewCell.resuableIdentifier, for: indexPath) as? CardTableViewCell else { return UITableViewCell() }
        let card = deck.cards[indexPath.row]
        cell.frontTextLabel.text = card.frontText
        cell.backTextLabel.text = card.backText
        if let hintText = card.hintText {
            cell.hintTextLabel.isHidden = false
            cell.hintTextLabel.text = hintText
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let card = deck.cards[indexPath.row]
        let vc = CardAddViewController(repository: deckRepository, deck: deck, card: card)
        navigationController?.pushViewController(vc, animated: true)
    }
}

//extension CardListViewController: UISearchControllerDelegate, UISearchResultsUpdating {
//    func updateSearchResults(for searchController: UISearchController) {
//        guard let searchText = searchController.searchBar.text else { return }
//        cardTableView.reloadData()
//    }
//}


#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct CardListViewController_Preview: PreviewProvider {
    static var previews: some View {
        let vc = CardListViewController(repository: DeckRepository(), deck: Deck(id: UUID(), title: "덱이름", explanation: "덱설명", cards: [Card(id: UUID(), frontText: "front text", backText: "back text", hintText: "hint text")]))
        return UINavigationController(rootViewController: vc).showPreview()
    }
}
#endif
