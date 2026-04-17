//
//  AuthenticationManager-Verification.swift
//  Firebase-SwiftUI-AuthFlow
//
//  Created by Amel Sbaihi on 4/17/26.
//

import Foundation
import AuthenticationServices
import GoogleSignIn
import FirebaseAuth
import FirebaseFirestore

extension AuthenticationManager {
    
    private func verifyAppleSignIn() async  -> Bool {
     let appleProvider = ASAuthorizationAppleIDProvider()
        guard let providerData = Auth.auth().currentUser?.providerData , let applePorivderData = providerData.first(where: {$0.providerID == "apple.com"}) else {
            return false
        }
        do {
            let credentialState = try await appleProvider.credentialState(forUserID: applePorivderData.uid)
            return credentialState != .revoked && credentialState != .notFound
        }
        
        catch {
           return false
        }
    }

    func verifyProviderSignIn() async {
       guard let providerData = Auth.auth().currentUser?.providerData else {
           return
       }
       var isAppleAuthorizationCodeRevoked: Bool = false
       var isGoogleAuthorizationCodeRevoked: Bool = false
       
       if providerData.contains(where: { $0.providerID == "apple.com"}) {
           isAppleAuthorizationCodeRevoked = await verifyAppleSignIn()
       }
       if providerData.contains(where: { $0.providerID == "google.com"}) {
           isGoogleAuthorizationCodeRevoked = await verifyAppleSignIn()
       }
       
       if isAppleAuthorizationCodeRevoked && isGoogleAuthorizationCodeRevoked {
        
           if authState != .signedOut{
               do{
                   try self.signOut()
                   authState = .signedOut
               }
               catch {
                   print("Error signing out: \(error)")
               }
           }
       }
   }
    
    func verifyAuthTokenResult() async -> Bool {
       do {
           try await Auth.auth().currentUser?.getIDTokenResult(forcingRefresh: true)
           return true
       }
       catch {
           print("Error retrieving id token result. \(error)")
           return false
       }
   }
}



extension AuthenticationManager {
    // MARK: - Get User from DB
    func getUserDocument(_ user: User) async throws -> Bool {
        let userDocumentReference = db.collection("users").document(user.uid)
        let document = try await userDocumentReference.getDocument()

        guard document.exists else {
            throw FirestoreError.documentDoesNotExist
        }

        return true
    }
}
