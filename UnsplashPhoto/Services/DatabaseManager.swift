//
//  DatabaseManager.swift
//  UnsplashPhoto
//
//  Created by Вячеслав Квашнин on 07.06.2022.
//

import UIKit

class DatabaseManager {
    static let shared = DatabaseManager()
    private init() {}
    var results: [DataPhoto] = []
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func fetchDataPhoto(completion: @escaping([DataPhoto]) -> Void) {
        do {
            self.results = try context.fetch(DataPhoto.fetchRequest())
            completion(self.results)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func saveData(photo: String, userName: String, location: String, date: String, downloads: Int, id: String) {
        let dataPhoto = DataPhoto(context: context)
        dataPhoto.photo = photo
        dataPhoto.userName = userName
        dataPhoto.location = location
        dataPhoto.downloads = Float(downloads)
        dataPhoto.date = date
        dataPhoto.id = id
        
        do {
            try context.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func deleteData(item: DataPhoto) {
        context.delete(item)
        do {
            try context.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
