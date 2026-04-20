//
//  AuthView.swift
//  Firebase-SwiftUI-AuthFlow
//
//  Created by Amel Sbaihi on 3/30/26.
//

import FirebaseAuth
import SwiftUI
import GoogleSignInSwift
import AuthenticationServices

struct AuthView: View {
    @Environment(AuthenticationManager.self) var authManager
    @Environment(\.dismiss) var dismiss
    
    let googleVM = GoogleSignInButtonViewModel(
        scheme: .light,   // or .dark
        style: .wide      // .standard, .icon
    )

    var body: some View {
        NavigationStack {
            ZStack {
                FluidModernBackground()
                    .ignoresSafeArea()

                VStack(spacing: 24) {
                    Spacer(minLength: 20)

                    VStack(spacing: 18) {
                        Image("cb1")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 180, height: 180)
                            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                            .shadow(color: .black.opacity(0.12), radius: 18, x: 0, y: 8)

                        VStack(spacing: 8) {
                            Text("Coffee & Books")
                                .font(.system(size: 30, weight: .bold, design: .rounded))
                                .foregroundStyle(.primary)

                            Text("Your cozy corner for coffee, books, and quiet moments.")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 16)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 12)

                    VStack(spacing: 14) {
                        GoogleSignInButton(viewModel: googleVM) {
                            Task {
                                await signInWithGoogle()
                                dismiss()
                            }
                        }
                        .frame(width: 280, height: 50)
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

                        if authManager.authState == .signedOut {
                            Button {
                                Task {
                                    await handleSignInAnonymously()
                                }
                            } label: {
                                Text("Continue as Guest")
                                    .foregroundStyle(.primary)
                                    .frame(maxWidth: .infinity)
                                    .frame(width: 280, height: 50)
                                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                                            .stroke(.white.opacity(0.45), lineWidth: 1)
                                    }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 24)

                    Spacer()
                }
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}

extension AuthView {
    //MARK: -SignIn Anonymously
    // SignInAnonymously funciton
    func handleSignInAnonymously() async {
        do {
            let result = try await authManager.signInAnonymously()
            print("SignInAnonymouslySuccess: \(result.user.uid)")
        } catch {
            print("SignInAnonymouslyError: \(error.localizedDescription)")
        }
    }
}

extension AuthView {
    // MARK: - Sign In with Google
    
    func signInWithGoogle() async {
        do {
            guard let user = try await  GoogleHelper.shared.signInWithGoogle() else {
                return
            }
            let result = try await authManager.googleAuth(user)
     
            
            print ("Google Sign In Success \(String(describing: result?.user.uid))")
        }
        catch {
            print("GoogleSignInError: failed to sign in with Google, \(error))")
                    // Here you can show error message to user.
        }
    }
}


#Preview {
    AuthView()
        .environment(AuthenticationManager())
}
