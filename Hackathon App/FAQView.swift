//
//  FAQView.swift
//  Hackathon App
//
//  Created by Ian. T. Dzingira on 12/12/2025.
//

import SwiftUI

struct FAQView: View {
    @State private var searchText = ""
    @State private var expandedItems: Set<UUID> = []
    @State private var showWebsite = false
    
    struct FAQItem: Identifiable {
        let id = UUID()
        let question: String
        let answer: String
    }
    
    let faqItems: [FAQItem] = [
        FAQItem(
            question: "Who can enroll in the program?",
            answer: "Programs may accept high school students, college students, recent graduates, unemployed individuals, or professionals looking to upskill—depending on the institute's focus."
        ),
        FAQItem(
            question: "How long does the program take?",
            answer: "Length varies by institute—at MCRI it takes up to 18 months including internship."
        ),
        FAQItem(
            question: "Is there a cost to attend?",
            answer: "No cost. Requires A or better in English, and 2 years Hub experience."
        ),
        FAQItem(
            question: "Do I receive a certificate?",
            answer: "Yes, you'll receive a worldwide-recognized certificate."
        ),
        FAQItem(
            question: "Are job placements included?",
            answer: "Yes, we partner with American employers for internship-to-job opportunities."
        ),
        FAQItem(question: "What is MCRI?", answer: "Matter Career Readiness Institute prepares youth for real-world work and career growth."),
        FAQItem(question: "What skills does MCRI teach?", answer: "Career readiness, communication, teamwork, digital literacy, leadership, professionalism, problem-solving."),
        FAQItem(question: "What makes MCRI different?", answer: "Hands-on learning, industry connections, non-traditional spaces, personal/professional growth focus."),
        FAQItem(question: "How does MCRI support growth?", answer: "Mentorship, challenges, group work, self-improvement exercises, leadership development."),
        FAQItem(question: "What environment should I expect?", answer: "Supportive, energetic, open-space, self-paced learning environment."),
        FAQItem(question: "What companies does MCRI work with?", answer: "Jamf, Apple, Mainsi'l, Tradition Capital Bank")
    ]
    
    var filteredFaqItems: [FAQItem] {
        searchText.isEmpty ? faqItems : faqItems.filter {
            $0.question.localizedCaseInsensitiveContains(searchText) ||
            $0.answer.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Compact Header
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("FAQs")
                            .font(.title2.bold())
                            .foregroundColor(.orange)
                        Text("Frequently Asked Questions")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    
                    Button(action: { showWebsite = true }) {
                        Label("Website", systemImage: "safari.fill")
                            .font(.caption)
                            .foregroundColor(.orange)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.orange.opacity(0.1))
                            .cornerRadius(8)
                    }
                }
                .padding(.horizontal)
                .padding(.top)
                
                // Compact Search
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.orange.opacity(0.7))
                    
                    TextField("Search questions...", text: $searchText)
                        .font(.callout)
                    
                    if !searchText.isEmpty {
                        Button(action: { searchText = "" }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.orange.opacity(0.5))
                        }
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
                .padding(.vertical, 12)
                
                // FAQ List
                if filteredFaqItems.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "questionmark.circle")
                            .font(.largeTitle)
                            .foregroundColor(.orange.opacity(0.3))
                        Text("No questions found")
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 40)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 8) {
                            ForEach(filteredFaqItems) { item in
                                FAQCard(item: item, isExpanded: expandedItems.contains(item.id)) {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                        if expandedItems.contains(item.id) {
                                            expandedItems.remove(item.id)
                                        } else {
                                            expandedItems.insert(item.id)
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 20)
                    }
                }
                
                // Compact Footer
                VStack(spacing: 4) {
                    Text("Need more help?")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Button("Visit matter.ngo") {
                        showWebsite = true
                    }
                    .font(.caption.bold())
                    .foregroundColor(.orange)
                }
                .padding(.vertical, 16)
            }
            .background(Color(.systemGray6).ignoresSafeArea())
            .sheet(isPresented: $showWebsite) {
                MatterWebsiteView()
            }
        }
    }
}

struct FAQCard: View {
    let item: FAQView.FAQItem
    let isExpanded: Bool
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            Button(action: action) {
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: "questionmark.circle.fill")
                        .font(.callout)
                        .foregroundColor(.orange)
                        .padding(.top, 2)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(item.question)
                            .font(.callout)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.leading)
                            .lineLimit(2)
                        
                        if isExpanded {
                            Text(item.answer)
                                .font(.caption)
                                .foregroundColor(.black)
                                .padding(.top, 8)
                                .transition(.opacity)
                                .fontWeight(.regular)
                        }
                    }
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.caption)
                        .foregroundColor(.orange.opacity(0.7))
                }
                .padding()
                .contentShape(Rectangle())
            }
            .buttonStyle(PlainButtonStyle())
            
            if !isExpanded {
                Divider()
                    .padding(.horizontal)
            }
        }
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        .animation(.easeInOut(duration: 0.2), value: isExpanded)
    }
}

struct MatterWebsiteView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "safari.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.orange.opacity(0.5))
                    .padding(.top, 40)
                
                VStack(spacing: 8) {
                    Text("Website Redirect")
                        .font(.title2.bold())
                        .foregroundColor(.orange)
                    
                    Text("matter.ngo")
                        .font(.title3.monospaced())
                        .foregroundColor(.orange)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 8)
                        .background(Color.orange.opacity(0.1))
                        .cornerRadius(8)
                }
                
                Text("You'll be redirected to our official website for more information.")
                    .font(.callout)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                
                Button(action: {
                    if let url = URL(string: "https://www.matter.ngo") {
                        UIApplication.shared.open(url)
                    }
                }) {
                    HStack {
                        Image(systemName: "arrow.up.forward.app.fill")
                        Text("Open in Safari")
                    }
                    .font(.callout.bold())
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.orange)
                    .cornerRadius(10)
                }
                .padding(.top, 20)
                
                Spacer()
                
                Button("Maybe Later") {
                    dismiss()
                }
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.bottom, 30)
            }
            .navigationTitle("Website")
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
}

#Preview {
    FAQView()
}
