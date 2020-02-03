//
//  ItemCell.swift
//  BreakingBadMVVM
//
//  Created by Abilio Gambim Parada on 20/01/2020.
//  Copyright © 2020 Abilio Gambim Parada. All rights reserved.
//

import Foundation
import UIKit

class ItemCell: UITableViewCell {
    
    private let padding: CGFloat = 16
    
    private lazy var textItem: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var imageItem: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.backgroundColor = .white
        image.layer.cornerRadius = 8
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    public convenience init(with title: String) {
        self.init(frame: .zero)
        textItem.text = title
    }
    
    private func setupViews() {
        addSubview(textItem)
        addSubview(imageItem)
    }
    
    private func setupConstraints() {
        //add code here to layout views
        NSLayoutConstraint.activate([
            imageItem.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
            imageItem.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            imageItem.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding)
        ])
        
        NSLayoutConstraint.activate([
            textItem.topAnchor.constraint(equalTo: imageItem.bottomAnchor, constant: padding),
            textItem.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            textItem.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -padding)
        ])
        
        //using add 1 its became bigger than values for imageView
        textItem.setContentHuggingPriority(.defaultLow + 1, for: .vertical)
        textItem.setContentCompressionResistancePriority(.defaultHigh + 1, for: .vertical)
    }
    
}
