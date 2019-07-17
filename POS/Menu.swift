//
//  Menu.swift
//  POS
//
//  Created by Tayson Nguyen on 2019-04-23.
//  Copyright © 2019 TouchBistro. All rights reserved.
//

import Foundation
import POSBill

func category(_ category: String) -> (String, NSDecimalNumber) -> Item {
    return { name, price in
        return Item(name, category, price, false)
    }
}

let appetizers = category("Appetizers")
let mains = category("Mains")
let drinks = category("Drinks")
let alcohol = category("Alcohol")

let appetizersCategory = [
    appetizers("Nachos", 13.99),
    appetizers("Calamari", 11.99),
    appetizers("Caesar Salad", 10.99),
]

let mainsCategory = [
    mains("Burger", 9.99),
    mains("Hotdog", 3.99),
    mains("Pizza", 12.99),
]

let drinksCategory = [
    drinks("Water", 0),
    drinks("Pop", 2.00),
    drinks("Orange Juice", 3.00),
]

let alcoholCategory = [
    alcohol("Beer", 5.00),
    alcohol("Cider", 6.00),
    alcohol("Wine", 7.00),
]

let tax1 = Tax(label: "Tax 1 (5%)", amount: 0.05, isEnabled: true, type:.provincial)
let tax2 = Tax(label: "Tax 2 (8%)", amount: 0.08, isEnabled: true, type:.federal)
let alcoholTax = Tax(label: "Alcohol Tax (10%)", amount: 0.10, isEnabled: true, type:.alcohol)

let discount5Dollars = Discount(label: "$5.00", amount: 5.00, isEnabled: false , type:.amount)
let discount10Percent = Discount(label: "10%", amount: 0.10, isEnabled: false , type:.percent)
let discount20Percent = Discount(label: "20%", amount: 0.20, isEnabled: false , type:.percent)

var taxes = [
    tax1,
    tax2,
    alcoholTax,
]

var discounts = [
    discount5Dollars,
    discount10Percent,
    discount20Percent,
]

var selectedDiscount : [Discount] = []

var categories = [
    (name: "Appetizers", items: appetizersCategory),
    (name: "Mains", items: mainsCategory),
    (name: "Drinks", items: drinksCategory),
    (name: "Alcohol", items: alcoholCategory),
]
