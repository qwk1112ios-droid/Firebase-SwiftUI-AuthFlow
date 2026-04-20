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
            ZStack {
                FluidModernBackground()
                    .ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        Spacer(minLength: 12)

                        Image("cb1")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 190, height: 190)
                            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                            .shadow(color: .black.opacity(0.12), radius: 18, x: 0, y: 8)
                            .padding(.top, 16)

                        if authManager.authState == .authenticated {
                            VStack(spacing: 10) {
                                Text("Become a Coffee & Books member")
                                    .font(.title3.weight(.semibold))
                                    .multilineTextAlignment(.center)

                                Text("Sign in to save your account and unlock the full experience.")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                    .multilineTextAlignment(.center)
                            }
                            .padding(.horizontal, 24)

                            Button {
                                showAuthView = true
                            } label: {
                                Text("Sign In")
                                    .font(.headline)
                                    .foregroundStyle(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 52)
                                    .background(Color.appButton, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                                            .stroke(Color.white.opacity(0.25), lineWidth: 1)
                                    }
                            }
                            .buttonStyle(.plain)
                            .padding(.horizontal, 24)
                        }

                        if authManager.authState == .signedIn {
                            VStack(spacing: 20) {
                                VStack(spacing: 6) {
                                    Text(authManager.user?.displayName ?? "Coffee & Books Member")
                                        .font(.title3.weight(.semibold))
                                        .multilineTextAlignment(.center)

                                    Text(authManager.user?.email ?? "Email not available")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                        .multilineTextAlignment(.center)
                                }

                                VStack(spacing: 12) {
                                    Button {
                                        handleSignOut()
                                    } label: {
                                        Text("Sign Out")
                                            .font(.headline)
                                            .foregroundStyle(.white)
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 52)
                                            .background(Color.appButton, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                                            .overlay {
                                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                                    .stroke(Color.white.opacity(0.25), lineWidth: 1)
                                            }
                                    }
                                    .buttonStyle(.plain)

                                    Button {
                                        showDeleteAccountAlert = true
                                    } label: {
                                        Text("Delete Account")
                                            .font(.headline)
                                            .foregroundStyle(.red)
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 52)
                                            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                                            .overlay {
                                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                                    .stroke(Color.red.opacity(0.25), lineWidth: 1)
                                            }
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(24)
                            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 28, style: .continuous))
                            .overlay {
                                RoundedRectangle(cornerRadius: 28, style: .continuous)
                                    .stroke(.white.opacity(0.35), lineWidth: 1)
                            }
                            .padding(.horizontal, 24)
                        }

                        Spacer(minLength: 40)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .toolbar(.hidden, for: .navigationBar)
            .confirmationDialog("Delete Account", isPresented: $showDeleteAccountAlert) {
                Button("Yes, Delete Account", role: .destructive) {
                    Task {
                        do {
                            try await authManager.deleteAccount()
                        } catch AuthErrors.ReauthenticateGoogle {
                            // Google re-authentication failed
                        } catch AuthErrors.RevokeGoogle {
                            // Google token revocation failed
                        } catch {
                            // Show generic error message
                        }
                    }
                }
            } message: {
                Text("Deleting your account is permanent. Are you sure you want to continue?")
            }
            .sheet(isPresented: $showAuthView) {
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
