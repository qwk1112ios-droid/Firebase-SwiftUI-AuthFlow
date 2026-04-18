//
//  AuthenticationManager-DeleteAccount.swift
//  Firebase-SwiftUI-AuthFlow
//
//  Created by Amel Sbaihi on 4/18/26.
//

import Foundation
import FirebaseAuth
import GoogleSignIn

enum AuthErrors: Error {
   
    case ReauthenticateGoogle
    case RevokeGoogle
}


extension AuthenticationManager {
    func deleteAccount ()  async throws -> Void {
        
        guard let  user = Auth.auth().currentUser ,
        let lastSignInDate = user.metadata.lastSignInDate else { return }
        let needsReAuth = !lastSignInDate.isWithinPast(minutes: 5)
        let providers = user.providerData.map { $0.providerID }

        do {
            if providers.contains("google.com") {
                
                if needsReAuth {
                    try await reauthenticateGoogleAccount(for: user)
                }
               try await revokeGoogleToken()
            }
            try await user.delete()
                    
            updateState(for: user)
            self.authState = .signedOut 
        }
        catch {
            print("FirebaseAuthError: Failed to delete auth user. \(error)")
            throw error
        }
        
    }
    
    
    private func reauthenticateGoogleAccount(for user: User) async throws {
            do {
                
                guard let googleUser = try await GoogleHelper.shared.signInWithGoogle() else {
                    return
                }
                guard let idToken = googleUser.idToken?.tokenString else { return }
                
                let credential = GoogleAuthProvider.credential(
                    withIDToken: idToken,
                    accessToken: googleUser.accessToken.tokenString
                )
                try await user.reauthenticate(with: credential)
            }
            catch {
                throw AuthErrors.ReauthenticateGoogle
            }
        }
    
    func revokeGoogleToken() async throws {
           do {
               try await GIDSignIn.sharedInstance.disconnect()
           }
           catch {
               throw AuthErrors.RevokeGoogle
           }
       }
        
        
}

extension Date {
    func isWithinPast(minutes: Int) -> Bool {
        let now = Date.now
        let timeAgo = Date.now.addingTimeInterval(-1 * TimeInterval(60 * minutes))
        let range = timeAgo...now
        return range.contains(self)
    }
}
