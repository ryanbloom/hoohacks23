//
//  Recipet.swift
//  FinanceApp
//
//  Created by William Wang on 3/25/23.
//

import Foundation

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)


// MARK: - Welcome
struct Welcome: Codable {
    var extras: Extras?
    var finishedAt: Date?
    var isRotationApplied: Bool?
    var pages: [Page]?
    var prediction: WelcomePrediction?
    var processingTime: Double?
    var product: Product?
    var startedAt: Date?
}

// MARK: - Extras
struct Extras:Codable {
}

// MARK: - Page
struct Page:Codable {
    var extras: Extras?
    var id: Int?
    var orientation: PageOrientation?
    var prediction: PagePrediction?
}

// MARK: - PageOrientation
struct PageOrientation:Codable {
    var value: Int?
}

// MARK: - PagePrediction
struct PagePrediction :Codable{
    var category: Category?
    var date: DateClass?
    var locale: Locale?
    var orientation: PredictionOrientation?
    var supplier: DateClass?
    var taxes: [Tax]?
    var time: DateClass?
    var tip, totalAmount, totalNet, totalTax: Tip?
}

// MARK: - Category
struct Category :Codable{
    var confidence: Double?
    var value: String?
}

// MARK: - DateClass
struct DateClass:Codable {
    var confidence: Double?
    var polygon: [[Double]]?
    var value: String?
    var pageID: Int?
}

// MARK: - Locale
struct Locale:Codable {
    var confidence: Double?
    var country, currency, language, value: String?
}

// MARK: - PredictionOrientation
struct PredictionOrientation:Codable {
    var confidence: Double?
    var degrees: Int?
}

// MARK: - Tax
struct Tax:Codable {
    var basis: String?
    var code: String?
    var confidence: Double?
    var polygon: [[Double]]?
    var rate: String?
    var value: Double?
    var pageID: Int?
}

// MARK: - Tip
struct Tip:Codable {
    var confidence: Double?
    var polygon: [[Double]]?
    var value: Double?
    var pageID: Int?
}

// MARK: - WelcomePrediction
struct WelcomePrediction:Codable {
    var category: Category?
    var date: DateClass?
    var locale: Locale?
    var supplier: DateClass?
    var taxes: [Tax]?
    var time: DateClass?
    var tip, totalAmount, totalNet, totalTax: Tip?
}

// MARK: - Product
struct Product:Codable {
    var features: [String]?
    var name, type, version: String?
}
