import SwiftUI

struct VehicleListView: View {
    @EnvironmentObject var viewModel: FleetViewModel
    @State private var showingAddVehicle = false
    @State private var searchText = ""

    var filteredVehicles: [VehicleItem] {
        if searchText.isEmpty {
            return viewModel.vehicles
        } else {
            return viewModel.vehicles.filter {
                $0.licensePlate.localizedCaseInsensitiveContains(searchText) ||
                $0.brand.localizedCaseInsensitiveContains(searchText) ||
                $0.model.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(filteredVehicles) { vehicle in
                    NavigationLink(destination: AddEditVehicleView(vehicle: vehicle)) {
                        VehicleCardView(vehicle: vehicle)
                    }
                }
                .onDelete(perform: viewModel.deleteVehicle)
            }
            .searchable(text: $searchText, prompt: "Search vehicles")
            .navigationTitle("Fleet")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddVehicle = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddVehicle) {
                AddEditVehicleView(vehicle: nil)
                    .environmentObject(viewModel)
            }
        }
    }
}
