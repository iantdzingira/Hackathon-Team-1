//
//  Manager Control Panel.swift
//  Hackathon
//
//  Created by Ian. T. Dzingira on 11/12/2025.
//
import SwiftUI

struct Partner: Identifiable {
    let id = UUID()
    let name: String
    let logoName: String
    let description: String
}

struct PartnersView: View {
    @State private var selectedPartner: Partner?
    @State private var showDetail = false
    
    let partners = [
        Partner(
            name: "MATTER",
            logoName: "matterLogo",
            description: "International NGO focused on sustainable change through health, food security, and education initiatives."
        ),
        Partner(
            name: "Jamf",
            logoName: "jamfLogo",
            description: "Leader in Apple Enterprise Management, helping organizations succeed with Apple technology."
        ),
        Partner(
            name: "Mains'l Solutions",
            logoName: "mainslLogo",
            description: "Provides Financial Management Services and software for self-directed home and community-based services."
        ),
        Partner(
            name: "Tradition Capital Bank",
            logoName: "Tradition",
            description: "Privately held community bank providing custom banking solutions for businesses and individuals."
        )
    ]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 10) {
                // Stats Header
                HStack(spacing: 12) {
                    StatCard(title: "Total Employees", value: "24", color: .customOrange)
                    StatCard(title: "Active Interns", value: "8", color: .customOrange)
                }
                .padding()
                
                // Partners Grid
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        ForEach(partners) { partner in
                            PartnerCard(partner: partner) {
                                selectedPartner = partner
                                showDetail = true
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
                
                // Footer
                VStack(spacing: 8) {
                    Text("Strategic Partnerships")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("Building sustainable communities through collaboration")
                        .font(.caption2)
                        .foregroundColor(.orange.opacity(0.7))
                        .multilineTextAlignment(.center)
                }
                .padding(.vertical, 16)
            }
            .navigationTitle("Partners")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(.systemGray6).ignoresSafeArea())
            .sheet(item: $selectedPartner) { partner in
                PartnerDetailView(partner: partner)
            }
        }
    }
        
}
    

struct PartnerCard: View {
    let partner: Partner
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                // Logo
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.orange.opacity(0.1))
                        .frame(height: 100)
                    
                    Image(partner.logoName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 140, height: 80)
                        .foregroundColor(.orange)
                }
                
                // Name
                Text(partner.name)
                    .font(.subheadline.bold())
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                
                // Description
                Text(partner.description)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
                    .padding(.horizontal, 4)
            }
            .padding(12)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct PartnerDetailView: View {
    let partner: Partner
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    VStack(spacing: 16) {
                        Image(partner.logoName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 100)
                            .foregroundColor(.orange)
                        
                        Text(partner.name)
                            .font(.title2.bold())
                            .foregroundColor(.orange)
                        
                        Text(partner.description)
                            .font(.callout)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .padding(.top, 20)
                    
                    // Content
                    VStack(alignment: .leading, spacing: 16) {
                        if partner.name == "MATTER" {
                            MatterContent()
                        } else if partner.name == "Jamf" {
                            JamfContent()
                        } else if partner.name == "Mains'l Solutions" {
                            MainslContent()
                        } else if partner.name == "Tradition Capital Bank" {
                            TraditionContent()
                        }
                    }
                    .padding(.horizontal)
                    
                    // Representatives
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Key Representatives")
                            .font(.headline)
                            .foregroundColor(.orange)
                        
                        ForEach(representatives(for: partner.name), id: \.name) { rep in
                            RepresentativeRow(representative: rep)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
                    // Website Link
                    if let url = websiteURL(for: partner.name) {
                        Button(action: {
                            UIApplication.shared.open(url)
                        }) {
                            Label("Visit Website", systemImage: "safari.fill")
                                .font(.callout.bold())
                                .foregroundColor(.orange)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.orange.opacity(0.1))
                                .cornerRadius(10)
                        }
                        .padding(.horizontal)
                        .padding(.top, 20)
                    }
                }
                .padding(.bottom, 30)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.orange)
                }
            }
        }
    }
    
    func representatives(for partner: String) -> [Representative] {
        switch partner {
        case "MATTER":
            return [
                Representative(name: "Quenton Marty", role: "CEO", linkedin: "https://linkedin.com/in/quentonmarty"),
                Representative(name: "Jeremy Newhouse", role: "VP of Programs", linkedin: "https://linkedin.com/in/jeremynewhouse")
            ]
        case "Jamf":
            return [
                Representative(name: "Dean Hager", role: "Former CEO", linkedin: "https://linkedin.com/in/deanhager"),
                Representative(name: "Saltmash", role: "Director", linkedin: "https://linkedin.com/in/saltmash"),
                Representative(name: "Kelly", role: "HR Partner", linkedin: "https://linkedin.com/in/kelly")
            ]
        case "Mains'l Solutions":
            return [
                Representative(name: "Sarah Tah", role: "Partnership Director", linkedin: "https://linkedin.com/in/sarahtah")
            ]
        case "Tradition Capital Bank":
            return [
                Representative(name: "Tradition Bank", role: "Corporate", linkedin: "https://linkedin.com/company/traditionbank")
            ]
        default:
            return []
        }
    }
    
    func websiteURL(for partner: String) -> URL? {
        switch partner {
        case "MATTER": return URL(string: "https://matter.ngo")
        case "Jamf": return URL(string: "https://jamf.com")
        case "Mains'l Solutions": return URL(string: "https://mainsl.com")
        case "Tradition Capital Bank": return URL(string: "https://tradition.bank")
        default: return nil
        }
    }
}

