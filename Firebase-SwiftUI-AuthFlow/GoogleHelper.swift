//
//  GoogleHelper.swift
//  Firebase-SwiftUI-AuthFlow
//
//  Created by Amel Sbaihi on 3/30/26.
//

import Foundation
import GoogleSignIn

class GoogleHelper {
    static let shared = GoogleHelper()
    private init () {
        
    }
    
    @MainActor
    func signInWithGoogle() async throws -> GIDGoogleUser?  {
        if GIDSignIn.sharedInstance.hasPreviousSignIn() {
          return try await  GIDSignIn.sharedInstance.restorePreviousSignIn ()
        }
        else {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return nil }
            guard let rootViewController = windowScene.windows.first?.rootViewController else { return nil }

            // 3.
            let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
            return result.user
        }
    }
}
