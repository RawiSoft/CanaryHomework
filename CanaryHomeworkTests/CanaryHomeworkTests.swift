//
//  CanaryHomeworkTests.swift
//  CanaryHomeworkTests
//
//  Created by Mustafa T. Mohammed on 6/8/21.
//  Copyright © 2021 Michael Schroeder. All rights reserved.
//

import XCTest

class CanaryHomeworkTests: XCTestCase {
    
    private var detailView : DetailView!
    private var managedContext : NSManagedObjectContext!
    override func setUpWithError() throws {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        detailView = DetailView()
        managedContext = CoreDataManager.default().managedObjectContext
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    func testFetchReadings() {
        var actualCount = 0
        let expectedCount = 6

        let expectedMaxTemperatureReading : NSNumber = 70
        var actualMaxTemperatureReading : NSNumber = 0
        let expectationForFetching = expectation(description: "fetchReadings")
        detailView.fetchReadings(forDeviceID: "2") { success, completed, readings in
            if success {
                actualCount = readings.count
                if let actualMaxTemperature = readings["MAX_TEMPERATURE"] as? NSNumber {
                    actualMaxTemperatureReading = actualMaxTemperature

                }
                expectationForFetching.fulfill()
            }
        }
        wait(for: [expectationForFetching], timeout: 5)
        XCTAssertEqual(expectedCount, actualCount, "Testing fetchReadings")
        XCTAssertEqual(expectedMaxTemperatureReading, actualMaxTemperatureReading, "Testing fetchReadings")
    }
    func testExtractReadingFromDictionary() {
        let temperatureReading = Reading(context: managedContext)
        let humidityReading = Reading(context: managedContext)
        let airQualityReading = Reading(context: managedContext)
        
        temperatureReading.type = "temperature"
        humidityReading.type = "humidity"
        airQualityReading.type = "airquality"
        
        let temperature : NSNumber = 54
        temperatureReading.value = temperature
        
        let humidity : NSNumber = 99
        humidityReading.value = humidity
        
        let airQuality : NSNumber = 100
        airQualityReading.value = airQuality
        
        let readings = [temperatureReading,humidityReading, airQualityReading]
        let actualReadingsDict = detailView.extractSensorTypeValues(from: readings) as! [String : Array<NSNumber>]
        let expectedReadingsDict = ["temperatureValues" : [temperature], "humidityValues" : [humidity], "airQualityValues" : [airQuality]]
        XCTAssertEqual(actualReadingsDict, expectedReadingsDict, "Testing extractSensorTypeValues")
    }
    
    func testGettingMinMaxAvg() {
        let expectedMin : NSNumber = 12.0
        let expectedMax : NSNumber = 50.0
        let expectedAvg : NSNumber = 32.4
        let readingsArray : [NSNumber] = [20,50,35,12,45]
        
        let actualMin = detailView.getMinValue(from: readingsArray)
        let actualMax = detailView.getMaxValue(from: readingsArray)
        let actualAvg = detailView.getAverageValue(from: readingsArray)
        
        XCTAssertEqual(expectedMin, actualMin, "Testing getMinValue")
        XCTAssertEqual(expectedMax, actualMax, "Testing getMaxValue")
        XCTAssertEqual(expectedAvg, actualAvg, "Testing getAverageValue")
        
    }
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
}
