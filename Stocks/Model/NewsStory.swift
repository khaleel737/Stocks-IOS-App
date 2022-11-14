//
//  NewsStory.swift
//  Stocks
//
//  Created by Khaleel Musleh on 10/8/22.
//

import Foundation

struct NewsStory: Codable {
    let category: String
    let datetime: TimeInterval
    let headline: String
    let image: String
    let related: String
    let source: String
    let summary: String
    let url: String
}
