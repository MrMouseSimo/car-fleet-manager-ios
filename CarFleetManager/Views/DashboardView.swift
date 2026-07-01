import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var viewModel: FleetViewModel

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Fleet Overview")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            Text("\(viewModel.totalCount) vehicles total")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                    }
                    .padding(.horizontal)

                    // Stats Grid
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        StatCard(
                            title: "Available",
                            count: viewModel.availableCount,
                            icon: "checkmark.circle.fill",
                            color: .green
                        )
                        StatCard(
                            title: "In Use",
                            count: viewModel.inUseCount,
                            icon: "car.fill",
                            color: .blue
                        )
                        StatCard(
                            title: "Maintenance",
                            count: viewModel.maintenanceCount,
                            icon: "wrench.and.screwdriver.fill",
                            color: .orange
                        )
                        StatCard(
                            title: "Out of Service",
                            count: viewModel.outOfServiceCount,
                            icon: "xmark.circle.fill",
                            color: .red
                        )
                    }
                    .padding(.horizontal)

                    // Fuel Level Summary
                    if !viewModel.vehicles.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Low Fuel Vehicles")
                                .font(.headline)
                                .padding(.horizontal)

                            let lowFuel = viewModel.vehicles.filter { $0.fuelLevel < 25 }
                            if lowFuel.isEmpty {
                                HStack {
                                    Image(systemName: "fuelpump.fill")
                                        .foregroundColor(.green)
                                    Text("All vehicles have adequate fuel")
                                        .foregroundColor(.secondary)
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                                .padding(.horizontal)
                            } else {
                                ForEach(lowFuel) { vehicle in
                                    HStack {
                                        Image(systemName: "fuelpump.fill")
                                            .foregroundColor(.red)
                                        VStack(alignment: .leading) {
                                            Text(vehicle.displayName)
                                                .font(.subheadline)
                                                .fontWeight(.semibold)
                                            Text("Fuel: \(vehicle.fuelLevel)%")
                                                .font(.caption)
                                                .foregroundColor(.red)
                                        }
                                        Spacer()
                                        Text(vehicle.licensePlate ?? "")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    .padding()
                                    .background(Color(.systemGray6))
                                    .cornerRadius(10)
                                    .padding(.horizontal)
                                }
                            }
                        }
                    }
                    Spacer()
                }
                .padding(.top)
            }
            .navigationTitle("Dashboard")
            .onAppear { viewModel.fetchVehicles() }
        }
    }
}

// MARK: - Stat Card
struct StatCard: View {
    let title: String
    let count: Int
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 32))
                .foregroundColor(color)
            Text("\(count)")
                .font(.system(size: 42, weight: .bold, design: .rounded))
                .foregroundColor(color)
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(16)
    }
}
