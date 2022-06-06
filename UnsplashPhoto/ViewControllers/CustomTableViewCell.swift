//
//  CustomTableViewCell.swift
//  UnsplashPhoto
//
//  Created by Вячеслав Квашнин on 06.06.2022.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    var result: Result!
    
    static let identifier = "CustomTableViewCell"
    
    private let imageViewCell: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let labelCell: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(imageViewCell)
        contentView.addSubview(labelCell)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(imageView: Data, text: String) {
        labelCell.text = text
        imageViewCell.image = UIImage(data: imageView)
    }
    
    override func prepareForReuse() {
        labelCell.text = nil
        imageViewCell.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageViewCell.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        labelCell.frame = CGRect(x: 130, y: 0, width: 200, height: 100)
    }
}
