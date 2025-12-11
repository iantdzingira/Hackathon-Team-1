//
//  ContentView.swift
//  Hackathon
//
//  Created by Ian T. Dzingira on 11/12/2025.
//

import SwiftUI

extension Color {
    static let customOrange = Color(red: 229/255, green: 87/255, blue: 44/255)
}

struct WelcomeView: View {
    @State private var animate = false
    @State private var settle = false
    
    var body: some View {
        NavigationStack {
            VStack {
                
                
                Image("matter")
                    .resizable()
                    .scaledToFit()
                    .scaleEffect(
                        animate
                        ? (settle ? 1.0 : 1.03)   // subtle settle-out
                        : 0.92                    // slow graceful scale-in
                    )
                    .opacity(animate ? 1 : 0)
                    .offset(y: animate ? -45 : 0)
                    .animation(.easeInOut(duration: 1.4), value: animate)
                    .animation(.easeOut(duration: 0.6), value: settle)
                
                Text("Matter Hub")
                    .font(.largeTitle.bold())
                    .foregroundColor(.black)
                    .opacity(animate ? 1 : 0)
                    .offset(y: animate ? -100 : -20)
                    .animation(.easeInOut(duration: 1.2).delay(0.4), value: animate)
                
                Text("See what matters instantly and connect with others.")
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .italic()
                    .multilineTextAlignment(.center)
                    .padding(.top)
                    .opacity(animate ? 1 : 0)
                    .offset(y: animate ? -70 : 10)
                    .animation(.easeInOut(duration: 1.2).delay(0.6), value: animate)
                
                NavigationLink {
                    
                } label: {
                    RoundedRectangle(cornerRadius: 25)
                        .frame(width: 200, height: 50)
                        .foregroundStyle(Color.customOrange)
                        .overlay(
                            Text("Get Started")
                                .bold()
                                .foregroundColor(.white)
                        )
                }
                .opacity(animate ? 1 : 0)
                .offset(y: animate ? 0 : 40)
                .animation(.easeInOut(duration: 1.2).delay(0.8), value: animate)
                
            }
            .padding(20)
            .onAppear {
                animate = true
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
                    settle = true
                }
            }
        }
    }
}

#Preview {
    WelcomeView()
}









