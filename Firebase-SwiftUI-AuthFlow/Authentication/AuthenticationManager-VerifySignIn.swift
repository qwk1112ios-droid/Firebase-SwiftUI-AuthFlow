//
//  AuthenticationManager-VerifySignIn.swift
//  Firebase-SwiftUI-AuthFlow
//
//  Created by Amel Sbaihi on 4/18/26.
//

import Foundation
import FirebaseAuth
import GoogleSignIn

extension AuthenticationManager {
    private func verifyGoogleSignIn() async -> Bool {
            guard let providerData = Auth.auth().currentUser?.providerData,
                  providerData.contains(where: { $0.providerID == "google.com" }) else { return false }

            do {
              
                try await GIDSignIn.sharedInstance.restorePreviousSignIn()
                return true
            }
            catch {
                return false
            }
        }
    
    
    private func verifySignInProvider() async {
            guard let providerData = Auth.auth().currentUser?.providerData else { return }
            
            
            var isGoogleCredentialRevoked = false

            

            if providerData.contains(where: { $0.providerID == "google.com" }) {
                isGoogleCredentialRevoked = await !verifyGoogleSignIn()
            }

            
            if  isGoogleCredentialRevoked {
                if authState != .signedIn {
                    do {
                        try  self.signOut()
                    }
                    catch {
                        print("FirebaseAuthError: verifySignInProvider() failed. \(error)")
                    }
                }
            }
        }
    
     func verifyAuthTokenResult() async -> Bool {
        do {
           _ =  try await Auth.auth().currentUser?.getIDTokenResult(forcingRefresh: true)
            return true
        }
        catch {
            print("Error retrieving id token result. \(error)")
            return false
        }
    }
    
   
}
