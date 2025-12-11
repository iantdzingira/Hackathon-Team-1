//
//  Manager Control Panel.swift
//  Hackathon
//
//  Created by Ian. T. Dzingira on 11/12/2025.

import SwiftUI

struct Partner: Identifiable {
    let id = UUID()
    let name: String
    let logoName: String
    let description: String
}

struct PartnersView: View {
    @State private var selectedPartner: Partner? = nil
    @State private var showSheet = false

    let totalEmployees = 24
    let totalInterns = 8

    let partners = [
        Partner(name: "       You Matter!", logoName: "matterLogo", description: "Details about Matter."),
        Partner(name: "   Helping Organizations Succeed with Apple.", logoName: "jamfLogo", description: "Details about Jamf."),
        Partner(name: "       Hopes and Dreams!", logoName: "mainslLogo", description: "Details about Mains'l."),
        Partner(name: "   Committed to you!", logoName: "Tradition", description: "Details about Tradition Bank.")
    ]

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                HStack(spacing: 16) {
                    VStack {
                        Text("Total Employees")
                            .font(.headline)
                            .foregroundColor(.white)
                        Text("\(totalEmployees)")
                            .font(.title)
                            .bold()
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.orange)
                    .cornerRadius(10)

                    VStack {
                        Text("Total Interns")
                            .font(.headline)
                            .foregroundColor(.white)
                        Text("\(totalInterns)")
                            .font(.title)
                            .bold()
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.orange)
                    .cornerRadius(10)
                }
                .padding(.horizontal)

                List(partners) { partner in
                    Button(action: {
                        selectedPartner = partner
                        showSheet.toggle()
                    }) {
                        HStack {
                            Image(partner.logoName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                            Text(partner.name)
                                .font(.headline)
                                .padding(.leading, 8)
                        }
                        .padding(.vertical, 8)
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle("Partners")
            .sheet(isPresented: $showSheet) {
                if let partner = selectedPartner {
                    PartnerDetailView(partner: partner)
                }
            }
        }
    }
}

struct PartnerDetailView: View {
    let partner: Partner

    var body: some View {
        VStack(spacing: 20) {
            Image(partner.logoName)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)

            Text(partner.name)
                .font(.largeTitle)
                .bold()

            Text(partner.description)
                .padding()

            Spacer()
        }
        .padding()
    }
}

struct PartnersView_Previews: PreviewProvider {
    static var previews: some View {
        PartnersView()
    }
}















//

//import SwiftUI

//struct Managers: View {
//    var body: some View {
//
//
//    }
//}
//
//#Preview {
//    Managers()
//}


