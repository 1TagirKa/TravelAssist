//
//  ExchangeRates.swift
//  TravelAssist
//
//  Created by Илья on 06.07.2021.
//

import Foundation

struct ExchangeRates: Codable {
    let conversion_rates: [String: Double]
}
