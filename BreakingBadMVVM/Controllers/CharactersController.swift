//
//  CharactersController.swift
//  BreakingBadMVVM
//
//  Created by Abilio Gambim Parada on 20/01/2020.
//  Copyright © 2020 Abilio Gambim Parada. All rights reserved.
//

import Foundation


class CharactersController {
    
    var viewModel: CharactersViewModel
    var service: Service
    
    init(viewModel: CharactersViewModel,
         service: Service = Service.shared) {
        self.viewModel = viewModel
        self.service = service
    }
    
    
    func setupController(){
        self.viewModel.onLoading?(true)
        service.fetchCharacters { result in
            self.viewModel.onLoading?(false)
            switch result{
            case .success(let newCharacters):
                self.viewModel.onCharacters?(newCharacters)
                break
            case .failure(let error):
                self.viewModel.onError?(error)
                break
            }
        }
    }
}
