//
//  TextRecognizer.swift
//  EscaneoQR
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 19/11/25.
//

import Foundation
import Vision
import VisionKit

class TextRecognizer {

    let cameraScan: VNDocumentCameraScan

    init(cameraScan: VNDocumentCameraScan) {
        self.cameraScan = cameraScan
    }

    func recognizerText(completionHandler: @escaping ([String]) -> Void) {

        DispatchQueue.main.async {
            let image = (0..<self.cameraScan.pageCount).compactMap({
                self.cameraScan.imageOfPage(at: $0).cgImage
            })

            let imageRequest = image.map({
                (image: $0, request: VNRecognizeTextRequest())
            })

            let textPage = imageRequest.map {
                image,
                request -> String in
                let handler = VNImageRequestHandler(
                    cgImage: image,
                    options: [:]
                )
                do {
                    try handler.perform([request])
                    guard let observation = request.results else {
                        return ""
                    }
                    return observation.compactMap(
                        {
                            $0.topCandidates(1).first?.string
                        }
                    ).joined(separator: "\n")

                } catch let error as NSError {
                    print(
                        "Error al reconocer texto: \(error.localizedDescription)"
                    )
                    return ""
                }
            }
            completionHandler(textPage)

        }
    }
}
