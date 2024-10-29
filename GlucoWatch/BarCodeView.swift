//
//  BarCodeView.swift
//  CalcXE
//
//  Created by Genuine on 08.02.2024.
// take from Companion App (Bar Code examples )

import SwiftUI
import VisionKit

@available(iOS 16.0, *)
struct BarCodeView: View {
    
//VNBarcodeSymbologyEAN13
    
    @State var item : String = ""
    @State var recognizedItems: [RecognizedItem] = []
   
  //  var item : RecognizedItem.Barcode = .payloadStringValue

    var body: some View {
        DataScannerViewRepresentable(
            shouldCapturePhoto: .constant(false),
            capturedPhoto: .constant(nil),
            recognizedItems: $recognizedItems,
            scanResult: $item,
            recognizedDataType: .barcode(),
            recognizesMultipleItems: false)
            
    }
}
//```
//```swift

@available(iOS 16.0, *)
struct DataScannerViewRepresentable: UIViewControllerRepresentable {
    
    @Binding var shouldCapturePhoto: Bool
    @Binding var capturedPhoto: IdentifiableImage?
    @Binding var recognizedItems: [RecognizedItem]
    @Binding var scanResult: String
   
    let recognizedDataType: DataScannerViewController.RecognizedDataType
    let recognizesMultipleItems: Bool
    
    func makeUIViewController(context: Context) -> DataScannerViewController {
        let vc = DataScannerViewController(
            recognizedDataTypes: [recognizedDataType],
            qualityLevel: .balanced,
            recognizesMultipleItems: recognizesMultipleItems,
            isGuidanceEnabled: true,
            isHighlightingEnabled: true
        )
        return vc
    }
    
    func updateUIViewController(_ uiViewController: DataScannerViewController, context: Context) {
        uiViewController.delegate = context.coordinator
        try? uiViewController.startScanning()
        if shouldCapturePhoto {
            capturePhoto(dataScannerVC: uiViewController)
        }
    }
    
    private func capturePhoto(dataScannerVC: DataScannerViewController) {
        Task { @MainActor in
            do {
                let photo = try await dataScannerVC.capturePhoto()
                self.capturedPhoto = .init(image: photo)
            } catch {
                print(error.localizedDescription)
            }
            self.shouldCapturePhoto = false
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(recognizedItems: $recognizedItems, scanResult: $scanResult)
    }
    
    static func dismantleUIViewController(_ uiViewController: DataScannerViewController, coordinator: Coordinator) {
        uiViewController.stopScanning()
    }
}
//```
//```swift
@available(iOS 16.0, *)
class Coordinator: NSObject, DataScannerViewControllerDelegate,ObservableObject {
    
    @Binding var recognizedItems: [RecognizedItem]
    @Binding var scanResult: String
    
    init(recognizedItems: Binding<[RecognizedItem]>,scanResult: Binding<String>) {
        self._recognizedItems = recognizedItems
        self._scanResult = scanResult
    }
    
    func dataScanner(_ dataScanner: DataScannerViewController, didTapOn item: RecognizedItem) {
        print("didTapOn \(item)")
        switch item {
        case .barcode(let code) :
            scanResult = code.payloadStringValue!   
            print("CODE \(scanResult)")
            
        case .text(let text):
            print(text)
        @unknown default:
            print("default")
        }
    }
    
    func dataScanner(_ dataScanner: DataScannerViewController, didAdd addedItems: [RecognizedItem], allItems: [RecognizedItem]) {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        recognizedItems.append(contentsOf: addedItems)
        print("didAddItems \(addedItems)")

      
        
    }
    
    func dataScanner(_ dataScanner: DataScannerViewController, didRemove removedItems: [RecognizedItem], allItems: [RecognizedItem]) {
        self.recognizedItems = recognizedItems.filter { item in
            !removedItems.contains(where: {$0.id == item.id })
            
        }
        print("didRemovedItems \(removedItems)")
    }
    
    func dataScanner(_ dataScanner: DataScannerViewController, becameUnavailableWithError error: DataScannerViewController.ScanningUnavailable) {
        print("became unavailable with error \(error.localizedDescription)")
    }
}
//```
//```swift
struct IdentifiableImage: Identifiable {
    let id = UUID()
    let image: UIImage
}
//```
