import Foundation
import Security

// One-item Keychain wrapper holding the user's Anthropic API key.
//
// Why Keychain (not UserDefaults): the rest of the app stores ingredient
// data in UserDefaults, but a third-party API key is a credential — it
// belongs in the Keychain so it's encrypted at rest, survives reinstall,
// and never lands in iCloud Backup as plain text.
//
// We use a single account string (`anthropic-api-key`) under one service
// (`com.sclaussen.nutrition`). If we ever add a second key (OpenAI, etc.)
// we just add another `account` string.
enum KeychainStore {

    private static let service = "com.sclaussen.nutrition"
    private static let anthropicAccount = "anthropic-api-key"


    static func anthropicKey() -> String? {
        return read(account: anthropicAccount)
    }


    static func setAnthropicKey(_ value: String) {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            delete(account: anthropicAccount)
        } else {
            write(account: anthropicAccount, value: trimmed)
        }
    }


    // ============================================================
    // Internals
    // ============================================================

    private static func baseQuery(account: String) -> [String: Any] {
        return [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
    }


    private static func read(account: String) -> String? {
        var query = baseQuery(account: account)
        query[kSecReturnData as String] = true
        query[kSecMatchLimit as String] = kSecMatchLimitOne

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status == errSecSuccess,
              let data = item as? Data,
              let value = String(data: data, encoding: .utf8) else {
            return nil
        }
        return value
    }


    // Write-or-update: SecItemAdd fails with errSecDuplicateItem if the
    // key already exists, in which case we fall through to SecItemUpdate.
    private static func write(account: String, value: String) {
        let data = Data(value.utf8)
        var query = baseQuery(account: account)
        query[kSecValueData as String] = data
        // Stay on-device: don't sync to iCloud Keychain.
        query[kSecAttrAccessible as String] = kSecAttrAccessibleAfterFirstUnlock

        let addStatus = SecItemAdd(query as CFDictionary, nil)
        if addStatus == errSecDuplicateItem {
            let update: [String: Any] = [kSecValueData as String: data]
            SecItemUpdate(baseQuery(account: account) as CFDictionary,
                          update as CFDictionary)
        }
    }


    private static func delete(account: String) {
        SecItemDelete(baseQuery(account: account) as CFDictionary)
    }
}
