//
//  Bill.swift
//  POSBill
//
//  Created by Khalil Maidani on 2019-07-14.
//  Copyright © 2019 TouchBistro. All rights reserved.
//

import Foundation

/// Bill is struct to represnt the POS bill, and it depending on three inputs.
///
/// Iputs
/// list ot Items,
/// list ot Discount (and this should be Ordered),
/// list ot Tax
/// example to creat Bill:
///
///     let items = [Item]
///     let discounts = [Discount]
///     let taxs = [Tax]
///     let bill = Bill(items,discounts,taxes)
///     let billResults = bill.getBill()
///
/// the getBill() function return a tupple with the calculated bill
/// subtotal, discount ,tax , Total
///
public struct Bill {
    var items : [Item]
    var discounts: [Discount]
    var taxes : [Tax]
    
    /// the bill constractor
    /// - Parameters:
    ///   - items: List of Items
    ///   - discounts: List of discounts element to apply on the bill,
    ///     this list should be ordered in the sequense of the discounts applied
    ///   - taxes: List of taxes element to apply on the bill,
    public init (_ items:Array<Item>,_ discounts:Array<Discount>,_ taxes:Array<Tax>){
        self.items = items
        self.discounts = discounts
        self.taxes = taxes
    }
    
    /// update the Items list in the bill
    /// - Parameters:
    ///   - items: List of Items
    public mutating func updateItems (newItems:[Item])  {
        items = newItems
    }
    
    /// set the Discount list in the bill
    /// the Discount list should be ordered
    /// - Parameters:
    ///   - discounts: List of Discount
    public mutating func setDiscounts(discounts:Array<Discount>) {
        self.discounts = discounts
    }
    
    /// set the Tax list in the bill
    /// - Parameters:
    ///   - taxes: List of Tax
    public mutating func setTaxes(taxes:Array<Tax>) {
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
    
    
    /// update the Items list in the bill
    /// - Returns:
    ///   bill: a tupple of calculated bill results
    /// (subTotal: NSDecimalNumber,
    ///  taxTotal: NSDecimalNumber,
    ///  discountTotal: NSDecimalNumber,
    ///  total:NSDecimalNumber)
    public func getBill() -> (subTotal: NSDecimalNumber,
        taxTotal: NSDecimalNumber,
        discountTotal: NSDecimalNumber,
        total: NSDecimalNumber){
            return (getSubTotal()   as NSDecimalNumber,
                    getTaxesTotal() as NSDecimalNumber,
                    getDiscountsTotal() as NSDecimalNumber,
                    gatBillTotal()  as NSDecimalNumber)
    }
}
