import SwiftUI

struct AddEditVehicleView: View {
    @EnvironmentObject var viewModel: FleetViewModel
    @Environment(\.dismiss) var dismiss

    var vehicle: VehicleItem?

    @State private var licensePlate = ""
    @State private var brand = ""
    @State private var model = ""
    @State private var year = ""
    @State private var color = ""
    @State private var mileage = ""
    @State private var selectedStatus = VehicleStatus.available
    @State private var assignedDriver = ""
    @State private var notes = ""

    var isEditing: Bool { vehicle != nil }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Vehicle Info")) {
                    TextField("License Plate", text: $licensePlate)
                    TextField("Brand", text: $brand)
                    TextField("Model", text: $model)
                    TextField("Year", text: $year).keyboardType(.numberPad)
                    TextField("Color", text: $color)
                }
                Section(header: Text("Status")) {
                    Picker("Status", selection: $selectedStatus) {
                        ForEach(VehicleStatus.allCases) { status in
                            Text(status.displayName).tag(status)
                        }
                    }
                    TextField("Assigned Driver", text: $assignedDriver)
                }
                Section(header: Text("Details")) {
                    TextField("Mileage (km)", text: $mileage).keyboardType(.numberPad)
                    TextField("Notes", text: $notes)
                }
            }
            .navigationTitle(isEditing ? "Edit Vehicle" : "Add Vehicle")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveVehicle()
                        dismiss()
                    }
                    .disabled(licensePlate.isEmpty || brand.isEmpty || model.isEmpty)
                }
            }
            .onAppear { populateFields() }
        }
    }

    private func populateFields() {
        guard let v = vehicle else { return }
        licensePlate = v.licensePlate
        brand = v.brand
        model = v.model
        year = "\(v.year)"
        color = v.color
        mileage = "\(v.mileage)"
        selectedStatus = v.status
        assignedDriver = v.assignedDriver ?? ""
        notes = v.notes ?? ""
    }

    private func saveVehicle() {
        let item = VehicleItem(
            id: vehicle?.id ?? UUID(),
            licensePlate: licensePlate,
            brand: brand,
            model: model,
            year: Int(year) ?? 0,
            color: color,
            mileage: Int(mileage) ?? 0,
            status: selectedStatus,
            assignedDriver: assignedDriver.isEmpty ? nil : assignedDriver,
            notes: notes.isEmpty ? nil : notes
        )
        if isEditing {
            viewModel.updateVehicle(item)
        } else {
            viewModel.addVehicle(item)
        }
    }
}
