//
//  HackathonApp.swift
//  Hackathon
//
//  Created by Ian. T. Dzingira on 11/12/2025.
//

import SwiftUI

@main
struct HackathonApp: App {
    @AppStorage("isDarkMode") var isDarkMode: Bool = false
    @AppStorage("appLanguageCode") var appLanguageCode: String = "en"
    var body: some Scene {
        WindowGroup {
           WelcomeView()
                .preferredColorScheme(isDarkMode ? .dark : .light)
                .environment(\.locale, .init(identifier: appLanguageCode))
        }
    }
}
