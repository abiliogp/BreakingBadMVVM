//
//  ItemCellViewModel.swift
//  BreakingBadMVVM
//
//  Created by Abilio Gambim Parada on 05/02/2020.
//  Copyright © 2020 Abilio Gambim Parada. All rights reserved.
//

import Foundation
import UIKit

class ItemCellViewModel {

    var onTitleReady: ((String) -> Void)?

    var onImgLoading: ((Bool) -> Void)?

    var onImgReady: ((UIImage) -> Void)?

    private var imgService: ImageService?

    private var model: Character!

    init(service: ImageService = ImageService.shared, model: Character!) {
        self.imgService = service
        self.model = model
    }

    func setupCell() {

        self.onTitleReady?(model.name)

        self.onImgLoading?(true)

        self.imgService?.fetchImage(from: model.img, completionHandler: { [weak self] (result) in
            guard let self = self else { return }

            self.onImgLoading?(false)
            switch result {
            case .success(let img):
                self.onImgReady?(img)
            default:
                break
            }
        })
    }

}
