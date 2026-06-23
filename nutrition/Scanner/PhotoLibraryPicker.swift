import SwiftUI
import PhotosUI

// ============================================================
// PhotoLibraryPicker — SwiftUI wrapper around
// PHPickerViewController. Allows the user to pick multiple
// photos from their library in one go (selectionLimit = 0).
//
// Why not SwiftUI's PhotosPicker? Available iOS 16+ only; this
// app targets iOS 15.3.
// ============================================================
struct PhotoLibraryPicker: UIViewControllerRepresentable {

    @Environment(\.presentationMode) private var presentationMode

    // Called once with the array of picked images (possibly
    // empty if the user cancelled).
    let onPicked: ([UIImage]) -> Void


    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.filter = .images
        config.selectionLimit = 0    // 0 = unlimited
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }


    func updateUIViewController(_ uiViewController: PHPickerViewController,
                                context: Context) {
        // No reactive updates needed.
    }


    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }


    final class Coordinator: NSObject, PHPickerViewControllerDelegate {

        let parent: PhotoLibraryPicker

        init(parent: PhotoLibraryPicker) {
            self.parent = parent
        }


        // PHPicker hands back NSItemProviders we have to async-load
        // into UIImage. We collect them into a slot-indexed array
        // so the user's selection order is preserved.
        func picker(_ picker: PHPickerViewController,
                    didFinishPicking results: [PHPickerResult]) {

            // Empty selection = cancel; dismiss and report.
            guard !results.isEmpty else {
                parent.onPicked([])
                parent.presentationMode.wrappedValue.dismiss()
                return
            }

            var slots = [UIImage?](repeating: nil, count: results.count)
            // loadObject completions fire concurrently on arbitrary
            // background queues; serialize writes into the shared
            // `slots` array so two photos can't corrupt it.
            let lock = NSLock()
            let group = DispatchGroup()

            for (index, result) in results.enumerated() {
                let provider = result.itemProvider
                guard provider.canLoadObject(ofClass: UIImage.self) else { continue }
                group.enter()
                provider.loadObject(ofClass: UIImage.self) { object, _ in
                    if let image = object as? UIImage {
                        lock.lock()
                        slots[index] = image
                        lock.unlock()
                    }
                    group.leave()
                }
            }

            group.notify(queue: .main) { [weak self] in
                guard let self = self else { return }
                let images = slots.compactMap { $0 }
                self.parent.onPicked(images)
                self.parent.presentationMode.wrappedValue.dismiss()
            }
        }
    }
}
