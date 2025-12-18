//
//  SettingsView.swift
//  Hackathon
//
//  Created by Ian. T. Dzingira on 11/12/2025.
//
import SwiftUI

struct SettingsView: View {

    @AppStorage("isDarkMode") private var darkModeEnabled = false
    @AppStorage("appLanguageCode") private var selectedLanguageCode: String = "en"

    @State private var notificationsEnabled = true
    @State private var autoSyncEnabled = true
    @State private var preferredRoleDisplay = "Project Manager"
    @State private var showConfirmLogout = false
    @State private var cacheSize = "245 MB"
    @State private var showClearCacheAlert = false

    let availableRoles = ["Student", "Facilitator", "Project Manager", "Donor", "Intern"]
    let availableLanguages = [
        ("English", "en"),
        ("French", "fr"),
        ("Zulu", "zu"),
        ("Shona", "sn")
    ]
    
    private func clearCache() {
        cacheSize = "0 MB"
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.cacheSize = "42 KB"
        }
    }

    var body: some View {
        NavigationStack {
            List {
                
                Section(header: Text("Account & Security").foregroundColor(.orange)) {
                    
                    NavigationLink(destination: Profile()) {
                        SettingsIconRow(icon: "person.crop.circle.fill", title: "Edit Profile", subtitle: "Current User", iconColor: .customOrange)
                    }
                    
                    NavigationLink(destination: Text("Change Password Coming Soon")) {
                        SettingsIconRow(icon: "lock.shield.fill", title: "Change Password", iconColor: .customOrange)
                    }
                    
                    Button(action: { showConfirmLogout = true }) {
                        SettingsIconRow(icon: "rectangle.portrait.and.arrow.right", title: "Log Out", iconColor: .red)
                    }
                    .foregroundColor(.red)
                }
                
                Section(header: Text("Dashboard & Display").foregroundColor(.customOrange)) {
                    
                    Picker(selection: $preferredRoleDisplay) {
                        ForEach(availableRoles, id: \.self) { role in
                            Text(role).tag(role)
                        }
                    } label: {
                        SettingsIconRow(icon: "square.grid.2x2.fill", title: "Default Dashboard View", iconColor: .customOrange)
                    }
                    
                    Toggle(isOn: $notificationsEnabled) {
                        SettingsIconRow(icon: "bell.badge.fill", title: "Enable Notifications", iconColor: .customOrange)
                    }
                    .tint(.orange)
                    
                    Picker(selection: $selectedLanguageCode) {
                        ForEach(availableLanguages, id: \.1) { (name, code) in
                            Text(name).tag(code)
                        }
                    } label: {
                        SettingsIconRow(icon: "globe", title: "App Language", subtitle: availableLanguages.first(where: { $0.1 == selectedLanguageCode })?.0, iconColor: .customOrange)
                    }
                    
                    Toggle(isOn: $darkModeEnabled) {
                        SettingsIconRow(icon: "moon.fill", title: "Dark Mode", iconColor: .customOrange)
                    }
                    .tint(.customOrange)
                }
                
                Section(header: Text("Data & Synchronization").foregroundColor(.customOrange)) {
                    
                    Toggle(isOn: $autoSyncEnabled) {
                        SettingsIconRow(icon: "arrow.triangle.2.circlepath", title: "Auto-Sync Data", iconColor: .customOrange)
                    }
                    .tint(.customOrange)
                    
                    Button(action: { showClearCacheAlert = true }) {
                        HStack {
                            SettingsIconRow(icon: "trash.fill", title: "Clear Local Cache", subtitle: "Currently \(cacheSize)", iconColor: .red)
                            Spacer()
                            Text(cacheSize)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .foregroundColor(.primary)
                }
                
                Section(header: Text("Support").foregroundColor(.customOrange)) {
                    
                    NavigationLink(destination: FAQView()) {
                        SettingsIconRow(icon: "questionmark.circle.fill", title: "Help Center & FAQ", iconColor: .customOrange)
                    }
                    
                    NavigationLink(destination: About_Page()) {
                        SettingsIconRow(icon: "info.circle.fill", title: "About", subtitle: "v1.0.0", iconColor: .customOrange)
                    }
                }
                
                HStack {
                    Spacer()
                    VStack {
                        Text("Facilitator Dashboard v1.0.0")
                        Text("© 2025 Matter Hub")
                    }
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding(.vertical, 20)
                    Spacer()
                }
                .listRowBackground(Color.clear)
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        
                    }
                    .fontWeight(.semibold)
                    .foregroundColor(.customOrange)
                }
            }
            .alert("Log Out", isPresented: $showConfirmLogout) {
                Button("Cancel", role: .cancel) { }
                Button("Log Out", role: .destructive) {
                 
                }
            } message: {
                Text("Are you sure you want to log out of your account?")
            }
            .alert("Clear Cache", isPresented: $showClearCacheAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Clear \(cacheSize)", role: .destructive) {
                    clearCache()
                }
            } message: {
                Text("This will remove all temporary data and free up storage.")
            }
        }
        .tint(.orange)
        .preferredColorScheme(darkModeEnabled ? .dark : .light)
    }
}

struct SettingsIconRow: View {
    let icon: String
    let title: String
    var subtitle: String? = nil
    let iconColor: Color
    
    var body: some View {
        HStack(spacing: 15) {
            
            Image(systemName: icon)
                .font(.system(size: 16, weight: .regular))
                .frame(width: 28, height: 28)
                .background(iconColor.opacity(0.15))
                .foregroundColor(iconColor)
                .cornerRadius(6)

            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.body)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
