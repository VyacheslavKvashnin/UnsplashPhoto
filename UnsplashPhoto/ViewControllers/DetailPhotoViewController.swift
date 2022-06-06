//
//  DetailPhotoViewController.swift
//  UnsplashPhoto
//
//  Created by Вячеслав Квашнин on 05.06.2022.
//

import UIKit

class DetailPhotoViewController: UIViewController {
    
    private let stackView = UIStackView()
    
    var result: Result!
    
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
    
    private let addInFavoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add Favorite", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = .systemCyan
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(saveInFavorite), for: .touchUpInside)
        return button
    }()
    
    @objc func saveInFavorite() {
        addToFavorite()
    }
    
    func addToFavorite() {
        
        guard let controllers = tabBarController?.viewControllers else { return }
        
        for controller in controllers {
            let navigationVC = controller as? UINavigationController
            let favoriteVC = navigationVC?.topViewController as? FavoriteViewController
            favoriteVC?.results.append(result)
            favoriteVC?.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        userName.text = result.user.name
        dataCreate.text = result.created_at
        view.addSubview(photoImageView)
        configureStackView()
        setImage(urlString: result.urls.regular)
    }
    
    private func configureStackView() {
        view.addSubview(stackView)
        stackView.axis = .vertical
        stackView.distribution = .equalCentering
        stackView.spacing = 20
        
        stackView.addArrangedSubview(photoImageView)
        stackView.addArrangedSubview(userName)
        stackView.addArrangedSubview(dataCreate)
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
        do {
            let dataImage = try Data(contentsOf: url)
            photoImageView.image = UIImage(data: dataImage)
        } catch {
            print("error")
        }
    }
}
