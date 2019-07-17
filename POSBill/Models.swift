//
//  Item.swift
//  POSBill
//
//  Created by Khalil Maidani on 2019-07-16.
//  Copyright © 2019 TouchBistro. All rights reserved.
//

import Foundation

public struct Item {
    public let itemId: String
    public let name: String
    public let category: String
    public let price: NSDecimalNumber
    public var isTaxExempt: Bool
    
    public init(_ name:String,_ category:String,_ price:NSDecimalNumber,_ isTaxExempt:Bool) {
        itemId = UUID().uuidString
        self.name = name
        self.category = category
        self.price = price
        self.isTaxExempt = isTaxExempt
    }
}

public struct Tax {
    public let label: String
    public let amount: NSDecimalNumber
    public let type: TaxType
    public var isEnabled: Bool
    
    public init( label: String, amount: NSDecimalNumber, isEnabled: Bool, type: TaxType){
        self.label = label
        self.amount = amount
        self.isEnabled = isEnabled
        self.type = type
    }
}

public struct Discount {
    public let id: String
    public let label: String
    public let amount: NSDecimalNumber
    public let type: DiscountType
    public var isEnabled: Bool
    
    public init( label: String, amount: NSDecimalNumber, isEnabled: Bool, type: DiscountType){
        self.label = label
        self.amount = amount
        self.isEnabled = isEnabled
        self.type = type
        id = UUID().uuidString
    }
}

public enum DiscountType {
    case amount
    case percent
}

public enum TaxType {
    case alcohol
    case federal
    case provincial
}
