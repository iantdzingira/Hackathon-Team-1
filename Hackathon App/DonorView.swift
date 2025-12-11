//
//  DonorSnapshot.swift
//  Hackathon
//
//  Created by Ian. T. Dzingira on 11/12/2025.
//

import SwiftUI

struct DonorSnapshot: View {
    var body: some View {
        
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    
                    Image("MCRI")
                        .resizable()
                        .scaledToFit()
                    //                    .padding()
                        .cornerRadius(10)
                    Spacer()
                    
                    Text("""
                The MATTER Career Readiness Institute (MCRI) is an initiative by the non-profit organization MATTER and is part of their larger MATTER Innovation Hub program, which operates in several locations across Zimbabwe. This program trains local youth for remote technology jobs with international companies. The program is primarily sponsored by U.S. companies Jamf and Mains'l Services, Inc., which also provide guaranteed paid internships to graduates.
                
                The program has been highly successful, with graduates receiving full-time remote job offers from sponsoring companies. In late 2024, plans for a Phase Two expansion were announced to build a Workforce Development Center to double enrollment and accommodate more students....
                """)
                    .lineLimit(nil)
                    .multilineTextAlignment(.leading)
                    .font(.body)
                    
                    
                    NavigationLink(destination: Matter_Website(showWebView: "")) {
                        Text("more")
                            .foregroundColor(.blue)
                            .font(.body)
                    }
                    .offset(x: 84, y: -20) // Fine-tune this to get the exact position
                }
                .padding()
                .navigationTitle("About Matter and MCRI")
            }
        }
    }
}

#Preview {
    DonorSnapshot()
}
