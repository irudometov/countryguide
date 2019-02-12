//
//  CountryGuideTests.swift
//  CountryGuideTests
//
//  Created by Ilya Rudometov on 05/02/2019.
//  Copyright © 2019 Ilya Rudometov. All rights reserved.
//

import XCTest
import Moya
@testable import CountryGuide

final class CountryGuideTests: XCTestCase {

    private let stubbingProvider = APIService(stubClosure: MoyaProvider.immediatelyStub)
    
    private let defaultTimeout = 1.0
    private let performanceTestIterations = 100

    private lazy var targetCountry: Country = {
        return Country(name: "Russian Federation",
                       alpha3Code: "RUS",
                       population: 146599183)
    }()
    
    private lazy var targetCurrency: Currency = {
        return Currency(name: "Russian ruble", symbol: "₽")
    }()
    
    private lazy var targetCountryInfo: CountryInfo = {
        return CountryInfo(name: self.targetCountry.name,
                           alpha3Code: "RUS",
                           population: self.targetCountry.population,
                           capital: "Moscow",
                           borders: ["AZE","BLR","CHN","EST","FIN","GEO","KAZ",
                                     "PRK","LVA","LTU","MNG","NOR","POL","UKR"],
                           currencies: [self.targetCurrency])
    }()
    
    func testGetAllCountries() {
        
        // NOTE: only one country 'Russian Federation' will be returned for a test puppose.
        
        let expectation = XCTestExpectation(description: "Success result")
        
        stubbingProvider.getAllCountires { result in
            
            switch result {
            case .success(let countries):
                
                XCTAssert(countries.count == 1, "A single country should be returned.")
                
                guard let country = countries.first else {
                    XCTFail("The first country should exists.")
                    return
                }
                
                // Basic info
                
                XCTAssert(country.name == self.targetCountry.name, "Invalid name")
                XCTAssert(country.population == self.targetCountry.population, "Invalid population")
                XCTAssert(country.populationString == self.targetCountry.populationString, "Invalid populationString")
                
            case .failure(let error):
                XCTFail("Request failed with error: \(error.localizedDescription)")
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: defaultTimeout)
    }
    
    func testGetCountryDetails() {
        
        let expectation = XCTestExpectation(description: "Success result")
        
        stubbingProvider.getDetails(of: targetCountry) { result in
            
            switch result {
            case .success(let summary):
                
                // Basic info
                
                XCTAssert(summary.name == self.targetCountryInfo.name, "Invalid name")
                XCTAssert(summary.population == self.targetCountryInfo.population, "Invalid population")
                XCTAssert(summary.populationString == self.targetCountryInfo.populationString, "Invalid populationString")
                XCTAssert(summary.alpha3Code == self.targetCountryInfo.alpha3Code, "Invalid alpha3Code")
                XCTAssert(summary.capital == self.targetCountryInfo.capital, "Invalid capital")
                
                // Currencies
                
                XCTAssert(summary.currencies.count == self.targetCountryInfo.currencies.count, "Invalid number of currencies")
                
                guard let firstCurrency = summary.currencies.first else {
                    XCTFail("summary.currencies should contains at least one currency")
                    return
                }
                
                XCTAssert(firstCurrency.name == self.targetCurrency.name, "Invalid currency name")
                XCTAssert(firstCurrency.symbol == self.targetCurrency.symbol, "Invalid currency symbol")
                
                // Borders
                
                XCTAssert(summary.borders == self.targetCountryInfo.borders, "Invalid borders values")
                
            case .failure(let error):
                XCTFail("Request failed with error: \(error.localizedDescription)")
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: defaultTimeout)
    }

    func testPerformanceGetAllCountries() {
        self.measure {
            for _ in 0...self.performanceTestIterations {
                self.testGetAllCountries()
            }
        }
    }
    
    func testPerformanceGetCountryDetails() {
        self.measure {
            for _ in 0...self.performanceTestIterations {
                self.testGetCountryDetails()
            }
        }
    }
}
