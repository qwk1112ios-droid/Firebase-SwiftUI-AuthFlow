//
//  AppleHelper.swift
//  Firebase-SwiftUI-AuthFlow
//
//  Created by Amel Sbaihi on 4/14/26.
//

import AuthenticationServices
import CryptoKit
import Foundation

class AppleHelper {
    static let shared = AppleHelper()
    fileprivate static var currentNonce: String?

    static var nonce: String? {
        currentNonce ?? nil

    }
    private init() {
    }

    func requestAppleAuthorization(_ request: ASAuthorizationAppleIDRequest) {
        AppleHelper.currentNonce = generateRandomNonce()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(AppleHelper.currentNonce!)
    }

}

extension AppleHelper {
    func generateRandomNonce(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(
            kSecRandomDefault,
            randomBytes.count,
            &randomBytes
        )
        if errorCode != errSecSuccess {
            fatalError(
                "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
        }

        let charset: [Character] =
            Array(
                "0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._"
            )

        let nonce = randomBytes.map { byte in

            charset[Int(byte) % charset.count]
        }

        return String(nonce)
    }

    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()

        return hashString
    }
}
