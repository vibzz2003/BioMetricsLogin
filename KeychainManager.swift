//
// ///////////////////////////////////////////////////////////////////////////////////////
//
//
//  All rights reserved by OneBanc. Redistribution or use, is strictly prohibited
//
//
//  Copyright © 2025 OneBanc Technologies Private Ltd.  https://onebanc.ai/
//
//
// ///////////////////////////////////////////////////////////////////////////////////////
    
import Foundation
import Security

final class KeychainManager {
    static let shared = KeychainManager()
    private init() {}
    
    func Save(key: String, value: Data) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: value
        ]
        SecItemDelete(query as CFDictionary)
        return SecItemAdd(query as CFDictionary, nil) == errSecSuccess
    }
    
    func Load(key: String) -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnData as String: kCFBooleanTrue!
        ]
        var dataRef: AnyObject?
        if SecItemCopyMatching(query as CFDictionary, &dataRef) == errSecSuccess {
            return dataRef as? Data
        }
        return nil
    }
    
    func Delete(key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        SecItemDelete(query as CFDictionary)
    }
}
