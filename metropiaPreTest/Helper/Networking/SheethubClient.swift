//
//  SheethubClient.swift
//  metropiaPreTest
//
//  Created by Eric Chen on 2021/8/15.
//

import Foundation
final class SheethubClient {
    private lazy var baseURL: URL? = {
       return URL(string: "https://sheethub.com/")
    }()
    let session: URLSession
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    func fetchAreaBoundaries(with request: AreaRequest, completion: @escaping (Result<Area, HTTPError>) -> Void){
        let areaID = request.areaID
        guard let url = URL(string: "ronnywang/100%E5%B9%B4%E5%85%A8%E5%9C%8B%E7%B8%A3%E5%B8%82%E7%95%8C%E5%9C%96/uri/\(areaID)", relativeTo: baseURL) else {
            completion(.failure(.invalidURL))
            return
        }
        var urlRequest = URLRequest(url: url)
        let parameters = ["format": "geojson"]
        urlRequest = urlRequest.queryDataAdapter(data: parameters)
        session.dataTask(with: urlRequest) { (data, response, error) in
            if let _ = error {
                completion(.failure(.requestFail))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.noHttpResponse))
                return
            }
            
            guard httpResponse.isSuccess else {
                completion(.failure(.httpResponseFail))
                return
            }
            
            guard let data = data else{
                completion(.failure(.noData))
                return
            }
            
            let decoder = JSONDecoder()
            
            do{
                let area = try decoder.decode(Area.self, from: data)
                completion(.success(area))
            }catch{
                print("JSON Decode is fail. \(String(describing: error))")
                completion(.failure(.jsonDecodingFail))
            }
        }.resume()
    }
}
