//
//  CharactersController.swift
//  BreakingBadMVVM
//
//  Created by Abilio Gambim Parada on 20/01/2020.
//  Copyright © 2020 Abilio Gambim Parada. All rights reserved.
//

import Foundation
import UIKit

class CharactersViewController: UINavigationController {

    private lazy var tableView = UITableView()
    
    private lazy var activityIndicator = UIActivityIndicatorView()

    private var viewModel: CharactersViewModel?
    
    private var char: [Character] = []{
        didSet{
            self.tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupView()
        setupConstraints()
        setupMVVM()
        setupBinding()
    }

    fileprivate func setupMVVM(){
        viewModel = CharactersViewModel(service: Service.shared)
        setupBinding()
        viewModel?.setupController()
    }
    
    fileprivate func setupBinding(){
        viewModel?.onCharacters = { [weak self] (characters) in
            guard let self = self else {return}
            self.char = characters
        }
        
        viewModel?.onLoading = { [weak self] (loading) in
            guard let self = self else {return}
            if loading{
                self.tableView.isHidden = true
                self.activityIndicator.startAnimating()
            } else{
                self.activityIndicator.stopAnimating()
                self.tableView.isHidden = false
            }
        }
    }
    
    fileprivate func setupView(){
        self.view.backgroundColor = .white
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(activityIndicator)
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
        
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
        ])
    }
    
    
}

extension CharactersViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return char.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let character =  char[indexPath.row]
        let cellViewModel = ItemCellViewModel(model: character)
        let cell = ItemCell(with: cellViewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132
    }

}

extension CharactersViewController: UITableViewDelegate{
    
}
