//
//  Card.swift
//  SmartCards
//
//  Created by William Wang on 3/25/23.
//

import Foundation

struct smartCard: Codable, Identifiable, Hashable {
    var id = UUID()
    var question: String
    var answer: String
    var isKnown:Bool = false
}
