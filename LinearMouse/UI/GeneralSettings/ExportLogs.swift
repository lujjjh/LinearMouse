// MIT License
// Copyright (c) 2021-2023 Jiahao Lu

import OSLog
import SwiftUI

struct ExportLogs: View {
    private let logExportDispatchQueue = DispatchQueue(label: "log-export")
    @State private var exporting = false

    var body: some View {
        Section {
            VStack(alignment: .leading) {
                Text("Export the logs for the last 5 minutes.")
                Text("If you are reporting a bug, it would be helpful to attach the logs.")
                    .controlSize(.small)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Button("Export logs") {
                exportLogs()
            }
            .disabled(exporting)
        }
    }
}

extension ExportLogs {
    private func level(_ level: OSLogEntryLog.Level) -> String {
        switch level {
        case .undefined:
            return "undefined"
        case .debug:
            return "debug"
        case .info:
            return "info"
        case .notice:
            return "notice"
        case .error:
            return "error"
        case .fault:
            return "fault"
        default:
            return "level:\(level.rawValue)"
        }
    }

    func exportLogs() {
        logExportDispatchQueue.async {
            exporting = true
            defer { exporting = false }

            do {
                let logStore = try OSLogStore.local()
                let position = logStore.position(timeIntervalSinceEnd: -5 * 60)
                let predicate = NSPredicate(format: "subsystem == '\(LinearMouse.appBundleIdentifier)'")
                let entries = try logStore.getEntries(with: [],
                                                      at: position,
                                                      matching: predicate)
                let logs = entries
                    .compactMap { $0 as? OSLogEntryLog }
                    .filter { $0.subsystem == LinearMouse.appBundleIdentifier }
                    .suffix(100_000)
                    .map { "\($0.date)\t\(level($0.level))\t\($0.category)\t\($0.composedMessage)\n" }
                    .joined(separator: "")

                let directory = FileManager.default.temporaryDirectory.appendingPathComponent(
                    UUID().uuidString,
                    isDirectory: true
                )
                try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
                let filePath = directory.appendingPathComponent("\(LinearMouse.appName).log")
                try logs.write(to: filePath, atomically: true, encoding: .utf8)
                NSWorkspace.shared.activateFileViewerSelecting([filePath.absoluteURL])
            } catch {
                DispatchQueue.main.async {
                    let alert = NSAlert(error: error)
                    alert.runModal()
                }
            }
        }
    }
}
