//
//  CharactersController.swift
//  BreakingBadMVVM
//
//  Created by Abilio Gambim Parada on 20/01/2020.
//  Copyright © 2020 Abilio Gambim Parada. All rights reserved.
//

import Foundation

class CharactersViewModel {

    var onCharacters: (([Character]) -> Void)?

    var onError: ((ServiceError) -> Void)?

    var onLoading: ((Bool) -> Void)?

    var service: CharacterServiceProtocol

    init(service: CharacterServiceProtocol = CharacterService()) {
        self.service = service
    }

    func setupController() {
        self.onLoading?(true)
        service.fetchCharacters { [weak self] result in
            DispatchQueue.main.async {
                self?.onLoading?(false)
                switch result {
                case .success(let newCharacters):
                    self?.onCharacters?(newCharacters)
                case .failure(let error):
                    self?.onError?(error)
                }
            }
        }
    }
}
