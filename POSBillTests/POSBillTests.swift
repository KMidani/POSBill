//
//  POSBillTests.swift
//  POSBillTests
//
//  Created by Khalil Maidani on 2019-07-14.
//  Copyright © 2019 TouchBistro. All rights reserved.
//

import XCTest
@testable import POSBill

class POSBillTests: XCTestCase {
    var billCalc : Bill?
    var taxes : [Tax]?
    override func setUp() {
        
        taxes = [ Tax(label: "Tax 1 (5%)", amount: 0.05, isEnabled: true, type:.provincial),
                  Tax(label: "Tax 2 (8%)", amount: 0.08, isEnabled: true, type:.federal),
                  Tax(label: "Alcohol Tax (10%)", amount: 0.10, isEnabled: true, type:.alcohol)]
        
        billCalc = Bill([],[],taxes!)
    }
    
    override func tearDown() {
        billCalc = nil
    }
    
    func testEmptyBill() {
        XCTAssertNotNil(billCalc?.getBill())
        let bill = billCalc?.getBill()
        XCTAssertEqual(bill?.subTotal, 0)
        XCTAssertEqual(bill?.discountTotal, 0)
        XCTAssertEqual(bill?.taxTotal, 0)
        XCTAssertEqual(bill?.total, 0)
        
    }
    
    func testBillItemsAllTax(){
        let items = [
            Item("Calamari","Appetizers", 10,false),
            Item("Nachos","Appetizers", 20,false),
            Item("Burger","Mains", 5,false),
            Item("Beer","Alcohol", 5,false)
        ]
        billCalc?.updateItems(newItems: items)
        let bill = billCalc?.getBill()
        XCTAssertEqual(bill?.subTotal, 40)
        XCTAssertEqual(bill?.discountTotal, 0)
        XCTAssertEqual(bill?.taxTotal, 5.7)
        XCTAssertEqual(bill?.total, 45.7)
    }
    
    func testBillALLItemsisTaxExempt(){
        let items = [
            Item("Calamari","Appetizers", 10,true),
            Item("Nachos","Appetizers", 20,true),
            Item("Burger","Mains", 5,true),
            Item("Beer","Alcohol", 5,true)
        ]
        billCalc?.updateItems(newItems: items)
        let bill = billCalc?.getBill()
        XCTAssertEqual(bill?.subTotal, 40)
        XCTAssertEqual(bill?.discountTotal, 0)
        XCTAssertEqual(bill?.taxTotal, 0.5)
        XCTAssertEqual(bill?.total, 40.5)
    }
    
    func testBillItemsNOSalesTax(){
        let items = [
            Item("Calamari","Appetizers", 10,false),
            Item("Nachos","Appetizers", 20,false),
            Item("Burger","Mains", 5,false),
            Item("Beer","Alcohol", 5,false)
        ]
        taxes = [ Tax(label: "Tax 1 (5%)", amount: 0.05, isEnabled: false, type:.provincial),
                  Tax(label: "Tax 2 (8%)", amount: 0.08, isEnabled: false, type:.federal),
                  Tax(label: "Alcohol Tax (10%)", amount: 0.10, isEnabled: true, type:.alcohol)]
        
        billCalc?.setTaxes(taxes: taxes!)
        billCalc?.updateItems(newItems: items)
        let bill = billCalc?.getBill()
        XCTAssertEqual(bill?.subTotal, 40)
        XCTAssertEqual(bill?.discountTotal, 0)
        XCTAssertEqual(bill?.taxTotal, 0.5)
        XCTAssertEqual(bill?.total, 40.5)
    }
    
    func testBillItemsNOAlcoholTax(){
        let items = [
            Item("Beer","Alcohol", 5,false)
        ]
        taxes = [ Tax(label: "Tax 1 (5%)", amount: 0.05, isEnabled: true, type:.provincial),
                  Tax(label: "Tax 2 (8%)", amount: 0.08, isEnabled: true, type:.federal),
                  Tax(label: "Alcohol Tax (10%)", amount: 0.10, isEnabled: false, type:.alcohol)]
        
        billCalc?.setTaxes(taxes: taxes!)
        billCalc?.updateItems(newItems: items)
        let bill = billCalc?.getBill()
        XCTAssertEqual(bill?.subTotal, 5)
        XCTAssertEqual(bill?.discountTotal, 0)
        XCTAssertEqual(bill?.taxTotal, 0.65)
        XCTAssertEqual(bill?.total, 5.65)
    }
    
