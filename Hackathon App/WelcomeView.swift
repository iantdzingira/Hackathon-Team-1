//
//  ContentView.swift
//  Hackathon
//
//  Created by Ian. T. Dzingira on 11/12/2025.
//

import SwiftUI

struct WelcomeView: View {
   @State private var animate: Bool = false
    var body: some View {
        NavigationStack{
            VStack() {
                Image("matter")
                    .resizable()
                    .scaledToFit()
                    .offset(y: -50)
                //                    .scaleEffect(animate ? 1 : 0.8)
                //                    .opacity(animate ? 1: 0)
                //                    .animation(.easeOut(duration: 0.8), value: animate)
                Text("Matter Hub")
                    .foregroundColor(.black)
                    .offset(y: -100)
                    .font(Font.largeTitle.bold())
                
                Text("See what matters instantly and connect with others.")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
                    .offset(y: -70)
                    .font(.system(size: 25, weight:.thin))
                    .italic()
                    .multilineTextAlignment(.center)
                    .padding(.top)
                NavigationLink{
                }label: {
                    ZStack{
                        
                        RoundedRectangle(cornerRadius: 6.0)
                            .frame(width: 200, height: 50)
                            .foregroundStyle(Color.orange)
                            .cornerRadius(25)
                            .padding()
                        
                        Text("Get Started")
                            .padding()
                            .foregroundColor(.white)
                            
                    }
                    .padding(.top)
                }
                .padding(.top)
            }
            .padding(20)
        }
    }
}

#Preview {
    WelcomeView()
}
