//
//  HomeServiceProtocol.swift
//  AutoMate
//
//  Created by oto rurua on 14.01.26.
//

import Foundation

protocol HomeServiceProtocol: Sendable {
    func fetchOffers() async throws -> [Offer]
    func fetchCategories() async throws -> [Category]
}
