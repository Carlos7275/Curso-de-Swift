//
//  ContentView.swift
//  NovedadesIOS16
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 19/11/25.
//

import SwiftUI

struct ContentView: View {
    @State private var renderImage: Image?
    @State private var renderPDF: URL?
    @State private var show = false

    func render() {
        let renderer = ImageRenderer(content: ScreenShotView())

        if let image = renderer.uiImage {
            renderImage = Image(uiImage: image)
        }

        let tmpUrl = FileManager.default.urls(
            for: .cachesDirectory,
            in: .userDomainMask
        )[0]

        let renderURL = tmpUrl.appending(path: "\(UUID().uuidString).pdf")

        if let consumer = CGDataConsumer(url: renderURL as CFURL),
            let context = CGContext(consumer: consumer, mediaBox: nil, nil)
        {
            renderer.render { size, renderer in
                var mediaBox = CGRect(origin: .zero, size: size)
                context.beginPage(mediaBox: &mediaBox)

                renderer(context)
                context.endPDFPage()
                context.closePDF()

                renderPDF = renderURL

            }
        }

    }

    var body: some View {
        NavigationStack {
            VStack {
                ScreenShotView()
            }.toolbar {
                HStack {
                    if let renderImage {
                        ShareLink(
                            item: renderImage,
                            preview: SharePreview("Transferencia")
                        )
                    }

                    //                    if let renderPDF {
                    //                        ShareLink(
                    //                            item: renderPDF,
                    //                            preview: SharePreview("Transferencia")
                    //                        ) {
                    //                            Image(systemName: "arrow.up.doc")
                    //                        }
                    //
                    //                    }

                    if let _ = renderPDF {
                        Button {
                            show.toggle()
                        } label: {
                            Image(systemName: "arrow.up.doc")
                        }
                    }
                }
            }.onAppear {
                DispatchQueue.main.async {
                    render()
                }
            }.sheet(isPresented: $show) {
                if let renderPDF {
                    ShareSheet(items: [renderPDF])
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
