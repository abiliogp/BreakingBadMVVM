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

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ItemCell.self, forCellReuseIdentifier: ItemCell.reuseIdentifier)
        return tableView
    }()

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    private let cellHeight: CGFloat = 132
    private var viewModel: CharactersViewModel?

    private var char: [Character] = [] {
        didSet {
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

    private func setupMVVM() {
        viewModel = CharactersViewModel(service: CharacterService())
        setupBinding()
        viewModel?.setupController()
    }

    private func setupBinding() {
        viewModel?.onCharacters = { [weak self] (characters) in
            guard let self = self else {return}
            self.char = characters
        }

        viewModel?.onLoading = { [weak self] (loading) in
            guard let self = self else {return}
            if loading {
                self.tableView.isHidden = true
                self.activityIndicator.startAnimating()
            } else {
                self.activityIndicator.stopAnimating()
                self.tableView.isHidden = false
            }
        }
    }

    private func setupView() {
        self.setupNavigationBar()
        self.view.backgroundColor = .white
        self.view.addSubview(activityIndicator)
        self.view.addSubview(tableView)
    }

    private func setupNavigationBar() {
        let navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 44))
        let navigationItem = UINavigationItem(title: Environment.titleApp)
        navigationBar.setItems([navigationItem], animated: false)
        self.navigationBar.addSubview(navigationBar)
    }

    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])

        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor)
        ])
    }
}

extension CharactersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return char.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: ItemCell.reuseIdentifier) as? ItemCell {
            let character =  char[indexPath.row]
            let cellViewModel = ItemCellViewModel(model: character)
            cell.setViewModel(with: cellViewModel)
            return cell
        } else {
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }

}
