//
//  POSTests.swift
//  POSTests
//
//  Created by Tayson Nguyen on 2019-04-23.
//  Copyright © 2019 TouchBistro. All rights reserved.
//

import XCTest
@testable import POS

class POSTests: XCTestCase {

    func testTaxViewModel() {
        let viewModel = TaxViewModel()
        
        XCTAssertNotNil(viewModel.title(for: 0))
        XCTAssertEqual(viewModel.numberOfSections(), 1)
        XCTAssertEqual(viewModel.numberOfRows(in: 2), taxes.count)
        let idx = IndexPath(row: 0, section: 0)
        XCTAssertEqual(viewModel.labelForTax(at:idx),taxes[idx.row].label)
        XCTAssertEqual(viewModel.accessoryType(at:idx),.checkmark)
        viewModel.toggleTax(at:idx)
        XCTAssertEqual(viewModel.accessoryType(at:idx),.none)
    }

}
