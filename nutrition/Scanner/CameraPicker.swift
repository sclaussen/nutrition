import SwiftUI
import UIKit

// ============================================================
// CameraPicker — SwiftUI wrapper around UIImagePickerController
// configured for a single camera capture. We use this rather
// than PhotosPicker because the deployment target is iOS 15.3,
// which predates SwiftUI's native camera support.
//
// Library picking is handled separately by PhotoLibraryPicker
// (PHPickerViewController), which supports multi-select.
// ============================================================
struct CameraPicker: UIViewControllerRepresentable {

    @Environment(\.presentationMode) private var presentationMode

    // Called once with the captured image, or with nil if the
    // user cancels. The host sheet uses this to append to its
    // images array (or do nothing on cancel).
    let onPicked: (UIImage?) -> Void


    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        // Camera may be unavailable (Simulator). Fall back to
        // photoLibrary so the picker still presents — the host
        // disables the "Add from camera" button when the camera
        // isn't available, but defense-in-depth here is cheap.
        picker.sourceType = UIImagePickerController.isSourceTypeAvailable(.camera)
            ? .camera : .photoLibrary
        picker.delegate = context.coordinator
        picker.allowsEditing = false
        return picker
    }


    func updateUIViewController(_ uiViewController: UIImagePickerController,
                                context: Context) {
        // No reactive updates needed.
    }


    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }


    final class Coordinator: NSObject,
                             UIImagePickerControllerDelegate,
                             UINavigationControllerDelegate {

        let parent: CameraPicker

        init(parent: CameraPicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            let image = info[.originalImage] as? UIImage
            parent.onPicked(image)
            parent.presentationMode.wrappedValue.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.onPicked(nil)
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
