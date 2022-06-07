//
//  DetailViewController.swift
//  UnsplashPhoto
//
//  Created by Вячеслав Квашнин on 04.06.2022.
//

import UIKit

final class FavoriteViewController: UIViewController {
    
    var results: [DataPhoto] = []
    let tableView = UITableView()
    
    var dataManager = DatabaseManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favorite"
        view.backgroundColor = .systemBackground
        
        fetchData()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(
            CustomTableViewCell.self,
            forCellReuseIdentifier: CustomTableViewCell.identifier
        )
        view.addSubview(tableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func fetchData() {
        dataManager.fetchDataPhoto { [weak self] dataPhoto in
            self?.results = dataPhoto
            self?.tableView.reloadData()
        }
    }
}

 // MARK: - UITableViewDataSource, UITableViewDelegate 

extension FavoriteViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CustomTableViewCell.identifier,
            for: indexPath) as? CustomTableViewCell else { return UITableViewCell() }
        
        guard let imageURL = results[indexPath.row].photo else { return UITableViewCell() }
        guard let userName = results[indexPath.row].userName else { return UITableViewCell() }
        
        cell.configure(urlString: imageURL, text: userName)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let result = results[indexPath.row]
        let detailVC = DetailPhotoViewController()
//        detailVC.result = result
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {  (contextualAction, view, boolValue) in
            self.results.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            let item = self.results[indexPath.row]
            self.showAlert(
                title: "Are you sure you want to delete the picture?",
                message: "",
                item: item)
            tableView.reloadData()
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeActions
    }
}

 // MARK: - Alert

extension FavoriteViewController {
    func showAlert(title: String, message: String, item: DataPhoto) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { _ in
            self.dataManager.deleteData(item: item)
        }))
        present(alert, animated: true, completion: nil)
    }
}
