//
//  InfoSetting.swift
//  Firebase-SwiftUI-AuthFlow
//
//  Created by Amel Sbaihi on 3/30/26.
//

import SwiftUI
import FirebaseAuth

struct InfoSetting: View {
    @Environment(AuthenticationManager.self) var authManager
    var body: some View {
        NavigationStack {
            ZStack{
                FluidModernBackground()
                VStack{
                    if authManager.authState == .authenticated {
                       // Link user signIn
                        Text(
                            "user: \(authManager.user?.uid ?? "Anonymous User")"
                        )
                        .font(.headline)
                        .padding()
                        
                        
                        Button {
                            // signIn
                            
                            
                        } label: {
                            HStack(spacing: 4) {
                                Text("SignIn")
                                    .font(.body.bold())
                                
                                
                            }
                            .foregroundStyle(Color.white)
                            .frame(width: 260, height: 45)
                            .background(Color.appButton)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(
                                        Color.white.opacity(0.25),
                                        lineWidth: 1
                                    )
                            )
                        }
                    }
                    
                    if authManager.authState == .signedIn {
                      // give user option to signOut.
                        VStack{
                            
                            Text(authManager.user?.displayName ?? "Name placeholder")
                                .font(.headline)
                            Text(authManager.user?.email ?? "Email placeholder")
                                .font(.subheadline)
                            //
                            
                            Button {
                               // handleSignOut()
                               
                            } label: {
                                HStack(spacing: 4) {
                                    Text("SignOut")
                                        .font(.body.bold())
                                    }
                                .foregroundStyle(Color.white)
                                .frame(width: 260, height: 45)
                                .background(Color.appButton)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(
                                            Color.white.opacity(0.25),
                                            lineWidth: 1
                                        )
                                )
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    InfoSetting()
        .environment(AuthenticationManager())
}
