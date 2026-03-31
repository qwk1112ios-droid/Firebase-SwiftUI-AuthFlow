//
//  Firebase_SwiftUI_AuthFlowApp.swift
//  Firebase-SwiftUI-AuthFlow
//
//  Created by Amel Sbaihi on 3/29/26.
//

import SwiftUI
import Firebase
import GoogleSignIn

@main
struct Firebase_SwiftUI_AuthFlowApp: App {
    @State var authManager: AuthenticationManager
    init () {
        FirebaseApp.configure()
        if let clientID = FirebaseApp.app()?.options.clientID {
                    GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: clientID)
                } else {
                    assertionFailure("Missing Firebase clientID. Check GoogleService-Info.plist target membership.")
                }
        _authManager = State(initialValue: AuthenticationManager())
    }
    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(authManager)
            
        }
    }
}
