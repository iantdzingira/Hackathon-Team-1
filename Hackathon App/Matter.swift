//
//  Matter.swift
//  Hackathon App
//
//  Created by Pride Mafira  on 11/12/2025.
//


import SwiftUI
import WebKit

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
//    Matter_Website(showWebView: "https://www.matter.ngo/")
    DonorSnapshot()
}
