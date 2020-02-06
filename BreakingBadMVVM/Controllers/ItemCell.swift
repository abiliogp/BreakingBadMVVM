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
    
    private var itemCellViewModel: ItemCellViewModel?
    
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
        image.backgroundColor = .black
        image.layer.cornerRadius = 8
        image.translatesAutoresizingMaskIntoConstraints = false
        image.sizeThatFits(CGSize.init(width: 100, height: 100))
        return image
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.color = UIColor.white
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    public convenience init(with modelView: ItemCellViewModel!) {
        self.init(frame: .zero)
        self.itemCellViewModel = modelView
        setupViewBind()
    }
    
    private func setupViewBind(){
        self.itemCellViewModel?.onImgLoading = { [weak self] (loading) in
            guard let self = self else{ return }
            if loading{
                self.activityIndicator.startAnimating()
            } else{
                self.activityIndicator.stopAnimating()
            }
        }
        
        self.itemCellViewModel?.onImgReady = { [weak self] (imageView) in
            guard let self = self else{ return }
            self.imageItem.image = imageView
        }
        
        self.itemCellViewModel?.onTitleReady = { [weak self] (title) in
            guard let self = self else{ return }
            self.textItem.text = title
        }
        
        self.itemCellViewModel?.setupCell()
    }
    
    private func setupViews() {
        addSubview(textItem)
        addSubview(imageItem)
        addSubview(activityIndicator)
    }
    
    private func setupConstraints() {
        //add code here to layout views
        NSLayoutConstraint.activate([
            imageItem.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
            imageItem.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -padding),
            imageItem.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            imageItem.widthAnchor.constraint(equalToConstant: 100),
            imageItem.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        NSLayoutConstraint.activate([
            textItem.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            textItem.leadingAnchor.constraint(equalTo: imageItem.trailingAnchor, constant: padding)
        ])
        
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: self.imageItem.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: self.imageItem.centerXAnchor)
        ])
        
        //using add 1 its became bigger than values for imageView
        textItem.setContentHuggingPriority(.defaultLow + 1, for: .vertical)
        textItem.setContentCompressionResistancePriority(.defaultHigh + 1, for: .vertical)
    }
    
}
