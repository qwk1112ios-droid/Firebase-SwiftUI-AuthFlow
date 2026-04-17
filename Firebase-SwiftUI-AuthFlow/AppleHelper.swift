//
//  AppleHelper.swift
//  Firebase-SwiftUI-AuthFlow
//
//  Created by Amel Sbaihi on 4/14/26.
//

import AuthenticationServices
import CryptoKit
import Foundation

class AppleHelper : NSObject {
    static let shared = AppleHelper()
    fileprivate static var currentNonce: String?

    static var nonce: String? {
        currentNonce ?? nil

    }
    private var continuation : CheckedContinuation<ASAuthorizationAppleIDCredential, Error>?
     override init() {
    }

    func requestAppleAuthorization(_ request: ASAuthorizationAppleIDRequest) {
        AppleHelper.currentNonce = generateRandomNonce()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(AppleHelper.currentNonce!)
        
        
    }
    
    func requestAppleAuthorization() async throws -> ASAuthorizationAppleIDCredential {
        return try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
            
            // 1. create request
            let appleIdProvider = ASAuthorizationAppleIDProvider()
            let request = appleIdProvider.createRequest()
            // 2. configure request
                requestAppleAuthorization(request)
            // 3. Controller handles request
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            // 4. AppleHelper becomes delegate to handle result
                        authorizationController.delegate = self
            // 5. perform reques
                        authorizationController.performRequests()
        }
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

extension AppleHelper: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if case let appleIDCredential as ASAuthorizationAppleIDCredential = authorization.credential {
            continuation?.resume(returning: appleIDCredential)
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        continuation?.resume(throwing: error)
    }
}
