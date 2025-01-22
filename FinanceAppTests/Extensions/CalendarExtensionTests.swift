//
//  DateExtensionTests.swift
//  FinanceAppTests
//
//  Created by Данила Бондарь on 17.01.2025.
//

import XCTest
@testable import FinanceApp

final class CalendarExtensionTests: XCTestCase {

    
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        try super.setUpWithError()
    }

    override class func tearDown() {
        super.tearDown()
    }
    
    func weekTest(date: Date){
        
        let weeks = Calendar.current.weekInMonth(of: date)
        
        XCTAssertNotNil(weeks)
        XCTAssertEqual(weeks!.count, 5)
        
        XCTAssertEqual(weeks![0].start.timeIntervalSince1970, 1_735_506_000)
        XCTAssertEqual(weeks![0].end.timeIntervalSince1970, 1_736_110_800)
        
        XCTAssertEqual(weeks![1].start.timeIntervalSince1970, 1_736_110_800)
        XCTAssertEqual(weeks![1].end.timeIntervalSince1970, 1_736_715_600)
        
        XCTAssertEqual(weeks![2].start.timeIntervalSince1970, 1_736_715_600)
        XCTAssertEqual(weeks![2].end.timeIntervalSince1970, 1_737_320_400)
        
        XCTAssertEqual(weeks![3].start.timeIntervalSince1970, 1_737_320_400)
        XCTAssertEqual(weeks![3].end.timeIntervalSince1970, 1_737_925_200)
        
        XCTAssertEqual(weeks![4].start.timeIntervalSince1970, 1_737_925_200)
        XCTAssertEqual(weeks![4].end.timeIntervalSince1970, 1_738_530_000)
        
        
    }
    
    func testWeekGeneration() {
        var date = Date(timeIntervalSince1970: 1_735_678_800)
        weekTest(date: date)
        
        date = Date(timeIntervalSince1970: 1_736_888_400)
        weekTest(date: date)
        
        date = Date(timeIntervalSince1970: 1_738_270_800)
        weekTest(date: date)
    }
    
}
