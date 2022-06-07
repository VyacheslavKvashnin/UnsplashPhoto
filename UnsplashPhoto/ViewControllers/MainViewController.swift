//
//  MainViewController.swift
//  UnsplashPhoto
//
//  Created by Вячеслав Квашнин on 04.06.2022.
//

import UIKit

final class MainViewController: UIViewController {
    
    private let networkManager = NetworkManager.shared
    private var collectionView: UICollectionView?
    private var results: [Results] = []
    private let searchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Photos"
        view.backgroundColor = .systemBackground
                
        searchBar.placeholder = "Search photo"
        searchBar.delegate = self
        view.addSubview(searchBar)
        
        fetchRandomPhoto()
        setLayoutCollectionView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchBar.frame = CGRect(
            x: 10,
            y: view.safeAreaInsets.top,
            width: view.frame.size.width - 20,
            height: 50)
        collectionView?.frame = CGRect(
            x: 0,
            y: view.safeAreaInsets.top + 55,
            width: view.frame.size.width,
            height: view.frame.size.height - 55)
    }
    
    private func fetchRandomPhoto() {
        networkManager.fetchPhotos(query: "") { [weak self] results in
            switch results {
            case .success(let results):
                self?.results = results
            case .failure(let error):
                print(error.localizedDescription)
            }
            self?.collectionView?.reloadData()
        }
    }
    
    private func setLayoutCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(
            width: view.frame.width / 2,
            height: view.frame.width / 2)
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.register(
            ImageCollectionViewCell.self,
            forCellWithReuseIdentifier: ImageCollectionViewCell.identifier
        )
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
        self.collectionView = collectionView
    }
}

// MARK: - UICollectionViewDataSource

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let result = results[indexPath.item]
        let detailVC = DetailPhotoViewController()
        detailVC.result = result
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        results.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let imageURL = results[indexPath.row].urls.regular
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as? ImageCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: imageURL)
        return cell
    }
}

// MARK: - UISearchBarDelegate

extension MainViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let text = searchBar.text {
            networkManager.fetchPhotos(query: text) { [weak self] results in
                switch results {
                case .success(let results):
                    self?.results = results
                case .failure(let error):
                    print(error.localizedDescription)
                }
                self?.collectionView?.reloadData()
            }
        }
    }
}
