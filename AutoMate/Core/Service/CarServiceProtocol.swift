//
//  CarServiceProtocol.swift
//  AutoMate
//
//  Created by oto rurua on 14.01.26.
//

import Foundation

// ეს პროტოკოლი განსაზღვრავს, რა უნდა შეეძლოს სერვისს
protocol CarServiceProtocol {
    func fetchMyCars() async throws -> [Car]
    func fetchServiceHistory(for carId: String) async throws -> [ServiceItem]
    func addCar(_ car: Car) async throws
    func deleteCar(id: String) async throws
}
