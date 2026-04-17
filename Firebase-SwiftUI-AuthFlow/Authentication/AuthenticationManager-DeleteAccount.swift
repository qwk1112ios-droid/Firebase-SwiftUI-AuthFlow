//
//  AuthenticationManager-DeleteAccount.swift
//  Firebase-SwiftUI-AuthFlow
//
//  Created by Amel Sbaihi on 4/16/26.
//

import Foundation
import FirebaseAuth
import AuthenticationServices
import GoogleSignIn

enum AuthErrors: Error {
    case ReauthenticateApple
    case ReauthenticateGoogle
    case RevokeAppleID
    case RevokeGoogle
}

extension AuthenticationManager {
    
    // delete Account
    func deleteUserAccount() async throws {
        guard let user = Auth.auth().currentUser,
        let lastSignInDate = user.metadata.lastSignInDate else { return }
        let needsReAuth = !lastSignInDate.isWithinPast(minutes: 5)
                
        let providers = user.providerData.map { $0.providerID }
        
        do {
            if providers.contains("apple.com") {
                let appleIDCredential = try await AppleHelper.shared.requestAppleAuthorization()
                
                
                if needsReAuth {
                    // re- auth with apple
                    try await reauthenticateAppleID(appleIDCredential,for: user)
                }
                
                // Revoke AppleID
                try await  revokeAppleIdToken(appleIDCredential)
            }
            
            if providers.contains("google.com") {
                            
                            if needsReAuth {
                                //Re-authenticate Google Account
                                try await reauthenticateGoogleAccount(for: user)
                            }
                            try await  revokeGoogleToken()
                        }
            
            try await user.delete()
            // updateState(for: user)
            self.authState = .signedOut 
        } catch {
            print("FirebaseAuthError: Failed to delete auth user. \(error)")
            throw error
        }
    }
    
    // re-authenticate with apple ID
    
    private func reauthenticateAppleID(
        _ appleIDCredential: ASAuthorizationAppleIDCredential,
        for user: User
    ) async throws {
        do {
            // 1.
            guard let appleIDToken = appleIDCredential.identityToken else { return }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else { return }
            guard  let nonce = AppleHelper.nonce else {return}
            // 2.
            let credentials = OAuthProvider.appleCredential(withIDToken: idTokenString, rawNonce: nonce, fullName: appleIDCredential.fullName)
            try await user.reauthenticate(with: credentials)
        }
        catch {
            throw AuthErrors.ReauthenticateApple
        }
    }
    
    // re-authenticate with Google
    
    private func reauthenticateGoogleAccount(for user: User) async throws {
        do {
            // 1.
            guard let googleUser = try await GoogleHelper.shared.signInWithGoogle() else {
                return
            }
            guard let idToken = googleUser.idToken?.tokenString else { return }
            // 2.
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
    
    // revoke Token
    // apple ID
    
    func revokeAppleIdToken(_ appleIDCredentials: ASAuthorizationAppleIDCredential) async throws {
       guard let authorizationCode = appleIDCredentials.authorizationCode else { return }
       guard let authorizationCodeString = String(data: authorizationCode, encoding: .utf8) else { return }
       
       do{
           try await Auth.auth().revokeToken(withAuthorizationCode: authorizationCodeString)
       }
       catch {
           throw AuthErrors.RevokeAppleID
       }
   }
    
    // google
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
