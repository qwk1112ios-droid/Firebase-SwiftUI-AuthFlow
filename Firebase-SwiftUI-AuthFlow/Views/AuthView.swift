//
//  AuthView.swift
//  Firebase-SwiftUI-AuthFlow
//
//  Created by Amel Sbaihi on 3/30/26.
//

import FirebaseAuth
import SwiftUI
import GoogleSignInSwift

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
                    // TODO: - Add Image

                    // MARK: - Google Button
                    GoogleSignInButton(viewModel: googleVM) {
                        Task{
                            await signInWithGoogle()
                            dismiss()
                        }
                    }
                    .frame(width: 260, height: 45)
                    .cornerRadius(1)
                    
                    
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
                                .foregroundStyle(Color.primaryIcon)
                                .frame(
                                    width: 280,
                                    height: 45,
                                    alignment: .center
                                )

                        }

                    }
                }
            }
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
