//
//  AccountCard.swift
//  Firebase-SwiftUI-AuthFlow
//
//  Created by Amel Sbaihi on 4/22/26.
//

import SwiftUI

struct AccountRow: View {
    let icon: String
    let title: String
    var isDestructive: Bool = false

    var body: some View {
        HStack(spacing: 12) {
            
            Image(systemName: icon)
                .frame(width: 28, height: 28)
                .foregroundStyle(isDestructive ? .red : .primary)
            
            Text(title)
                .foregroundStyle(isDestructive ? .red : .primary)

            Spacer()

            Image(systemName: "chevron.right")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .frame(height: 44)
    }
}

struct AccountCard: View {
    let name: String
    let email: String
    let onSignOut: () -> Void
    let onDeleteAccount: () -> Void
    
    
    var body: some View {
        VStack(spacing: 16){
            HStack(spacing: 16) {
                Image("cb1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                    )
                VStack(alignment: .leading , spacing: 4) {
                  Text(name)
                        .font(.headline)
                        
                    Text(email)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer ()
            }
            
            Divider()
            VStack{
                Button {
                 onSignOut()
                } label: {
                    AccountRow(icon:  "arrow.right.square", title: "SignOut", isDestructive: false)
                }
                Divider()
                Button {
                   onDeleteAccount()
                }
                label: {
                    AccountRow(icon: "trash",title: "Delete Account", isDestructive: true )

            }
                
            }
        } .padding(20)
            .background(RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(.ultraThinMaterial)
)

            .overlay(RoundedRectangle(cornerRadius: 24)
                            .stroke(.white.opacity(0.3), lineWidth: 1)
            )
                    .padding(.horizontal, 20)

    }
    
}

#Preview {
    AccountCard(name: "Amel", email: "Amel@cb1.com" ,onSignOut: {}, onDeleteAccount: {})
}
