//
//  StocksTests.swift
//  StocksTests
//
//  Created by Khaleel Musleh on 10/9/22.
//

@testable import Stocks

import XCTest

class StocksTests: XCTestCase {

    func testSomething() {
        let number = 1
        let string = "1"
        
        XCTAssertEqual(number, Int(string))
    }

    func testCandleStickDataConversion() {
        let doubles: [Double] = Array(repeating: 12.2, count: 10)
        var timeInterval: [TimeInterval] = []
        for x in 0..<12{
           let interval = Date().addingTimeInterval(3600 * TimeInterval(x)).timeIntervalSince1970
            timeInterval.append(interval)
        }
        timeInterval.shuffle()
        
        let marketData = MarketDataResponse(open: doubles,
                                            close: doubles,
                                            high: doubles,
                                            low: doubles,
                                            status: "success",
                                            timestamps: timeInterval)
        
        let candleSticks = marketData.candleSticks
        XCTAssertEqual(candleSticks.count, marketData.open.count)
        XCTAssertEqual(candleSticks.count, marketData.close.count)
        XCTAssertEqual(candleSticks.count, marketData.high.count)
        XCTAssertEqual(candleSticks.count, marketData.low.count)


    }
    
}
