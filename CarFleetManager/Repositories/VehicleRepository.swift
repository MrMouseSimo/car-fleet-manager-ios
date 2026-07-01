import Foundation

class VehicleRepository {
    private let storageKey = "vehicles_data"
    private let userDefaults = UserDefaults.standard

    // MARK: - Fetch
    func fetchAll() -> [VehicleItem] {
        guard let data = userDefaults.data(forKey: storageKey),
              let vehicles = try? JSONDecoder().decode([VehicleItem].self, from: data)
        else { return [] }
        return vehicles.sorted { $0.createdAt > $1.createdAt }
    }

    func fetch(by id: UUID) -> VehicleItem? {
        return fetchAll().first { $0.id == id }
    }

    func fetchByStatus(_ status: VehicleStatus) -> [VehicleItem] {
        return fetchAll().filter { $0.status == status }
    }

    // MARK: - Save
    func save(_ vehicle: VehicleItem) {
        var vehicles = fetchAll()
        vehicles.append(vehicle)
        persist(vehicles)
    }

    // MARK: - Update
    func update(_ vehicle: VehicleItem) {
        var vehicles = fetchAll()
        if let index = vehicles.firstIndex(where: { $0.id == vehicle.id }) {
            vehicles[index] = vehicle
            persist(vehicles)
        }
    }

    // MARK: - Delete
    func delete(_ vehicle: VehicleItem) {
        var vehicles = fetchAll()
        vehicles.removeAll { $0.id == vehicle.id }
        persist(vehicles)
    }

    func deleteAll() {
        userDefaults.removeObject(forKey: storageKey)
    }

    // MARK: - Private
    private func persist(_ vehicles: [VehicleItem]) {
        if let data = try? JSONEncoder().encode(vehicles) {
            userDefaults.set(data, forKey: storageKey)
        }
    }
}
