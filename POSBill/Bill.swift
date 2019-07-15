//
//  Bill.swift
//  POSBill
//
//  Created by Khalil Maidani on 2019-07-14.
//  Copyright © 2019 TouchBistro. All rights reserved.
//

import Foundation
public typealias Item = (name: String, category: String, price: NSDecimalNumber, isTaxExempt: Bool)
public typealias Tax = (label: String, amount: NSDecimalNumber, isEnabled: Bool, type: String)
public typealias Discount = (label: String, amount: NSDecimalNumber, isEnabled: Bool, type: String)

public class Bill {
    var items : [Item] = []
    var discounts: Array<Discount>?
    var taxes : Array<Tax>?
    
    public init (_ applyedDiscounts:Array<Discount>,_ applyedTaxes:Array<Tax>){
        discounts = applyedDiscounts
        taxes = applyedTaxes
    }
    
    public func updateItems (newItems:[Item])  {
        items = newItems
    }
    
    public func setDiscounts(applyedDiscounts:Array<Discount>) {
        discounts = applyedDiscounts
    }
    
    public func setTaxes(applyedTaxes:Array<Tax>) {
        taxes = applyedTaxes
    }
    
    func getSubTotal() -> Decimal {
        let sum = items.reduce(0) { $0 + ($1.price as Decimal) }
        return sum
    }
    
    func getAlcoholTaxAmount() -> Decimal {
        let alcoholTaxs = taxes?.filter { $0.type == "alcohol" }
        guard let alcoholTax = alcoholTaxs?.first else { return 0.0 }
        if alcoholTax.isEnabled {
            return alcoholTax.amount as Decimal
        }
        return 0.0
    }
    
    func getTaxsAmount() -> Decimal {
        let taxAmounts = taxes?.filter { $0.type != "alcohol" && $0.isEnabled == true }
        return taxAmounts?.reduce(0) { $0 + ($1.amount as Decimal) } ?? 0.0
    }
    
    func getAlcoholTax() -> Decimal {
        let itemInAlcoholCategory = items.filter { $0.category == "Alcohol" }
        let subTotalAlcoholItems = itemInAlcoholCategory.reduce(0) { $0 + ($1.price as Decimal) }
        return subTotalAlcoholItems * getAlcoholTaxAmount()
    }
    
    func getTaxesTotal() -> Decimal {
        let itemWithTax = items.filter { $0.isTaxExempt == false }
        let subTotalForTaxes = itemWithTax.reduce(0) { $0 + ($1.price as Decimal) }
        let otherTax = subTotalForTaxes * getTaxsAmount()
        let alcoholTax = getAlcoholTax()
        return alcoholTax + otherTax
    }
    
    
    
    func getDiscountsTotal() -> Decimal {
        let subTotal = getSubTotal()
        let percentDiscounts = discounts?.filter { $0.type == "percent"  && $0.isEnabled == true }
        let discountPercent = percentDiscounts?.reduce(0) { $0 + ($1.amount as Decimal) } ?? 0.0
        
        let amountDiscounts = discounts?.filter { $0.type == "amount"  && $0.isEnabled == true }
        let discountAmount = amountDiscounts?.reduce(0) { $0 + ($1.amount as Decimal) } ?? 0.0
        
        let percentDiscountAmount = subTotal * discountPercent
        
        if (subTotal >= discountAmount) {
            return percentDiscountAmount + discountAmount
        }
        return percentDiscountAmount
    }
    
    func gatBillTotal() -> Decimal {
        return getSubTotal() + getTaxesTotal() - getDiscountsTotal()
    }
    
    public func getBillInfo() -> (subTotal:NSDecimalNumber,taxTotal:NSDecimalNumber,discountTotal:NSDecimalNumber,total:NSDecimalNumber){
        return (getSubTotal()   as NSDecimalNumber,
                getTaxesTotal() as NSDecimalNumber,
                getDiscountsTotal() as NSDecimalNumber,
                gatBillTotal()  as NSDecimalNumber)
    }
}
