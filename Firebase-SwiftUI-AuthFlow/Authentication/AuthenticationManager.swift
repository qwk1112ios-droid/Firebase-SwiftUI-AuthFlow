//
//  AuthenticationManager.swift
//  Firebase-SwiftUI-AuthFlow
//
//  Created by Amel Sbaihi on 3/29/26.
//

import FirebaseAuth
import Foundation
import GoogleSignIn

enum AuthState {
    case authenticated  /// Anonymously SignedIn
    case signedIn       /// email&password or with provider
    case signedOut      /// not signedIn or authenticated
}

@MainActor
@Observable class AuthenticationManager {
    var authState: AuthState = .signedOut
    var user: User?
    var handleListener: AuthStateDidChangeListenerHandle!

    init() {
        ConfigurationAuthStateChange()
    }

}

extension AuthenticationManager {
    // MARK: - Authentication State Listener
    
    /// Observes Firebase authentication state changes and updates the app session accordingly.
    func ConfigurationAuthStateChange() {
        handleListener = Auth.auth().addStateDidChangeListener { auth, user in
            print(
                "user \(user, default: "user is nil") status have been updated."
            )
            self.updateState(for: user)
        }
    }
    /// Updates the authentication state based on the current Firebase user.
    ///
    /// - Parameter user: The current Firebase user, or nil if the user is signed out.
    func updateState(for user: User?) {
        self.user = user
        let isUserAuthenticated = user != nil
        let isAnonymous = user?.isAnonymous ?? false
        if isUserAuthenticated {
            self.authState = isAnonymous ? .authenticated : .signedIn
        } else {
            self.authState = .signedOut

        }
    }
}

extension AuthenticationManager {

    // MARK: - Anonymous Authentication

    /// Initiates anonymous authentication with Firebase and
    /// returns the authenticated user result.
    func signInAnonymously() async throws -> AuthDataResult {
        let result = try await Auth.auth().signInAnonymously()
        print(
            "FirebaseAuthSuccess: Sign in anonymously, UID: \(result.user.uid)"
        )
        return result
    }
}

extension AuthenticationManager {

    // MARK: - SignOut
    
    /// SignOut Function
    func signOut() throws {
        if Auth.auth().currentUser != nil {
            do {
                // TODO: Sign out from signed-in Provider.
                try Auth.auth().signOut()
            } catch let error as NSError {
                print(
                    "FirebaseAuthError: failed to sign out from Firebase, \(error)"
                )
                throw error
            }
        }
    }
}

extension AuthenticationManager {
    
    //MARK: Authenticate with Google provider
    
    /// gets google provider user
    ///
    /// - parameter user: google provider user
    func googleAuth(_ user : GIDGoogleUser) async throws{
       guard let idToken = user.idToken?.tokenString  else {
           // return nil
           print("err")
           return
        }
        // create credential from token
        let credential = GoogleAuthProvider.credential(
            withIDToken: idToken,
            accessToken: user.accessToken.tokenString
          
        )

        // authenticate user

    }
}
