import Foundation
import Flutter

public class LocalDataProtectionHandler {
    public static let channelName = "com.offlinequotes.mobile/platform_data_protection"

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: channelName, binaryMessenger: registrar.messenger())
        channel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
            guard let args = call.arguments as? [String: Any],
                  let paths = args["paths"] as? [String] else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing paths parameter", details: nil))
                return
            }

            switch call.method {
            case "apply":
                do {
                    for path in paths {
                        try applyProtection(to: path)
                    }
                    result(true)
                } catch {
                    result(FlutterError(code: "PROTECTION_APPLY_FAILED", message: error.localizedDescription, details: nil))
                }
            case "verify":
                do {
                    var allVerified = true
                    for path in paths {
                        if !verifyProtection(for: path) {
                            allVerified = false
                            break
                        }
                    }
                    result(allVerified)
                } catch {
                    result(FlutterError(code: "PROTECTION_VERIFY_FAILED", message: error.localizedDescription, details: nil))
                }
            default:
                result(FlutterMethodNotImplemented)
            }
        }
    }

    private static func applyProtection(to path: String) throws {
        var url = URL(fileURLWithPath: path)
        let fileManager = FileManager.default

        // If file or directory exists, apply URL resource values and file protection attributes
        if fileManager.fileExists(atPath: path) {
            var resourceValues = URLResourceValues()
            resourceValues.isExcludedFromBackup = true
            try url.setResourceValues(resourceValues)

            let attributes: [FileAttributeKey: Any] = [
                .protectionKey: FileProtectionType.completeUntilFirstUserAuthentication
            ]
            try fileManager.setAttributes(attributes, ofItemAtPath: path)
        }
    }

    private static func verifyProtection(for path: String) -> Bool {
        let url = URL(fileURLWithPath: path)
        let fileManager = FileManager.default

        guard fileManager.fileExists(atPath: path) else {
            return false
        }

        do {
            let values = try url.resourceValues(forKeys: [.isExcludedFromBackupKey])
            guard values.isExcludedFromBackup == true else {
                return false
            }

            let attributes = try fileManager.attributesOfItem(atPath: path)
            guard let protection = attributes[.protectionKey] as? FileProtectionType,
                  protection == .completeUntilFirstUserAuthentication else {
                return false
            }

            return true
        } catch {
            return false
        }
    }
}
