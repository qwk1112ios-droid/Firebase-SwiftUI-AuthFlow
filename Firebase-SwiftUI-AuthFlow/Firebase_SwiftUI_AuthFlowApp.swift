//
//  Firebase_SwiftUI_AuthFlowApp.swift
//  Firebase-SwiftUI-AuthFlow
//
//  Created by Amel Sbaihi on 3/29/26.
//

import SwiftUI
import Firebase

@main
struct Firebase_SwiftUI_AuthFlowApp: App {
    @State var authManager: AuthenticationManager
    init () {
        FirebaseApp.configure()
        _authManager = State(initialValue: AuthenticationManager())
    }
    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(authManager)
            
        }
    }
}
