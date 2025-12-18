//
//  ProfileView.swift
//  Hackathon App
//
//  Created by Ian. T. Dzingira on 11/12/2025.
//


import SwiftUI
import PhotosUI

struct Profile: View {
    @State private var username = ""
    @State private var email = ""
    @State private var phone = ""
    @State private var address = ""
    
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var profileImage: Image? = nil
    
    @State private var navigateToSettings: Bool = false
    @State private var showSaveSuccess = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    
                    // Profile Image Section with Orange Style
                    VStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [.orange.opacity(0.1), .orange.opacity(0.05)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 120, height: 120)
                                .overlay(
                                    Circle()
                                        .stroke(
                                            LinearGradient(
                                                colors: [.orange, .orange.opacity(0.5)],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            lineWidth: 3
                                        )
                                )
                                .shadow(color: .orange.opacity(0.2), radius: 10)
                            
                            if let profileImage = profileImage {
                                profileImage
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 110, height: 110)
                                    .clipShape(Circle())
                                    .overlay(
                                        Circle()
                                            .stroke(
                                                LinearGradient(
                                                    colors: [.orange, .orange.opacity(0.7)],
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                ),
                                                lineWidth: 2
                                            )
                                    )
                            } else {
                                Image(systemName: "person.crop.circle.fill")
                                    .font(.system(size: 100))
                                    .foregroundColor(.orange.opacity(0.6))
                            }
                        }
                        
                        PhotosPicker(
                            selection: $selectedItem,
                            matching: .images,
                            photoLibrary: .shared()
                        ) {
                            Label("Change Photo", systemImage: "camera.fill")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.orange)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(Color.orange.opacity(0.1))
                                .cornerRadius(20)
                        }
                        .onChange(of: selectedItem) { newItem in
                            Task {
                                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                    if let uiImage = UIImage(data: data) {
                                        profileImage = Image(uiImage: uiImage)
                                        return
                                    }
                                }
                                print("Failed to load image.")
                            }
                        }
                    }
                    .padding(.top, 20)
                    
                    // Welcome Header
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "hand.wave.fill")
                                .foregroundColor(.orange)
                            Text("Welcome! Update your details below.")
                                .font(.headline)
                                .foregroundColor(.orange.opacity(0.8))
                        }
                        .padding(.horizontal)
                        
                        Divider()
                            .background(Color.orange.opacity(0.3))
                            .padding(.horizontal)
                    }
                    
                    // Profile Form Fields
                    VStack(alignment: .leading, spacing: 20) {
                        ProfileTextField(
                            title: "Full Name",
                            placeholder: "Enter your full name",
                            text: $username,
                            systemImage: "person.fill"
                        )
                        
                        ProfileTextField(
                            title: "Email Address",
                            placeholder: "you@example.com",
                            text: $email,
                            keyboardType: .emailAddress,
                            systemImage: "envelope.fill"
                        )
                        
                        ProfileTextField(
                            title: "Phone Number",
                            placeholder: "+1 (555) 555-5555",
                            text: $phone,
                            keyboardType: .phonePad,
                            systemImage: "phone.fill"
                        )
                        
                        ProfileTextField(
                            title: "Address",
                            placeholder: "Street, City, Postal Code",
                            text: $address,
                            systemImage: "house.fill"
                        )
                    }
                    .padding(.horizontal)
                    
                    // Save Button with Orange Gradient
                    Button(action: {
                        print("Saving profile changes...")
                        withAnimation {
                            showSaveSuccess = true
                        }
                        // Hide success message after 2 seconds
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                showSaveSuccess = false
                            }
                        }
                        self.navigateToSettings = true
                    }) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                            Text("Save Changes")
                                .font(.title3)
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(
                                colors: [.orange, .orange.opacity(0.8)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .foregroundColor(.white)
                        .cornerRadius(15)
                        .shadow(color: .orange.opacity(0.4), radius: 8, x: 0, y: 4)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 20)
                    
                    // Success Message
                    if showSaveSuccess {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Text("Profile saved successfully!")
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.green)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(20)
                        .transition(.opacity)
                    }
                    
                    // Settings Navigation Button
                    Button(action: { navigateToSettings = true }) {
                        HStack {
                            Image(systemName: "gear")
                                .foregroundColor(.orange)
                            Text("Advanced Settings")
                                .foregroundColor(.orange)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.orange.opacity(0.7))
                        }
                        .padding()
                        .background(Color.orange.opacity(0.05))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.orange.opacity(0.2), lineWidth: 1)
                        )
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 30)
                }
            }
            .navigationTitle("Your Profile")
            .navigationBarTitleDisplayMode(.large)
            .tint(.orange)
            .background(Color(.systemGray6))
            
            .navigationDestination(isPresented: $navigateToSettings) {
                SettingsView()
            }
        }
        .accentColor(.orange)
    }
}

struct ProfileTextField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    var systemImage: String? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                if let icon = systemImage {
                    Image(systemName: icon)
                        .font(.caption)
                        .foregroundColor(.orange.opacity(0.7))
                }
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.orange.opacity(0.8))
            }
            
            TextField(placeholder, text: $text)
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .background(Color.white)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.orange.opacity(0.3), lineWidth: 1)
                )
                .keyboardType(keyboardType)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .tint(.orange)
        }
    }
}

#Preview {
    Profile()
}
