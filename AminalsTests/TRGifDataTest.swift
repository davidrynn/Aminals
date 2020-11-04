//
//  TRGifDataTest.swift
//  AminalsTests
//
//  Created by David Rynn on 11/3/20.
//  Copyright © 2020 David Rynn. All rights reserved.
//

import XCTest
@testable import Aminals

class TRGifDataTest: XCTestCase {

    var sut: TRResponseData!

    override func setUpWithError() throws {
        super.setUp()
        let data = try getDataFromJSON("TestTenorJson")
        let decoder = JSONDecoder()
        sut = try decoder.decode(TRResponseData.self, from: data)
        
    }

    func testData_AnimalShouldExist() throws {
        print( sut.results.first!.media.first!.gif)
        print()
    }


}