    func testBillItemsDiscountsOrdered(){
        let items = [
            Item("Calamari","Appetizers", 10,false),
            Item("Nachos","Appetizers", 20,false),
            Item("Burger","Mains", 5,false),
            Item("Beer","Alcohol", 5,false)
        ]
        billCalc?.updateItems(newItems: items)

        
        var discounts = [
            Discount(label: "$5.00", amount: 5.00, isEnabled: true , type:.amount),
            Discount(label: "10%", amount: 0.10, isEnabled: false , type:.percent),
            Discount(label: "20%", amount: 0.20, isEnabled: false , type:.percent),
        ]
        
        billCalc?.setDiscounts(discounts: discounts)
        var bill = billCalc?.getBill()
        XCTAssertEqual(bill?.subTotal, 40)
        XCTAssertEqual(bill?.discountTotal, 5)
        XCTAssertEqual(bill?.taxTotal, 5.7)
        XCTAssertEqual(bill?.total, 40.7)
        
        discounts = [
            Discount(label: "10%", amount: 0.10, isEnabled: false , type:.percent),
            Discount(label: "$5.00", amount: 5.00, isEnabled: true , type:.amount),
            Discount(label: "20%", amount: 0.20, isEnabled: false , type:.percent),
        ]
        
        billCalc?.setDiscounts(discounts: discounts)
        bill = billCalc?.getBill()
        XCTAssertEqual(bill?.subTotal, 40)
        XCTAssertEqual(bill?.discountTotal, 5)
        XCTAssertEqual(bill?.taxTotal, 5.7)
        XCTAssertEqual(bill?.total, 40.7)
        
        discounts = [
            Discount(label: "20%", amount: 0.20, isEnabled: true , type:.percent),
            Discount(label: "10%", amount: 0.10, isEnabled: false , type:.percent),
            Discount(label: "$5.00", amount: 5.00, isEnabled: false , type:.amount),
        ]
        
        billCalc?.setDiscounts(discounts: discounts)
        bill = billCalc?.getBill()
        XCTAssertEqual(bill?.subTotal, 40)
        XCTAssertEqual(bill?.discountTotal, 8)
        XCTAssertEqual(bill?.taxTotal, 5.7)
        XCTAssertEqual(bill?.total, 37.7)
        
        discounts = [
            Discount(label: "20%", amount: 0.20, isEnabled: false , type:.percent),
            Discount(label: "$5.00", amount: 5.00, isEnabled: true , type:.amount),
            Discount(label: "10%", amount: 0.10, isEnabled: true , type:.percent),
        ]
        
        billCalc?.setDiscounts(discounts: discounts)
        bill = billCalc?.getBill()
        XCTAssertEqual(bill?.subTotal, 40)
        XCTAssertEqual(bill?.discountTotal, 8.5)
        XCTAssertEqual(bill?.taxTotal, 5.7)
        XCTAssertEqual(bill?.total, 37.2)
    }
    
    func testBillItemsDiscountsAllEnabeld(){
        let items = [
            Item("Calamari","Appetizers", 10,false),
            Item("Nachos","Appetizers", 20,false),
            Item("Burger","Mains", 5,false),
            Item("Beer","Alcohol", 5,false)
        ]
        billCalc?.updateItems(newItems: items)
        
        
        var discounts = [
            Discount(label: "$5.00", amount: 5.00, isEnabled: true , type:.amount),
            Discount(label: "10%", amount: 0.10, isEnabled: true , type:.percent),
            Discount(label: "20%", amount: 0.20, isEnabled: true , type:.percent),
        ]
        
        billCalc?.setDiscounts(discounts: discounts)
        var bill = billCalc?.getBill()
        XCTAssertEqual(bill?.subTotal, 40)
        XCTAssertEqual(bill?.discountTotal, 14.8)
        XCTAssertEqual(bill?.taxTotal, 5.7)
        XCTAssertEqual(bill?.total, 30.9)
        
        discounts = [
            Discount(label: "10%", amount: 0.10, isEnabled: true , type:.percent),
            Discount(label: "$5.00", amount: 5.00, isEnabled: true , type:.amount),
            Discount(label: "20%", amount: 0.20, isEnabled: true , type:.percent),
        ]
        
        billCalc?.setDiscounts(discounts: discounts)
        bill = billCalc?.getBill()
        XCTAssertEqual(bill?.subTotal, 40)
        XCTAssertEqual(bill?.discountTotal, 15.2)
        XCTAssertEqual(bill?.taxTotal, 5.7)
        XCTAssertEqual(bill?.total, 30.5)
        
        discounts = [
            Discount(label: "20%", amount: 0.20, isEnabled: true , type:.percent),
            Discount(label: "10%", amount: 0.10, isEnabled: true , type:.percent),
            Discount(label: "$5.00", amount: 5.00, isEnabled: true , type:.amount),
        ]
        
        billCalc?.setDiscounts(discounts: discounts)
        bill = billCalc?.getBill()
        XCTAssertEqual(bill?.subTotal, 40)
        XCTAssertEqual(bill?.discountTotal, 16.2)
        XCTAssertEqual(bill?.taxTotal, 5.7)
        XCTAssertEqual(bill?.total, 29.5)
        
        discounts = [
            Discount(label: "20%", amount: 0.20, isEnabled: true , type:.percent),
            Discount(label: "$5.00", amount: 5.00, isEnabled: true , type:.amount),
            Discount(label: "10%", amount: 0.10, isEnabled: true , type:.percent),
        ]
        
        billCalc?.setDiscounts(discounts: discounts)
        bill = billCalc?.getBill()
        XCTAssertEqual(bill?.subTotal, 40)
        XCTAssertEqual(bill?.discountTotal, 15.7)
        XCTAssertEqual(bill?.taxTotal, 5.7)
        XCTAssertEqual(bill?.total, 30)
    }
}
