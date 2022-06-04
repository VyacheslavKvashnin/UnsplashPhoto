//
//  DatabaseServices.swift
//  UnsplashPhoto
//
//  Created by Вячеслав Квашнин on 04.06.2022.
//

import Foundation

class DatabaseServices {
    static let shared = DatabaseServices()
    private init() {}
    
    let urlString = "https://api.unsplash.com/search/photos?page=1&query=office&client_id=EeIzrN0doNb4XPlVf2cb7-ObHtvadTYOXRVEXetBUgw"
    
    func searchPhotos(completion: @escaping(APIResponse) -> Void) {
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let result = try JSONDecoder().decode(APIResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(result)
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
}
