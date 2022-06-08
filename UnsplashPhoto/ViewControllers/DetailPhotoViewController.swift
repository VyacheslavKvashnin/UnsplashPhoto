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
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
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
        button.addTarget(self, action: #selector(pressedSaveAndDelete), for: .touchUpInside)
        return button
    }()
    
    @objc func pressedSaveAndDelete() {
        saveOrDeleteToFavorite()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupView()
        view.addSubview(photoImageView)
        configureStackView()
        setImage(urlString: result.urls.regular)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkTitleButton()
    }
    
    private func saveOrDeleteToFavorite() {
        if addInFavoriteButton.titleLabel?.text == "Add To Favorite" {
            setDataInCoreData()
            addInFavoriteButton.setTitle("Remove from favorites", for: .normal)
        } else if addInFavoriteButton.titleLabel?.text == "Remove from favorites" {
            addInFavoriteButton.setTitle("Add To Favorite", for: .normal)
            deleteFromFavorite()
        }
    }
    
    private func checkTitleButton() {
        if let index = dataManager.results.firstIndex(where: { $0.id == result.id }) {
            getIndexResults(index: index)
        }
    }
    
    private func getIndexResults(index: Int) {
        if let indexResults = dataManager.results[index].id {
            setTitleForButton(index: indexResults)
        }
    }
    
    private func setTitleForButton(index: String) {
        if index != result.id {
            addInFavoriteButton.setTitle("Add To Favorite", for: .normal)
        } else {
            addInFavoriteButton.setTitle("Remove from favorites", for: .normal)
        }
    }
    
    private func setupView() {
        userName.text = "Name: \(result.user?.name ?? "")"
        dataCreate.text = "Data: \(getDate(date: result.created_at))"
        locationUser.text = "Location: \(result.user?.location ?? "")"
        numberDownloads.text = "Downloads: \(String(result.downloads))"
    }
    
    private func getDate(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let data = dateFormatter.date(from: date) ?? Date()
        return dateFormatter.string(from: data)
    }
    
    private func deleteFromFavorite() {
        if let index = dataManager.results.firstIndex(where: { $0.id == result.id }) {
            dataManager.deleteData(item: dataManager.results.remove(at: index))
        }
    }
    
    private func setDataInCoreData() {
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
