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
                VStack {
                   
                    Image("lock1")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 280, height: 260)
                        .foregroundStyle(
                            Color.black.opacity(0.65)
                        )
                        .padding()
                        .background(
                                RoundedRectangle(cornerRadius: 35, style: .continuous)
                                    .fill(.ultraThinMaterial)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 35, style: .continuous)
                                    .stroke(.white.opacity(0.5), lineWidth: 1)
                            )
                            .shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: 10)
                            .padding()
                    Spacer()
                    
                    Rectangle()
                        .frame(width : 300, height: 3
                        
                        )
                        .foregroundColor(Color.black.opacity(0.3))
                    
                    // MARK: - Google Button
                    Spacer()
                    
                    GoogleSignInButton(viewModel: googleVM) {
                        Task{
                            await signInWithGoogle()
                            dismiss()
                        }
                    }
                    .frame(width: 280, height: 45)
                   
                    
                    // MARK: - Apple Button
                    
                    SignInWithAppleButton { request  in
                        AppleHelper.shared.requestAppleAuthorization(request)
                    } onCompletion: { result   in
                        handleAppleID(result)
                    }
                    .frame(width: 280, height: 45)
                    .cornerRadius(10)
                    .padding(8)
                    
                    
                    
                    // MARK: - Email Button
                    Button {
                    
                        
                    } label: {
                        HStack(spacing: 4) {
                            Text("Continue with Email")
                                .font(.body.bold())
                            
                            
                        }
                        .foregroundStyle(Color.white)
                        .frame(width: 280, height: 45)
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

                
                    // MARK: - Skip Button

                    /// Allows the user to continue as a guest by signing in anonymously via Firebase.
                    if authManager.authState == .signedOut {
                        Button {
                            Task {
                                await handleSignInAnonymously()
                            }
                        } label: {
                            Text("Skip")
                                .font(.body.bold())
                                .foregroundStyle(Color.black.opacity(0.65))
                                .frame(
                                    width: 280,
                                    height: 45,
                                    alignment: .center
                                )

                        }

                    }
                    Spacer()
                }
            }.navigationTitle("Authentication")
                .navigationBarTitleDisplayMode(.inline)
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

extension AuthView {
    
    
    func handleAppleID(_ result: Result<ASAuthorization, Error>) {
        if case let .success(authenticate) = result {
            guard let appleIDCredentials = authenticate.credential as? ASAuthorizationAppleIDCredential else {
                print("AppleAuthorization failed: AppleID credential not available")
                return
            }
            
            Task {
                do {
                    let result = try await authManager.appleAuth(
                        appleIDCredentials,
                        nonce: AppleHelper.nonce
                    )
                    if result != nil {
                        dismiss()
                    }
                } catch {
                    print("AppleAuthorization failed: \(error)")
                   // Add an error message with an alert
                }
            }
        }
        else if case let .failure(error) = result {
            print("AppleAuthorization failed: \(error)")
            // show message in alert
        }
    }
}
#Preview {
    AuthView()
        .environment(AuthenticationManager())
}
