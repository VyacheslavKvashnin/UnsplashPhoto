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
        
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            CustomTableViewCell.self,
            forCellReuseIdentifier: CustomTableViewCell.identifier
        )
        tableView.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func fetchData() {
        dataManager.fetchDataPhoto { [weak self] dataPhoto in
            self?.results = dataPhoto
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
        
        let imageURL = results[indexPath.row].photo
        let userName = results[indexPath.row].userName
        
        cell.configure(urlString: imageURL ?? "", text: userName ?? "")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let result = results[indexPath.row]
        let detailVC = DetailPhotoViewController()
        let res = Results(
            id: result.id ?? "",
            urls: URLs(regular: result.photo ?? "", small: ""),
            user: User(name: result.userName, location: result.location),
            created_at: result.date ?? "",
            downloads: Int(result.downloads))
        detailVC.result = res
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {  (contextualAction, view, boolValue) in
            let item = self.results[indexPath.row]
            DispatchQueue.main.async {
                self.showDeleteWarning(for: indexPath, item: item)
            }
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeActions
    }
    
    // MARK: - Alert
    
    func showDeleteWarning(for indexPath: IndexPath, item: DataPhoto) {
        let alert = UIAlertController(title: "Delete photo?", message: "Are you sure you want to delete the photo?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            DispatchQueue.main.async {
                self.results.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                self.dataManager.deleteData(item: item)
            }
        }
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)

        present(alert, animated: true, completion: nil)
    }
}
