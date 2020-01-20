//
//  CharactersController.swift
//  BreakingBadMVVM
//
//  Created by Abilio Gambim Parada on 20/01/2020.
//  Copyright © 2020 Abilio Gambim Parada. All rights reserved.
//

import Foundation
import UIKit

class CharactersController: UINavigationController {

    private lazy var tableView = UITableView()

    private lazy var viewModel = CharactersViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupView()
        setupConstraints()
        
        Service.shared.fetchCharacters { result in
            switch result{
            case .success(let newCharacters):
                self.viewModel.characters = newCharacters
                self.tableView.reloadData()
                break
            case .failure(let error): break
            }
        }
    }
    
    
    fileprivate func setupView(){
        self.view.backgroundColor = .white
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(tableView)
    }
    
    fileprivate func setupConstraints(){
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
    
    
}

extension CharactersController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.characters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let character =  viewModel.characters[indexPath.row]
        let cell = ItemCell(with: character.name)
        return cell
    }

}

extension CharactersController: UITableViewDelegate{
    
}
