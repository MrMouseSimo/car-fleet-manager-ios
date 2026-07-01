import Foundation
import CoreData

@objc(Vehicle)
public class Vehicle: NSManagedObject {}

extension Vehicle {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Vehicle> {
        return NSFetchRequest<Vehicle>(entityName: "Vehicle")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var licensePlate: String?
    @NSManaged public var brand: String?
    @NSManaged public var model: String?
    @NSManaged public var year: Int32
    @NSManaged public var color: String?
    @NSManaged public var status: String?
    @NSManaged public var assignedTo: String?
    @NSManaged public var mileage: Int32
    @NSManaged public var fuelLevel: Int32
    @NSManaged public var lastMaintenanceDate: Date?
    @NSManaged public var notes: String?
    @NSManaged public var createdAt: Date?
}

extension Vehicle: Identifiable {}

// MARK: - VehicleStatus enum
enum VehicleStatus: String, CaseIterable, Identifiable {
    case available = "AVAILABLE"
    case inUse = "IN_USE"
    case maintenance = "MAINTENANCE"
    case outOfService = "OUT_OF_SERVICE"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .available: return "Available"
        case .inUse: return "In Use"
        case .maintenance: return "Maintenance"
        case .outOfService: return "Out of Service"
        }
    }

    var color: String {
        switch self {
        case .available: return "StatusGreen"
        case .inUse: return "StatusBlue"
        case .maintenance: return "StatusOrange"
        case .outOfService: return "StatusRed"
        }
    }

    var sfSymbol: String {
        switch self {
        case .available: return "checkmark.circle.fill"
        case .inUse: return "car.fill"
        case .maintenance: return "wrench.and.screwdriver.fill"
        case .outOfService: return "xmark.circle.fill"
        }
    }
}

// MARK: - Convenience extensions
extension Vehicle {
    var vehicleStatus: VehicleStatus {
        get { VehicleStatus(rawValue: status ?? "AVAILABLE") ?? .available }
        set { status = newValue.rawValue }
    }

    var displayName: String {
        "\(brand ?? "") \(model ?? "") \(year)"
    }
}
