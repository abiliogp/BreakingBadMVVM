//
//  CharactersViewModel.swift
//  BreakingBadMVVM
//
//  Created by Abilio Gambim Parada on 20/01/2020.
//  Copyright © 2020 Abilio Gambim Parada. All rights reserved.
//

import Foundation
import RxSwift

class CharactersViewModel {
    
    var onCharacters: (([Character]) -> Void)?
    
    var onError: ((ServiceError) -> Void)?
    
    var onLoading: ((Bool) -> Void)?
}
