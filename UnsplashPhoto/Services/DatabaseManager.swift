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
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func fetchDataPhoto(completion: @escaping([DataPhoto]) -> Void) {
        do {
            let results = try context.fetch(DataPhoto.fetchRequest())
                completion(results)
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
        } catch {
            
        }
    }
    
    func deleteData(item: DataPhoto) {
        context.delete(item)
        do {
            try context.save()
        } catch {
            
        }
    }
    
}
