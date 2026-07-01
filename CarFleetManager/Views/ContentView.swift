import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel: FleetViewModel

    init() {
        _viewModel = StateObject(wrappedValue: FleetViewModel(
            context: PersistenceController.shared.container.viewContext
        ))
    }

    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "chart.bar.fill")
                }

            VehicleListView()
                .tabItem {
                    Label("Vehicles", systemImage: "car.2.fill")
                }
        }
        .environmentObject(viewModel)
    }
}

#Preview {
    ContentView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
