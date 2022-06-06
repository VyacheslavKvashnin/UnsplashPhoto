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
    
    let token = "EeIzrN0doNb4XPlVf2cb7-ObHtvadTYOXRVEXetBUgw"
    
    func searchPhotos(query: String, completion: @escaping(DataResponse) -> Void) {
        
        guard let url = URL(string: "https://api.unsplash.com/search/photos?per_page=50&page=1&query=\(query)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Client-ID \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else { return }
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
