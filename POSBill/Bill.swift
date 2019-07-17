//
//  Bill.swift
//  POSBill
//
//  Created by Khalil Maidani on 2019-07-14.
//  Copyright © 2019 TouchBistro. All rights reserved.
//

import Foundation

public class Bill {
    var items : [Item]
    var discounts: [Discount]
    var taxes : [Tax]
    
    public init (_ items:Array<Item>,_ discounts:Array<Discount>,_ taxes:Array<Tax>){
        self.items = items
        self.discounts = discounts
        self.taxes = taxes
    }
    
    public func updateItems (newItems:[Item])  {
        items = newItems
    }
    
    public func setDiscounts(discounts:Array<Discount>) {
        self.discounts = discounts
    }
    
    public func setTaxes(taxes:Array<Tax>) {
        self.taxes = taxes
    }
    
    func getSubTotal() -> Decimal {
        let sum = items.reduce(0) { $0 + ($1.price as Decimal) }
        return sum
    }
    
    func getAlcoholTaxAmount() -> Decimal {
        let alcoholTaxs = taxes.filter { $0.type == .alcohol }
        guard let alcoholTax = alcoholTaxs.first else { return 0.0 }
        if alcoholTax.isEnabled {
            return alcoholTax.amount as Decimal
        }
        return 0.0
    }
    
    func getTaxsAmount() -> Decimal {
        let taxAmounts = taxes.filter { $0.type != .alcohol && $0.isEnabled == true }
        return taxAmounts.reduce(0) { $0 + ($1.amount as Decimal) }
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
        return discounts.reduce(0) { (result, discount) -> Decimal in
            if (!discount.isEnabled){
                return result
            }
            if (discount.type == .amount){
                return result + 5
            }
            return result + ((subTotal - result) * (discount.amount as Decimal))
        }
    }
    
    func gatBillTotal() -> Decimal {
        return getSubTotal() + getTaxesTotal() - getDiscountsTotal()
    }
    
    public func getBill() -> (subTotal:NSDecimalNumber,taxTotal:NSDecimalNumber,discountTotal:NSDecimalNumber,total:NSDecimalNumber){
        return (getSubTotal()   as NSDecimalNumber,
                getTaxesTotal() as NSDecimalNumber,
                getDiscountsTotal() as NSDecimalNumber,
                gatBillTotal()  as NSDecimalNumber)
    }
}