struct Representative: Identifiable {
    let id = UUID()
    let name: String
    let role: String
    let linkedin: String
}

struct RepresentativeRow: View {
    let representative: Representative
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "person.crop.circle.fill")
                .font(.title2)
                .foregroundColor(.orange)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(representative.name)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                
                Text(representative.role)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Link(destination: URL(string: representative.linkedin)!) {
                Image(systemName: "link.circle.fill")
                    .font(.title3)
                    .foregroundColor(.orange.opacity(0.7))
            }
        }
        .padding(.vertical, 4)
    }
}

// Compact Content Views
struct MatterContent: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            DetailSection(title: "Core Areas") {
                BulletPoint(text: "Global Health Access: Ships medical equipment to 70+ countries")
                BulletPoint(text: "Healthy Food Security: Provides meal kits and education")
                BulletPoint(text: "Education & Innovation: Runs MATTER Innovation Hubs")
            }
            
            DetailSection(title: "MCRI Partnership") {
                Text("MATTER partners with Jamf to create Innovation Hubs in Zimbabwe, providing technology and coding curriculum to prepare students for global careers.")
                    .font(.callout)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct JamfContent: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            DetailSection(title: "MCRI Partnership") {
                BulletPoint(text: "Primary sponsor of the MCRI program")
                BulletPoint(text: "Provides Apple coding certifications")
                BulletPoint(text: "Offers paid internships and remote tech jobs")
                BulletPoint(text: "Transforms local economies through tech employment")
            }
            
            DetailSection(title: "Impact") {
                Text("Jamf's partnership creates a direct pipeline from training to employment, turning graduates into software engineers earning global wages while living locally.")
                    .font(.callout)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct MainslContent: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            DetailSection(title: "Services") {
                BulletPoint(text: "Financial Management Services (FMS)")
                BulletPoint(text: "Navigation Plus™ software platform")
                BulletPoint(text: "Payroll processing and tax filing")
                BulletPoint(text: "Electronic Visit Verification compliance")
            }
            
            DetailSection(title: "Mission") {
                Text("Empowers individuals to direct their own care through administrative support and technology solutions, enabling personal independence and compliance with regulations.")
                    .font(.callout)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct TraditionContent: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            DetailSection(title: "Focus Areas") {
                BulletPoint(text: "Private and Personal Banking")
                BulletPoint(text: "Commercial Business Lending")
                BulletPoint(text: "Construction and Real Estate Finance")
                BulletPoint(text: "Relationship-focused service model")
            }
            
            DetailSection(title: "Approach") {
                Text("Combines the agility of a community bank with sophisticated financial products, emphasizing personal relationships over transactional banking.")
                    .font(.callout)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct DetailSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(.orange)
            
            content
        }
    }
}

struct BulletPoint: View {
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "circle.fill")
                .font(.caption2)
                .foregroundColor(.orange)
                .padding(.top, 4)
            
            Text(text)
                .font(.callout)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
        }
    }
}

#Preview {
    PartnersView()
}
