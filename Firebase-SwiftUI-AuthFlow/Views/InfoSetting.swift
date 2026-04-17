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
                VStack{
                    Image("security")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 280, height: 260)
                        .foregroundStyle(
                            Color.black.opacity(0.65)
                        )
                        .padding()
                        .background(
                                RoundedRectangle(cornerRadius: 28, style: .continuous)
                                    .fill(.ultraThinMaterial)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 28, style: .continuous)
                                    .stroke(.white.opacity(0.5), lineWidth: 1)
                            )
                            .shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: 10)
                            .padding()
                    Rectangle()
                        .frame(width : 300, height: 3
                        
                        )
                        .foregroundColor(Color.black.opacity(0.3))
                    if authManager.authState == .authenticated {
                       // Link user signIn
                        Text(
                            "user: \(authManager.user?.uid ?? "Anonymous User")"
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
                        
                        Button {
                          handleSignOut()
                            
                        } label: {
                            HStack(spacing: 4) {
                                Text("SignOut")
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
                     
                        VStack{
                            
                            Text(authManager.user?.displayName ?? "Name placeholder")
                                .font(.headline)
                            Text(authManager.user?.email ?? "Email placeholder")
                                .font(.subheadline)
                            //
                            
                            Button {
                                handleSignOut()
                               
                            } label: {
                                HStack(spacing: 4) {
                                    Text("SignOut")
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
                            
                            Button{
                               showDeleteAccountAlert = true
                                
                            } label: {
                                Text("Delete Account")
                                    .foregroundStyle(Color.red)
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
                    }
                }.confirmationDialog("Delete Account ", isPresented: $showDeleteAccountAlert) {
                    Button("Yes, Delete account", role: .destructive){
                        Task{
                            do {
                                try await authManager.deleteUserAccount()
                               
                            }
                            
                            catch AuthErrors.ReauthenticateApple {
                                                // AppleID re-authentication failed
                                            }
                                            catch AuthErrors.RevokeAppleID {
                                                // AppleID token revocation failed
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
                    Text("Deleting account is permanent. Are you sure you want to delete your account?")
                }
            }.sheet(isPresented: $showAuthView) {
                AuthView()
            }
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
