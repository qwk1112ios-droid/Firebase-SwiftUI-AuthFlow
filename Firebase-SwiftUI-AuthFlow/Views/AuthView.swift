//
//  AuthView.swift
//  Firebase-SwiftUI-AuthFlow
//
//  Created by Amel Sbaihi on 3/30/26.
//

import SwiftUI

struct AuthView: View {
    @Environment(AuthenticationManager.self) var authManager
    var body: some View {
        NavigationStack {
            ZStack{
                FluidModernBackground()
                VStack{
                    // AddImage
                    
                    //Skip button
                    
                    if authManager.authState == .signedOut {
                        Button {
                            authManager.authState = .authenticated
                        } label: {
                            Text("Skip")
                                .font(.body.bold())
                                .foregroundStyle(Color.primaryIcon)
                                .frame(
                                    width: 280,
                                    height: 45,
                                    alignment: .center
                                )

                        }

                    }
                }
            }
        }
    }
}

#Preview {
    AuthView()
        .environment (AuthenticationManager())
}
