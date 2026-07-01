import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "CarFleetManager")

        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved Core Data error: \(error), \(error.userInfo)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
    }

    // MARK: - Preview Helper
    static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        let context = controller.container.viewContext

        let sample = Vehicle(context: context)
        sample.id = UUID()
        sample.licensePlate = "ABC-123"
        sample.brand = "Toyota"
        sample.model = "Corolla"
        sample.year = 2022
        sample.color = "White"
        sample.status = "AVAILABLE"
        sample.assignedTo = ""
        sample.mileage = 15000
        sample.fuelLevel = 80
        sample.notes = "Good condition"

        do {
            try context.save()
        } catch {
            fatalError("Preview save error: \(error)")
        }
        return controller
    }()
}
