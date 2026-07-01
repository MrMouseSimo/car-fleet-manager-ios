# Car Fleet Manager iOS

A native iOS app for managing a vehicle fleet, built with **Swift**, **SwiftUI**, and **UserDefaults** for local storage.

## Features

- **Dashboard**: Overview of fleet statistics (total, available, in-use, maintenance, out-of-service)
- **Vehicle List**: Browse all vehicles with search and filter by status
- **Add/Edit Vehicle**: Full form to create or update vehicle records
- **Vehicle Cards**: Visual cards showing brand, model, license plate, year, mileage, and assigned driver
- **Status Management**: Track vehicle status (Available, In Use, Maintenance, Out of Service)
- **Local Persistence**: All data stored locally using UserDefaults (JSON encoding)
- **Swipe to Delete**: Remove vehicles directly from the list

## Tech Stack

| Layer | Technology |
|-------|------------|
| Language | Swift 5.9+ |
| UI Framework | SwiftUI |
| Architecture | MVVM |
| Persistence | UserDefaults (JSON) |
| Min iOS | iOS 16.0+ |

## Project Structure

```
CarFleetManager/
+-- CarFleetManagerApp.swift       # App entry point
+-- Models/
|   +-- VehicleItem.swift          # Vehicle model + VehicleStatus enum
+-- ViewModels/
|   +-- FleetViewModel.swift       # ObservableObject ViewModel
+-- Repositories/
|   +-- VehicleRepository.swift    # Data layer (UserDefaults)
+-- Views/
    +-- ContentView.swift          # Root TabView navigation
    +-- DashboardView.swift        # Fleet statistics dashboard
    +-- VehicleListView.swift      # Searchable vehicle list
    +-- VehicleCardView.swift      # Vehicle card component + StatusBadge
    +-- AddEditVehicleView.swift   # Add/Edit vehicle form
```

## Architecture

The app follows **MVVM** (Model-View-ViewModel):

- **Model** (`VehicleItem`, `VehicleStatus`) - pure Swift structs/enums
- **Repository** (`VehicleRepository`) - handles JSON encoding/decoding to UserDefaults
- **ViewModel** (`FleetViewModel: ObservableObject`) - business logic, `@Published` state
- **Views** (SwiftUI) - reactive UI bound to the ViewModel via `@EnvironmentObject`

## Getting Started

1. Clone the repository
2. Open `CarFleetManager.xcodeproj` in Xcode 15+
3. Select your simulator or device (iOS 16+)
4. Press **Run** (Cmd+R)

## Vehicle Statuses

| Status | Color | Description |
|--------|-------|-------------|
| Available | Green | Ready for assignment |
| In Use | Blue | Currently assigned to a driver |
| Maintenance | Orange | Under repair or service |
| Out of Service | Red | Not operational |

## Author

MrMouseSimo
