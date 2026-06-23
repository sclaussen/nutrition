import SwiftUI

// ============================================================
// HamburgerMenu — a reusable toolbar entry point (a
// `line.3.horizontal` button) that opens a menu of app-level
// actions. Drop `HamburgerMenu()` into any toolbar.
//
// Today it carries:
//   * Configure GitHub token\u{2026}  — presents TokenConfigSheet
//   * Refresh data               — runs ConfigSync.refresh()
//
// It's structured as a Menu with Sections so the orchestrator
// can later move the existing header buttons (gear / scanner /
// cost) under it by adding items to a new section — no plumbing
// changes required. All presentation state (sheet, refreshing
// flag, result alert) is kept self-contained here.
// ============================================================
struct HamburgerMenu: View {

    @State private var showTokenSheet = false
    @State private var isRefreshing = false
    @State private var refreshAlert: RefreshAlert? = nil


    var body: some View {
        Menu {
            Section {
                Button {
                    showTokenSheet = true
                } label: {
                    Label("Configure GitHub token\u{2026}", systemImage: "key")
                }

                Button {
                    refresh()
                } label: {
                    if isRefreshing {
                        Label("Refreshing\u{2026}", systemImage: "arrow.triangle.2.circlepath")
                    } else {
                        Label("Refresh data", systemImage: "arrow.triangle.2.circlepath")
                    }
                }
                  .disabled(isRefreshing)
            }

            // Future section: the orchestrator will relocate the
            // gear / scanner / cost header buttons here.
        } label: {
            Image(systemName: "line.3.horizontal")
              .foregroundColor(Color.theme.blueYellow)
        }
          .sheet(isPresented: $showTokenSheet) {
              TokenConfigSheet()
          }
          .alert(item: $refreshAlert) { alert in
              Alert(title: Text(alert.title),
                    message: Text(alert.message),
                    dismissButton: .default(Text("OK")))
          }
    }


    // ============================================================
    // Refresh — kicks ConfigSync.refresh() off the main actor,
    // flips the in-progress flag, and surfaces the outcome as an
    // alert. Reference (dangling-link) errors are rendered as a
    // readable list so the user knows exactly what to fix in
    // nutrition-config.
    // ============================================================
    private func refresh() {
        guard !isRefreshing else { return }
        isRefreshing = true

        Task {
            let alert: RefreshAlert
            do {
                let result = try await ConfigSync.refresh()
                switch result {
                case .applied(let summary):
                    alert = RefreshAlert(title: "Refresh complete", message: summary)
                case .upToDate:
                    alert = RefreshAlert(title: "Up to date",
                                         message: "Already up to date.")
                }
            } catch let error as ConfigSyncError {
                alert = RefreshAlert(title: "Refresh failed",
                                     message: Self.message(for: error))
            } catch {
                alert = RefreshAlert(title: "Refresh failed",
                                     message: error.localizedDescription)
            }

            await MainActor.run {
                isRefreshing = false
                refreshAlert = alert
            }
        }
    }


    // Render a ConfigSyncError for the alert. referenceErrors are the
    // dangling-reference failures the user must fix in nutrition-config,
    // so we list them one per line rather than collapsing to a sentence.
    private static func message(for error: ConfigSyncError) -> String {
        switch error {
        case .referenceErrors(let problems):
            let list = problems.map { "\u{2022} \($0)" }.joined(separator: "\n")
            return "Unresolved references in nutrition-config:\n\(list)"
        default:
            return error.localizedDescription
        }
    }
}


// Identifiable wrapper so we can drive `.alert(item:)`.
private struct RefreshAlert: Identifiable {
    let id = UUID()
    let title: String
    let message: String
}
