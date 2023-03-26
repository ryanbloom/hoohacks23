//
//  ReceiptService.swift
//  FinanceApp
//
//  Created by William Wang on 3/25/23.
//

import Foundation
//
//curl -X POST \
//2  https://api.mindee.net/v1/products/mindee/expense_receipts/v4/predict \
//3  -H 'Authorization: Token 4b54cf8fdd2d14eb77163c19a20cd504' \
//4  -H 'content-type: multipart/form-data' \
//5  -F document=@/path/to/your/file.png
struct test{
    
    guard let url = URL(string: "https://api.mindee.net/v1/products/mindee/expense_receipts/v4/predicts"),
          let payload = "{\"documentId\": \"a50920e1-214b-4c46-9137-2c03f96aad56\"}".data(using: .utf8) else
    {
        return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("your_api_key", forHTTPHeaderField: "x-api-key")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = payload
    
    URLSession.shared.dataTask(with: request) { (data, response, error) in
        guard error == nil else { print(error!.localizedDescription); return }
        guard let data = data else { print("Empty data"); return }
        
        if let str = String(data: data, encoding: .utf8) {
            print(str)
        }
    }.resume()
    
    
}









//
//struct ReceiptService {
//    private let session: URLSession = .shared
//    private let decoder: JSONDecoder = Welcome.decoder
//    private let encoder: JSONEncoder = .init()
//}
//
//
//        components?.queryItems = [URLQueryItem(name: "latitude", value: "\(latitude)"), URLQueryItem(name: "longitude", value: "\(longitude)")]
//
////        print(components)
//        guard let url = components?.url else { fatalError("Invalid URl") }
//        let (data, _) = try await session.data(from: url)
//        // Note: you must provide the `latitude` and `longitude` query parameters
////        print(try! decoder.decode([Restroom].self, from: data))
//        // Example: https://learning.appteamcarolina.com/loocator/search?latitude=35.9&longitude=-79
//
//        let Restrooms = try decoder.decode([Restroom].self, from: data)
//        return Restrooms
//    }
//}
//
//
//
//
//
//
//
//extension ReceiptService {
//    static func getWeather(cityString: String) async throws-> Welcome? {
//        let apiKey = "4b54cf8fdd2d14eb77163c19a20cd504"
//        
//        var components = URLComponents(string: "https://learning.appteamcarolina.com/loocator/restrooms")
//
//        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(cityString)&appid=\(apiKey)") else {
//            print("Error")
//            return nil
//        }
//        
//        do {
//            let (data, _) = try await URLSession.shared.data(from: url)
//            
//            if let decodedData = try? JSONDecoder().decode(Welcome.self, from: data) {
//                return decodedData
//            } else {
//                print("Decoding error")
//                return nil
//            }
//        } catch {
//            print("Error Loading Data")
//            return nil
//        }
//    }
//}
//
