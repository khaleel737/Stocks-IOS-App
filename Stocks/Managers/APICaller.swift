//
//  APICaller.swift
//  Stocks
//
//  Created by Khaleel Musleh on 10/7/22.
//

import Foundation

final class APICaller {
    static let shared = APICaller()
    
    private struct Constants {
        static let apiKey = "cd0dbf2ad3i3uigm9bv0cd0dbf2ad3i3uigm9bvg"
        static let sandBoxApiKey = "sandbox_cd0dbf2ad3i3uigm9c0g"
        static let baseURL = "https://finnhub.io/api/v1/"
        static let day: TimeInterval = 3600 * 24
        
    }
    
    private init() {}
    
    // MARK: - Public
    
    public func search(
        query: String,
        completion: @escaping (Result<SearchResponse, Error>) -> Void
    ) {
        guard let safeQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {return}
        request(url: url(for: .search, queryParams: ["q":query]), expecting: SearchResponse.self, completion: completion)
    }
    
    public func news(
        for type: NewsViewController.`Type`,
        completion: @escaping (Result<[NewsStory], Error>) -> Void
    ) {
        
        switch type {
        case .topStories:
        let url = url(for: .topStories, queryParams: ["category":"general"])
        request(url: url, expecting: [NewsStory].self, completion: completion)
        case .company(let symbol):
            let today = Date()
            let oneMonthBack = today.addingTimeInterval(-(Constants.day * 7))
            
            
            let url = url(for: .companyNews, queryParams: ["symbol": symbol,"from": DateFormatter.newsDateFormatter.string(from: oneMonthBack), "to": DateFormatter.newsDateFormatter.string(from: today)])
                          
        
        request(url: url, expecting: [NewsStory].self, completion: completion)
        }

    }
    
    public func marketData(
        for symbol: String,
        numberOfDays: TimeInterval = 7,
        completion: @escaping (Result<MarketDataResponse, Error>) -> Void
    ) {
        let today = Date().addingTimeInterval(-(Constants.day))
        let prior = today.addingTimeInterval(-(Constants.day * numberOfDays))
        let url = url(for: .marketData, queryParams: [
            "symbol": symbol,
            "resolution": "1",
            "from": "\(Int(prior.timeIntervalSince1970))",
            "to": "\(Int(today.timeIntervalSince1970))"
        ])
        
        request(url: url,
                expecting: MarketDataResponse.self,
                completion: completion
        )
    }
    
    public func financialMetrics(
        for symbol: String,
        completion: @escaping (Result<FinancialMetricsResponse, Error>) -> Void
    ) {
        let url = url(
                      for: .financials,
                      queryParams: ["symbol" : symbol, "metric": "all"]
        )
        
        request(url: url,
                expecting: FinancialMetricsResponse.self,
                completion: completion)
        
    }
    
    // MARK: - Private
    
    private enum EndPoint: String {
        case search
        case topStories = "news"
        case companyNews = "company-news"
        case marketData = "stock/candle"
        case financials = "stock/metric"
    }
    
    private enum APIError: Error {
        case noDataReturned
        case invalidURL
    }
    
    private func url(for endpoint: EndPoint, queryParams: [String: String] = [:]) -> URL? {
        var urlString = Constants.baseURL + endpoint.rawValue
        
        var queryItems = [URLQueryItem]()
        // Add any parameters
        for(name, value) in queryParams {
            queryItems.append(.init(name: name, value: value))
        }
        
        // Add Token
        queryItems.append(.init(name: "token", value: Constants.apiKey))
        
        // Convert Query items to suffix string
        let queryString = queryItems.map {"\($0.name)=\($0.value ?? "")"}.joined(separator: "&")
        
        urlString += "?" + queryString
                
        return URL(string: urlString)
        
    }
    
    private func request<T: Codable>(url: URL?, expecting: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = url else {
            completion(.failure(APIError.invalidURL))
            return
            
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.failure(APIError.noDataReturned))
                }
                return
            }
            
            do {
                let result = try JSONDecoder().decode(expecting, from: data)
                completion(.success(result))
            }
            catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
