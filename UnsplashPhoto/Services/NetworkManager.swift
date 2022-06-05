//
//  DatabaseServices.swift
//  UnsplashPhoto
//
//  Created by Вячеслав Квашнин on 04.06.2022.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func searchPhotos(query: String, completion: @escaping(DataResponse) -> Void) {
        let urlString = "https://api.unsplash.com/search/photos?per_page=50&page=1&query=\(query)&client_id=EeIzrN0doNb4XPlVf2cb7-ObHtvadTYOXRVEXetBUgw"
        
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let result = try JSONDecoder().decode(DataResponse.self, from: data)
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
