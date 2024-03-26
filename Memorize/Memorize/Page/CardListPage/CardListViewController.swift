//
//  CardListViewController.swift
//  Memorize
//
//  Created by 김도현 on 2024/03/25.
//

import UIKit


final class CardListViewController: UIViewController {
    
    private let cardSearchController: UISearchController = UISearchController(searchResultsController: nil)
        
    private let cardTableView: UITableView = {
        let tableView = UITableView()
        tableView.estimatedRowHeight = UITableView.automaticDimension
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(cardTableView)
        view.addSubview(addDeckButton)
        view.addSubview(memorizeStartButton)
        
        setUpSearchController()
                    
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
        cardTableView.register(CardTableViewCell.self, forCellReuseIdentifier: CardTableViewCell.identifier)
    }
    
    func setUpSearchController() {
        navigationItem.titleView = cardSearchController.searchBar

        cardSearchController.delegate = self
        cardSearchController.searchBar.placeholder = "카드 내용 검색"
        cardSearchController.hidesNavigationBarDuringPresentation = false
        cardSearchController.searchResultsUpdater = self

   
        definesPresentationContext = true
    }
    
    @objc private func addCard() {
    }
    
    @objc private func startMemorize() {
    }
}

extension CardListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CardTableViewCell.identifier, for: indexPath) as? CardTableViewCell else { return UITableViewCell() }
        return cell
    }
}

extension CardListViewController: UISearchControllerDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        cardTableView.reloadData()
    }
}


#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct CardListViewController_Preview: PreviewProvider {
    static var previews: some View {
        let vc = CardListViewController()
        return UINavigationController(rootViewController: vc).showPreview()
    }
}
#endif
