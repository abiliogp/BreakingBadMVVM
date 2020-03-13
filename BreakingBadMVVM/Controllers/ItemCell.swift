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

    static let reuseIdentifier = "ItemCell"

    private var itemCellViewModel: ItemCellViewModel?

    private let padding: CGFloat = 16
    private let cornerRadius: CGFloat = 8
    private let imageSize = 100
    private let fontSize: CGFloat = 18

    private lazy var textItem: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: fontSize, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var imageItem: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.backgroundColor = .black
        image.layer.cornerRadius = cornerRadius
        image.translatesAutoresizingMaskIntoConstraints = false
        image.sizeThatFits(CGSize.init(width: imageSize, height: imageSize))
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

    public func setViewModel(with modelView: ItemCellViewModel) {
        self.itemCellViewModel = modelView
        setupViewBind()
    }

    private func setupViewBind() {
        self.itemCellViewModel?.onImgLoading = { [weak self] (loading) in
            guard let self = self else { return }
            if loading {
                self.activityIndicator.startAnimating()
            } else {
                self.activityIndicator.stopAnimating()
            }
        }

        self.itemCellViewModel?.onImgReady = { [weak self] (imageView) in
            guard let self = self else { return }
            self.imageItem.image = imageView
        }

        self.itemCellViewModel?.onTitleReady = { [weak self] (title) in
            guard let self = self else { return }
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

        textItem.setContentHuggingPriority(.defaultLow + 1, for: .vertical)
        textItem.setContentCompressionResistancePriority(.defaultHigh + 1, for: .vertical)
    }
}
