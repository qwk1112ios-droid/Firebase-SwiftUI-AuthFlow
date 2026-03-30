//
//  RootView.swift
//  Firebase-SwiftUI-AuthFlow
//
//  Created by Amel Sbaihi on 3/29/26.
//

import SwiftUI

struct RootView: View {
    @Environment(AuthenticationManager.self) var authManager
    var body: some View {
        if authManager.authState == .signedOut {
           AuthView()
        }
        else {
            InfoSetting()
        }
    }
}

#Preview {
    RootView()
        .environment(AuthenticationManager())
}
