//
//  DetailPhotoViewController.swift
//  UnsplashPhoto
//
//  Created by Вячеслав Квашнин on 05.06.2022.
//

import UIKit
import SDWebImage

final class DetailPhotoViewController: UIViewController {
    
    private let stackView = UIStackView()
    var result: Results!
    var dataManager = DatabaseManager.shared
    var favorite = FavoriteViewController()
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let userName: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let dataCreate: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let locationUser: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let numberDownloads: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let addInFavoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add To Favorite", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = .systemCyan
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(saveAndDeleteToFavorite), for: .touchUpInside)
        return button
    }()
    
    @objc func saveAndDeleteToFavorite() {
        
        
            setToFavorite()
    
            if let index = dataManager.results.firstIndex(where: { $0.id == result.id }) {
                dataManager.deleteData(item: dataManager.results.remove(at: index))
            }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setup()
        view.addSubview(photoImageView)
        configureStackView()
        setImage(urlString: result.urls.regular)
    }
    
    private func setup() {
        userName.text = result.user?.name
        dataCreate.text = result.created_at
        locationUser.text = result.user?.location
        numberDownloads.text = String(result.downloads)
    }

    private func setToFavorite() {
        dataManager.saveData(
            photo: result.urls.regular,
            userName: result.user?.name ?? "",
            location: result.user?.location ?? "",
            date: result.created_at,
            downloads: Int(result.downloads),
            id: result.id)
    }
    
    private func configureStackView() {
        view.addSubview(stackView)
        stackView.axis = .vertical
        stackView.distribution = .equalCentering
        stackView.spacing = 20
        
        stackView.addArrangedSubview(photoImageView)
        stackView.addArrangedSubview(userName)
        stackView.addArrangedSubview(dataCreate)
        stackView.addArrangedSubview(locationUser)
        stackView.addArrangedSubview(numberDownloads)
        stackView.addArrangedSubview(addInFavoriteButton)
        
        setStackViewConstraints()
    }
    
    private func setStackViewConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50).isActive = true
    }
    
    private func setImage(urlString: String) {
        guard let url = URL(string: urlString) else { return }
            photoImageView.sd_setImage(with: url)
    }
}
