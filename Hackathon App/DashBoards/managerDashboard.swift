
import SwiftUI

struct ManagersDashboard: View {
    @StateObject private var vm = DashboardVM()
        
        var body: some View {
            TabView(selection: $vm.selectedTab) {
                ProjectsView()
                    .tabItem {
                        Label("Projects", systemImage: "square.grid.3x1.folder.fill.badge.plus")
                            .environment(\.symbolVariants, .none)
                    }
                    .tag(0)
                
                PartnersView()
                    .tabItem {
                        Label("Partners", systemImage: "person.2.fill")
                            .environment(\.symbolVariants, .none)
                    }
                    .tag(1)
                
                StudentTaskDashboardView()
                    .tabItem {
                        Label("My Tasks", systemImage: "clock.fill")
                            .environment(\.symbolVariants, .none)
                    }
                    .tag(2)
                
                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                            .environment(\.symbolVariants, .none)
                    }
                    .tag(3)
            }
            .tint(.orange)
        }
    }

#Preview {
    ManagersDashboard()
}
