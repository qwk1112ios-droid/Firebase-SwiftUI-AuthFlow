//
//  InfoSetting.swift
//  Firebase-SwiftUI-AuthFlow
//
//  Created by Amel Sbaihi on 3/30/26.
//

import SwiftUI
import FirebaseAuth

struct InfoSetting: View {
    @Environment(AuthenticationManager.self) var authManager
    @State var showAuthView: Bool = false
    @State var showDeleteAccountAlert = false
    
    var body: some View {
        NavigationStack {
            ZStack{
                FluidModernBackground()
                VStack(alignment: .leading, spacing: 24){
                    EmptyView()
                    if authManager.authState == .authenticated {
                        // Link user signIn
                        Text(
                            "SignIn to become a cb member"
                        )
                        .font(.headline)
                        .padding()
                        
                        
                        Button {
                            showAuthView = true
                            
                        } label: {
                            HStack(spacing: 4) {
                                Text("SignIn")
                                    .font(.body.bold())
                                
                                
                            }
                            .foregroundStyle(Color.white)
                            .frame(width: 260, height: 45)
                            .background(Color.appButton)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(
                                        Color.white.opacity(0.25),
                                        lineWidth: 1
                                    )
                            )
                        }
                        
                    }
                        
                        if authManager.authState == .signedIn {
                            
                            AccountCard(name: authManager.user?.displayName ?? " no name", email: authManager.user?.email ?? "no email") {
                                handleSignOut()
                            } onDeleteAccount: {
                                showDeleteAccountAlert = true
                            }
                        
                        }
                    }
                     .confirmationDialog("Delete Account ", isPresented: $showDeleteAccountAlert) {
                        Button("Yes, Delete account", role: .destructive){
                            Task{
                                do {
                                    try await authManager.deleteAccount()
                                    
                                }
                                
                                catch AuthErrors.ReauthenticateGoogle {
                                    // Google re-authentication failed
                                }
                                catch AuthErrors.RevokeGoogle {
                                    // Google token revocation failed
                                }
                                catch {
                                    // Show generic error message
                                }
                            }
                        }
                        
                    }message: {
                        Text("Deleting account is permanent. Are you sure you want to delete your account?") }
                }.sheet(isPresented: $showAuthView) {
                    AuthView()
                }
                .navigationTitle("Settings")
                .navigationBarTitleDisplayMode(.large)
                
            }
        }
        
        //MARK: -SignOut
        func handleSignOut() {
            do {
                try authManager.signOut()
                
            } catch {
                print("error")
            }
        }
    }
    
    




#Preview {
    InfoSetting()
        .environment(AuthenticationManager())
}
