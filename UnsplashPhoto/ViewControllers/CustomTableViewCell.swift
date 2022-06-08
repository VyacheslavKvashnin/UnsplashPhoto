//
//  CustomTableViewCell.swift
//  UnsplashPhoto
//
//  Created by Вячеслав Квашнин on 06.06.2022.
//

import UIKit
import SDWebImage

final class CustomTableViewCell: UITableViewCell {
    
    static let identifier = "CustomTableViewCell"
    
    private let imageViewCell: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
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
    
    func configure(urlString: String, text: String) {
        guard let url = URL(string: urlString) else { return }
        labelCell.text = text
        imageViewCell.sd_setImage(with: url)
    }
    
    override func prepareForReuse() {
        labelCell.text = nil
        imageViewCell.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageViewCell.frame = CGRect(x: 10, y: 0, width: 100, height: 95)
        labelCell.frame = CGRect(x: 130, y: 0, width: 200, height: 100)
    }
}

