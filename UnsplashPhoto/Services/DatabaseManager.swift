//
//  DatabaseManager.swift
//  UnsplashPhoto
//
//  Created by Вячеслав Квашнин on 07.06.2022.
//

import Foundation
import UIKit

class DatabaseManager {
    static let shared = DatabaseManager()
    
    private init() {}
    
    var results: [DataPhoto] = []
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func fetchDataPhoto(completion: @escaping([DataPhoto]) -> Void) {
        do {
            let results = try context.fetch(DataPhoto.fetchRequest())
            completion(results)
        } catch {
            
        }
        
    }
    
    func saveData(photo: String, userName: String, location: String, date: String, downloads: Int) {
        let dataPhoto = DataPhoto(context: context)
        dataPhoto.photo = photo
        dataPhoto.userName = userName
        dataPhoto.location = location
        dataPhoto.downloads = Int16(downloads)
        dataPhoto.date = date

        do {
            try context.save()
        } catch {
            
        }
        print(dataPhoto)
    }
    
    func deleteData(item: DataPhoto) {
        context.delete(item)
        do {
            try context.save()
        } catch {
            
        }
    }
    
}
