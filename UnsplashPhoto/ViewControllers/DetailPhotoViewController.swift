//
//  DetailPhotoViewController.swift
//  UnsplashPhoto
//
//  Created by Вячеслав Квашнин on 05.06.2022.
//

import UIKit

class DetailPhotoViewController: UIViewController {
    
    var results: Result!
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 50, y: 80, width: 300, height: 300))
        return imageView
    }()
    
    private let userName: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 100, y: 300, width: 200, height: 200)
        return label
    }()
    
    private let dataCreate: UILabel = {
       let label = UILabel()
        label.frame = CGRect(x: 100, y: 400, width: 200, height: 200)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setImage()
        userName.text = results.user.name
        dataCreate.text = results.created_at
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(userName)
        view.addSubview(dataCreate)
    }
    
    private func setImage() {
        view.addSubview(photoImageView)
        guard let url = URL(string: results.urls.regular) else { return }
        do {
            let dataImage = try Data(contentsOf: url)
            photoImageView.image = UIImage(data: dataImage)
        } catch {
            print("error")
        }
        
    }
}
