//
//  faq.swift
//  Hackathon App
//
//  Created by Shine Ncube on 12/11/25.
//

import SwiftUI
import WebKit

struct FAQView: View {
    @State private var searchText: String = ""
    
    struct FAQItem: Identifiable {
        let id = UUID()
        let question: String
        let answer: String
    }
    
    let faqItems: [FAQItem] = [
        FAQItem(
            question: "Who can enroll in the program?",
            answer: "Programs may accept high school students, college students, recent graduates, unemployed individuals, or professionals looking to upskill—depending on the institute’s focus."
        ),
        FAQItem(
            question: "How long does the program take to complete?",
            answer: "Length varies by institute— at MCRI it takes upto 18 months including internship."
        ),
        FAQItem(
            question: "Is there a cost to attend?",
            answer: "No cost to attend the program. However, need to have A or better in English, and 2 years Hub experience."),
           
        FAQItem(
            question: "Do I receive a certificate after completion?",
            answer: "Yes you will receive a certificate of completion recognized worldwide."
        ),
        FAQItem(
            question: " Are internships or job placements included?",
            answer: "Yes they are we partner with American employers to offer internship opportunities -> Job"
        ),
        FAQItem(question: "What is the Matter Career Readiness Institute (MCRI)?", answer: "MCRI is a skills-development program designed to prepare young people for real-world work environments and career growth."),
        FAQItem(question: "What skills does MCRI teach?", answer: "Career readiness, communication, teamwork, digital literacy, leadership, professionalism, and problem-solving."),
        FAQItem(question: "What makes MCRI different from other programs?", answer: "Its hands-on learning, industry connections, non-traditional spaces, and focus on both personal and professional growth."),
        FAQItem(question: " How does MCRI support personal growth?", answer: "Through mentorship, challenges, group work, self-improvement exercises, and leadership development."),
        FAQItem(question: "What environment should I expect?", answer: "A supportive, energetic, open-space, self paced learning environment."),
        FAQItem(question: "What companies does MCRI work with?", answer: "It works with companies like Jamf, Apple, Mainsi'l, Tradition capital bank")
        
    ]
    
    // Filtered FAQ based on search
    var filteredFaqItems: [FAQItem] {
        if searchText.isEmpty {
            return faqItems
        } else {
            return faqItems.filter {
                $0.question.lowercased().contains(searchText.lowercased()) ||
                $0.answer.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient similar to the orange gradient in the image
                LinearGradient(
                    gradient: Gradient(colors: [Color.orange.opacity(0.9), Color.black]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .edgesIgnoringSafeArea(.all)
                
                VStack(alignment: .leading, spacing: 20) {
                    //                Image("logo")
                    //                    .resizable()
                    //                    .frame(width: 100, height: 50)
                    //                    .offset(x: 100)
                    
                    Text("FAQ's")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                    
                    // Search Bar
                    HStack {
                        TextField("Ask Questions?", text: $searchText)
                            .padding(12)
                            .background(Color.orange.opacity(0.9))
                            .cornerRadius(10)
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal)
                    
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(filteredFaqItems) { item in
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(item.question)
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    
                                    Text(item.answer)
                                        .font(.subheadline)
                                        .foregroundColor(.white.opacity(0.8))
                                        .padding()
                                        .background(Color.orange.opacity(0.6))
                                        .cornerRadius(8)
                                        .fixedSize(horizontal: false, vertical: true) // multiline support
                                }
                                .padding(.horizontal)
                            }
                        }
                        .padding(.bottom, 30)
                    }
                    NavigationLink(destination: Matter_Website(showWebView: "")) {
                        Text("www.matter.ngo")
                            .fontWeight(.bold)
                            .font(.body)
                    }
                    .offset(x: 130, y: -0)
                    .tint(.gray)
                }
            }
        }
    }
}

struct Matter_Website: View {

    @State public var showWebView: String
    private let urlString: String = "https://www.matter.ngo/"
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 40) {
                WebView(url: URL(string: urlString)!).frame(height: .infinity)
                
                    .ignoresSafeArea()
                
            }
        }
    }
}

struct WebView: UIViewRepresentable {
    var url: URL
    
    func makeUIView(context: Context) -> some WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}


#Preview {
    FAQView()
}


