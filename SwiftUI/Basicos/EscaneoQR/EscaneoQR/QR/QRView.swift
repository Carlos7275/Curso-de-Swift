//
//  QRView.swift
//  EscaneoQR
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 19/11/25.
//

internal import AVFoundation
import CodeScanner
import SwiftUI

struct QRView: View {
    @State private var showScanner: Bool = false
    @State private var qrText = "Escanear QR"

    func scanQRCode(result: Result<ScanResult, ScanError>) {
        showScanner = false
        switch result {
        case .success(let result):
            let details = result.string.components(separatedBy: "")
            qrText = details[0]
        case .failure(let error):
            print("Fallo el escaneo", error.localizedDescription)
        }
    }

    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                Button {
                    showScanner = true
                } label: {
                    Text("Escanear")
                }.sheet(isPresented: $showScanner) {
                    CodeScannerView(codeTypes: [.qr], completion: scanQRCode)
                }
                Text(qrText)
            }.navigationTitle("Escanear QR")
        }
    }
}
