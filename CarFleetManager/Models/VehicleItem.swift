import Foundation
import SwiftUI

// MARK: - VehicleStatus Enum
enum VehicleStatus: String, CaseIterable, Identifiable, Codable {
    case available = "available"
    case inUse = "in_use"
    case maintenance = "maintenance"
    case outOfService = "out_of_service"

    var id: String { rawValue }
}

// MARK: - VehicleItem Model
struct VehicleItem: Identifiable, Codable, Equatable {
    var id: UUID
    var licensePlate: String
    var brand: String
    var model: String
    var year: Int
    var color: String
    var mileage: Int
    var status: VehicleStatus
    var assignedDriver: String?
    var notes: String?
    var lastMaintenanceDate: Date?
    var createdAt: Date

    init(
        id: UUID = UUID(),
        licensePlate: String,
        brand: String,
        model: String,
        year: Int,
        color: String,
        mileage: Int = 0,
        status: VehicleStatus = .available,
        assignedDriver: String? = nil,
        notes: String? = nil,
        lastMaintenanceDate: Date? = nil,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.licensePlate = licensePlate
        self.brand = brand
        self.model = model
        self.year = year
        self.color = color
        self.mileage = mileage
        self.status = status
        self.assignedDriver = assignedDriver
        self.notes = notes
        self.lastMaintenanceDate = lastMaintenanceDate
        self.createdAt = createdAt
    }

    // Sample data for previews
    static var sampleVehicles: [VehicleItem] = [
        VehicleItem(licensePlate: "ABC-123", brand: "Toyota", model: "Camry", year: 2022, color: "White", mileage: 15000, status: .available),
        VehicleItem(licensePlate: "XYZ-456", brand: "Ford", model: "F-150", year: 2021, color: "Black", mileage: 32000, status: .inUse, assignedDriver: "John Doe"),
        VehicleItem(licensePlate: "DEF-789", brand: "Honda", model: "Civic", year: 2020, color: "Silver", mileage: 48000, status: .maintenance),
        VehicleItem(licensePlate: "GHI-012", brand: "Chevrolet", model: "Silverado", year: 2019, color: "Red", mileage: 72000, status: .outOfService)
    ]
}
