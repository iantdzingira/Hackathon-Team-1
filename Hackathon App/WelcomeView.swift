//
//  ContentView.swift
//  Hackathon
//
//  Created by Ian. T. Dzingira on 11/12/2025.
//

import SwiftUI

struct WelcomeView: View {
    @State private var scale: CGFloat = 0.5
    
    var body: some View {
        NavigationView {
            VStack {
                
                Image("matter")
                    .resizable()
                    .frame(width: 250, height: 250)
                    .scaledToFit()
                    .scaleEffect(scale)
                    .onAppear{
                        withAnimation(.easeOut(duration: 1.5)) {
                            scale = 1.0
                        }
                    }
                
                Text("Matter Hub")
                    .font(.system(size: 40))
                    .font(.headline)
                    .offset(y: -70)
                    .scaledToFit()
                    .scaleEffect(scale)
                    .onAppear{
                        withAnimation(.easeOut(duration: 2.0)) {
                            scale = 1.0
                        }
                    }
                    
                
                Text("See what matters instantly and connect with others.")
                    .font(.headline)
                    .lineLimit(3)
                                        .fontWeight(.bold)
                                        .foregroundColor(.secondary)
                                        .offset(y: -70)
                                        .font(.system(size: 25, weight:.thin))
                                        .italic()
                                        .multilineTextAlignment(.center)
                                        .padding(.top)
                    .scaleEffect(scale)
                    .onAppear{
                        withAnimation(.easeOut(duration: 2.0)) {
                            scale = 1.0
                        }
                    }
                
                NavigationLink("Get Started"){
                    RootView(isAuthenticated: false)
                }
                    .scaledToFit()
                    .scaleEffect(scale)
                    .onAppear{
                        withAnimation(.easeOut(duration: 2.0)) {
                            scale = 1.0
                        }
                    }
                
                .padding()
                .frame(width: 200, height: 60)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundStyle(Color.customOrange)
                )
                .foregroundColor(.white)
                .font(.headline)
            }
            .padding()
        }
    }
}

#Preview {
    WelcomeView()
}
