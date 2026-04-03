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
    
    func updateDisplayName(for user: User) async {
        if let currentDisplayName = Auth.auth().currentUser?.displayName,
            !currentDisplayName.isEmpty
        {
            // don't do any thing
        } else {
            let providerName = user.providerData.first?.displayName
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = providerName
            do {
                try await changeRequest.commitChanges()
            } catch {
                print(
                    "FirebaseAuthError: Failed to update the user's displayName. \(error.localizedDescription)"
                )
            }

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
    func googleAuth(_ user : GIDGoogleUser) async throws -> AuthDataResult?{
       guard let idToken = user.idToken?.tokenString  else {
            return nil
        }
        // create credential from token
        let credential = GoogleAuthProvider.credential(
            withIDToken: idToken,
            accessToken: user.accessToken.tokenString
          
        )

        do {
            return try await authenticateUser(credential: credential)
        } catch {
            print("FirebaseAuthError: googleAuth(user:) failed. \(error)")
            throw error
        }


    }
}

extension AuthenticationManager {

    // MARK: - Credential Auth
    /// Authenticate User
    func authenticateUser(credential: AuthCredential) async throws
        -> AuthDataResult
    {
        if Auth.auth().currentUser != nil {
            return try await authLink(with: credential)!
        } else {
            return try await authSignIn(with: credential)
        }
    }
    /// if anonymously signed in then link to provider account
    func authLink(with credentials: AuthCredential) async throws
        -> AuthDataResult?
    {
        do {
            guard let user = Auth.auth().currentUser else { return nil }
            let result = try await user.link(with: credentials)
             await updateDisplayName(for: result.user)
            updateState(for: result.user)
            return result
        } catch {
            print("FirebaseAuthError: signIn(with:) failed. \(error)")
            throw error
        }
    }
    /// else just signe In provider User to firebase
    func authSignIn(with credentials: AuthCredential) async throws
        -> AuthDataResult
    {

        do {
            let result = try await Auth.auth().signIn(with: credentials)
             updateState(for: result.user)
            return result
        } catch {
            print("FirebaseAuthError: signIn(with:) failed. \(error)")
            throw error
        }

    }
}
