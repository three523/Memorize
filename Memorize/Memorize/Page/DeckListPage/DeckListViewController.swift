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
    private let deckTableView: UITableView = {
        let tableView = UITableView()
        tableView.estimatedRowHeight = UITableView.automaticDimension
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(deckTableView)
        view.addSubview(addDeckButton)
        
        let rightBarItem = UIBarButtonItem(image: UIImage(systemName: "textformat.size"), style: .done, target: self, action: #selector(updateFontSize))
        navigationItem.rightBarButtonItem = rightBarItem
        
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
    
    @objc private func updateFontSize() {
        //TODO: fontSize 업데이트 기능 추가
    }
    
    @objc private func addDeck() {
        let vc = DeckAddViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
}

extension DeckListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DeckTableViewCell.resuableIdentifier, for: indexPath) as? DeckTableViewCell else { return UITableViewCell() }
        return cell
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI
struct DeckListViewController_Preview: PreviewProvider {
    static var previews: some View {
        let vc = DeckListViewController()
        vc.title = "덱 모음"
        return UINavigationController(rootViewController: vc).showPreview()
    }
}
#endif


