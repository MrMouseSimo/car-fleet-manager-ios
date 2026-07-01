import Foundation
import Combine

class FleetViewModel: ObservableObject {
    @Published var vehicles: [VehicleItem] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let repository: VehicleRepository
    private var cancellables = Set<AnyCancellable>()

    init(repository: VehicleRepository = VehicleRepository()) {
        self.repository = repository
        loadVehicles()
    }

    // MARK: - Computed Properties
    var totalVehicles: Int { vehicles.count }
    var availableCount: Int { vehicles.filter { $0.status == .available }.count }
    var inUseCount: Int { vehicles.filter { $0.status == .inUse }.count }
    var maintenanceCount: Int { vehicles.filter { $0.status == .maintenance }.count }
    var outOfServiceCount: Int { vehicles.filter { $0.status == .outOfService }.count }

    // MARK: - CRUD Operations
    func loadVehicles() {
        isLoading = true
        vehicles = repository.fetchAll()
        isLoading = false
    }

    func addVehicle(_ vehicle: VehicleItem) {
        repository.save(vehicle)
        loadVehicles()
    }

    func updateVehicle(_ vehicle: VehicleItem) {
        repository.update(vehicle)
        loadVehicles()
    }

    func deleteVehicle(at offsets: IndexSet) {
        offsets.forEach { index in
            let vehicle = vehicles[index]
            repository.delete(vehicle)
        }
        loadVehicles()
    }

    func deleteVehicle(_ vehicle: VehicleItem) {
        repository.delete(vehicle)
        loadVehicles()
    }

    func updateStatus(_ vehicle: VehicleItem, status: VehicleStatus) {
        var updated = vehicle
        updated.status = status
        repository.update(updated)
        loadVehicles()
    }

    // MARK: - Statistics
    func vehiclesByStatus() -> [(VehicleStatus, Int)] {
        return VehicleStatus.allCases.map { status in
            (status, vehicles.filter { $0.status == status }.count)
        }
    }

    func averageMileage() -> Double {
        guard !vehicles.isEmpty else { return 0 }
        return Double(vehicles.reduce(0) { $0 + $1.mileage }) / Double(vehicles.count)
    }
}
