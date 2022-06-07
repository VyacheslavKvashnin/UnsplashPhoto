//
//  DatabaseServices.swift
//  UnsplashPhoto
//
//  Created by Вячеслав Квашнин on 04.06.2022.
//

import Foundation

enum NetworkError: Error {
    case badResponse(URLResponse)
    case badData
}

class NetworkManager {
    static let shared = NetworkManager()
    
    let token = "EeIzrN0doNb4XPlVf2cb7-ObHtvadTYOXRVEXetBUgw"
    
    let session: URLSession
    
    init() {
        let config = URLSessionConfiguration.default
        session = URLSession(configuration: config)
    }
    
    private func components() -> URLComponents {
        var component = URLComponents()
        component.scheme = "https"
        component.host = "api.unsplash.com"
        return component
    }
    
    private func request(url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.addValue("Client-ID \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func fetchPhotos(query: String, completion: @escaping([Result]?, Error?) -> Void) {
        var component = components()
        component.path = "/search/photos"
        component.queryItems = [
            URLQueryItem(name: "query", value: query)
        ]
        let reg = request(url: component.url!)
        
        let task = session.dataTask(with: reg) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                      completion(nil, NetworkError.badResponse(response!))
                      return
                  }
            
            guard let data = data else {
                completion(nil, NetworkError.badData)
                return
            }
            
            do {
                let result = try JSONDecoder().decode(ApiResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(result.results, nil)
                }
            } catch let error {
                completion(nil, error)
            }
        }
        task.resume()
    }
    
    
    func searchPhotos(query: String, completion: @escaping([Result]) -> Void) {
        
        guard let urlRandom = URL(string: "https://api.unsplash.com/photos/random/?count=30&query=\(query)") else { return }
        
        var request = URLRequest(url: urlRandom)
        request.httpMethod = "GET"
        request.setValue("Client-ID \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else { return }
            do {
                let result = try JSONDecoder().decode([Result].self, from: data)
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
