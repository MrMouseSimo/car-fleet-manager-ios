import SwiftUI

struct VehicleCardView: View {
    let vehicle: VehicleItem

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("\(vehicle.brand) \(vehicle.model)")
                    .font(.headline)
                Spacer()
                StatusBadge(status: vehicle.status)
            }
            Text(vehicle.licensePlate)
                .font(.subheadline)
                .foregroundColor(.secondary)
            HStack {
                Label("\(vehicle.year)", systemImage: "calendar")
                Spacer()
                Label("\(vehicle.mileage) km", systemImage: "speedometer")
            }
            .font(.caption)
            .foregroundColor(.secondary)
            if let driver = vehicle.assignedDriver {
                Label(driver, systemImage: "person")
                    .font(.caption)
                    .foregroundColor(.blue)
            }
        }
        .padding(.vertical, 4)
    }
}

struct StatusBadge: View {
    let status: VehicleStatus

    var body: some View {
        Text(status.displayName)
            .font(.caption)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(status.color.opacity(0.2))
            .foregroundColor(status.color)
            .cornerRadius(8)
    }
}

extension VehicleStatus {
    var color: Color {
        switch self {
        case .available: return .green
        case .inUse: return .blue
        case .maintenance: return .orange
        case .outOfService: return .red
        }
    }

    var displayName: String {
        switch self {
        case .available: return "Available"
        case .inUse: return "In Use"
        case .maintenance: return "Maintenance"
        case .outOfService: return "Out of Service"
        }
    }
}
