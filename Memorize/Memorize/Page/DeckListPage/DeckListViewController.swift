//
//  ViewController.swift
//  Memorize
//
//  Created by 김도현 on 2024/03/25.
//

import UIKit

final class DeckListViewController: UIViewController {
    
    private let addDeckButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = AppResource.Color.whiteColor
        button.backgroundColor = AppResource.Color.mainColor
        button.layer.cornerRadius = AppResource.ButtonSize.xLarge / 2
        button.clipsToBounds = true
        return button
    }()
    private let deckTableView: EmptyableTableView = {
        let tableView = EmptyableTableView()
        tableView.setMessage(type: .deckEmpty)
        tableView.estimatedRowHeight = UITableView.automaticDimension
        return tableView
    }()
    private let deckRepository: DeckRepository
    private var decks: [Deck]
    
    init(repository: DeckRepository) {
        self.deckRepository = repository
        self.decks = deckRepository.allFetch()
        super.init(nibName: nil, bundle: nil)
        showEmptyMessageView(value: decks.isEmpty)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(deckTableView)
        view.addSubview(addDeckButton)
        
        //TODO: FontSize 바꾸기 기능 추가하기
//        let rightBarItem = UIBarButtonItem(image: UIImage(systemName: "textformat.size"), style: .done, target: self, action: #selector(updateFontSize))
//        navigationItem.rightBarButtonItem = rightBarItem
        
        let safeArea = view.safeAreaLayoutGuide
        deckTableView.snp.makeConstraints { make in
            make.edges.equalTo(safeArea).inset(AppResource.Padding.small)
        }
        addDeckButton.snp.makeConstraints { make in
            make.right.bottom.equalTo(safeArea).inset(AppResource.Padding.large)
            make.width.height.equalTo(AppResource.ButtonSize.xLarge)
        }
        addDeckButton.addTarget(self, action: #selector(addDeck), for: .touchUpInside)
        deckTableView.delegate = self
        deckTableView.dataSource = self
        deckTableView.register(DeckTableViewCell.self, forCellReuseIdentifier: DeckTableViewCell.resuableIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        decks = deckRepository.allFetch()
        showEmptyMessageView(value: decks.isEmpty)
        deckTableView.reloadData()
    }
    
    @objc private func updateFontSize() {
        //TODO: fontSize 업데이트 기능 추가
    }
    
    @objc private func addDeck() {
        let vc = DeckAddViewController(repository: deckRepository)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func showEmptyMessageView(value: Bool) {
        deckTableView.state = value ? .empty : .nomarl
    }
}

extension DeckListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return decks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DeckTableViewCell.resuableIdentifier, for: indexPath) as? DeckTableViewCell else { return UITableViewCell() }
        let deck = decks[indexPath.row]
        cell.titleLabel.text = deck.title
        cell.explanationLabel.text = deck.explanation
        cell.editAction = { [weak self] in
            guard let self else { return }
            let vc = DeckAddViewController(repository: self.deckRepository, deck: deck)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = CardListViewController(repository: deckRepository, deck: decks[indexPath.row])
        navigationController?.pushViewController(vc, animated: true)
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI
struct DeckListViewController_Preview: PreviewProvider {
    static var previews: some View {
        let vc = DeckListViewController(repository: DeckRepository())
        vc.title = "덱 모음"
        return UINavigationController(rootViewController: vc).showPreview()
    }
}
#endif


