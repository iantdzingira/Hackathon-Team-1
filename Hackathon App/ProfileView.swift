//
//  ProfileView.swift
//  Hackathon App
//
//  Created by Ian. T. Dzingira on 11/12/2025.
//


import SwiftUI

struct ProfileView: View {
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Profile for: ")
                    .font(.title)
               
                .buttonStyle(.borderedProminent)
            }
            .padding()
            .navigationTitle("My Profile")
        }
    }
}
