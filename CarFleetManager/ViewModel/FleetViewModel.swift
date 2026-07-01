import Foundation
import CoreData
import SwiftUI

class FleetViewModel: ObservableObject {
    private let viewContext: NSManagedObjectContext

    @Published var vehicles: [Vehicle] = []
    @Published var searchText: String = ""
    @Published var selectedStatusFilter: VehicleStatus? = nil

    init(context: NSManagedObjectContext) {
        self.viewContext = context
        fetchVehicles()
    }

    // MARK: - Fetch
    func fetchVehicles() {
        let request = Vehicle.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Vehicle.brand, ascending: true),
            NSSortDescriptor(keyPath: \Vehicle.model, ascending: true)
        ]
        do {
            vehicles = try viewContext.fetch(request)
        } catch {
            print("Fetch error: \(error)")
        }
    }

    // MARK: - Computed Stats
    var totalCount: Int { vehicles.count }

    var availableCount: Int {
        vehicles.filter { $0.status == VehicleStatus.available.rawValue }.count
    }

    var inUseCount: Int {
        vehicles.filter { $0.status == VehicleStatus.inUse.rawValue }.count
    }

    var maintenanceCount: Int {
        vehicles.filter { $0.status == VehicleStatus.maintenance.rawValue }.count
    }

    var outOfServiceCount: Int {
        vehicles.filter { $0.status == VehicleStatus.outOfService.rawValue }.count
    }

    var filteredVehicles: [Vehicle] {
        var result = vehicles
        if let filter = selectedStatusFilter {
            result = result.filter { $0.status == filter.rawValue }
        }
        if !searchText.isEmpty {
            result = result.filter {
                ($0.brand ?? "").localizedCaseInsensitiveContains(searchText) ||
                ($0.model ?? "").localizedCaseInsensitiveContains(searchText) ||
                ($0.licensePlate ?? "").localizedCaseInsensitiveContains(searchText) ||
                ($0.assignedTo ?? "").localizedCaseInsensitiveContains(searchText)
            }
        }
        return result
    }

    // MARK: - Add Vehicle
    func addVehicle(
        licensePlate: String,
        brand: String,
        model: String,
        year: Int,
        color: String,
        status: VehicleStatus,
        assignedTo: String,
        mileage: Int,
        fuelLevel: Int,
        notes: String
    ) {
        let vehicle = Vehicle(context: viewContext)
        vehicle.id = UUID()
        vehicle.licensePlate = licensePlate
        vehicle.brand = brand
        vehicle.model = model
        vehicle.year = Int32(year)
        vehicle.color = color
        vehicle.status = status.rawValue
        vehicle.assignedTo = assignedTo
        vehicle.mileage = Int32(mileage)
        vehicle.fuelLevel = Int32(fuelLevel)
        vehicle.notes = notes
        vehicle.createdAt = Date()
        saveContext()
    }

    // MARK: - Update Vehicle
    func updateVehicle(
        _ vehicle: Vehicle,
        licensePlate: String,
        brand: String,
        model: String,
        year: Int,
        color: String,
        status: VehicleStatus,
        assignedTo: String,
        mileage: Int,
        fuelLevel: Int,
        notes: String
    ) {
        vehicle.licensePlate = licensePlate
        vehicle.brand = brand
        vehicle.model = model
        vehicle.year = Int32(year)
        vehicle.color = color
        vehicle.status = status.rawValue
        vehicle.assignedTo = assignedTo
        vehicle.mileage = Int32(mileage)
        vehicle.fuelLevel = Int32(fuelLevel)
        vehicle.notes = notes
        saveContext()
    }

    // MARK: - Delete Vehicle
    func deleteVehicle(_ vehicle: Vehicle) {
        viewContext.delete(vehicle)
        saveContext()
    }

    func deleteVehicles(at offsets: IndexSet, from list: [Vehicle]) {
        offsets.map { list[$0] }.forEach(viewContext.delete)
        saveContext()
    }

    // MARK: - Save
    private func saveContext() {
        do {
            try viewContext.save()
            fetchVehicles()
        } catch {
            print("Save error: \(error)")
        }
    }
}
