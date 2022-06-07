//
//  DetailPhotoViewController.swift
//  UnsplashPhoto
//
//  Created by Вячеслав Квашнин on 05.06.2022.
//

import UIKit

final class DetailPhotoViewController: UIViewController {
    
    private let stackView = UIStackView()
    
    var result: Results!
    
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
        button.addTarget(self, action: #selector(saveInFavorite), for: .touchUpInside)
        return button
    }()
    
    @objc func saveInFavorite() {
        addToFavorite()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        userName.text = result.user?.name
        dataCreate.text = result.created_at
        locationUser.text = result.user?.location
        numberDownloads.text = String(result.downloads)
        view.addSubview(photoImageView)
        configureStackView()
        setImage(urlString: result.urls.regular)
    }
    
    private func addToFavorite() {
        guard let controllers = tabBarController?.viewControllers else { return }
        for controller in controllers {
            let navigationVC = controller as? UINavigationController
            if let favoriteVC = navigationVC?.topViewController as? FavoriteViewController {
                
                if favoriteVC.results.first?.id != result.id {
                    addInFavoriteButton.setTitle("Remove from favorites", for: .normal)
                    favoriteVC.results.append(result)
                } else {
                    if let index = favoriteVC.results.firstIndex(where: { $0.id == result.id }) {
                        favoriteVC.results.remove(at: index)
                        addInFavoriteButton.setTitle("Add To Favorite", for: .normal)
                    }
                }
                favoriteVC.tableView.reloadData()
            }
        }
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
        do {
            let dataImage = try Data(contentsOf: url)
            photoImageView.image = UIImage(data: dataImage)
        } catch {
            print("error")
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { _ in
            print("ok")
        }))
        present(alert, animated: true, completion: nil)
    }
}
