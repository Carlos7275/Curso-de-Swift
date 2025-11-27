//
//  ImportCSV.swift
//  ReportesApp
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 27/11/25.
//

import Combine
import CoreData
import Foundation
import PDFKit
import SwiftUI

class UtilData: ObservableObject {
    @Published var errorMessage = ""
    @Published var showError: Bool = false
    @Published var loading = false

    var autosRepository: CoreDataRepository<Autos>

    init(context: NSManagedObjectContext) {
        autosRepository = CoreDataRepository<Autos>(modelName: "ReportesApp")
        self.autosRepository.setContext(context)
    }

    func importarDatosCSV(fileURL: URL) {
        loading = true
        defer { loading = false }

        do {

            let data = try String(contentsOf: fileURL, encoding: .utf8)

            // Filas separadas por salto de línea, ignorando líneas vacías
            let filas =
                data
                .components(separatedBy: .newlines)
                .filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }

            // Si la primera fila es encabezado, la saltamos
            let filasProcesadas: ArraySlice<String>
            if let first = filas.first, first.lowercased().contains("marca") {
                filasProcesadas = filas.dropFirst()
            } else {
                filasProcesadas = ArraySlice(filas)
            }

            for fila in filasProcesadas {
                let columnas = fila.components(separatedBy: ",")

                guard columnas.count >= 4 else {
                    print("Fila inválida: \(fila)")
                    continue
                }

                // Crear auto seguro
                let auto = try autosRepository.create()
                auto.id = columnas[0].trimmingCharacters(in: .whitespaces)
                auto.marca = columnas[1].trimmingCharacters(in: .whitespaces)
                auto.modelo = columnas[2].trimmingCharacters(in: .whitespaces)
                auto.color = columnas[3].trimmingCharacters(in: .whitespaces)
            }

            try autosRepository.save()

        } catch {
            showError = true
            errorMessage = error.localizedDescription
        }
    }

    func exportarCSV() -> URL? {
        do {
            let datos = try autosRepository.fetch()

            let fileName = "autos_export.csv"
            let url = URL(fileURLWithPath: NSTemporaryDirectory())
                .appendingPathComponent(fileName)

            var csvText = "id,marca,modelo,color\n"

            for auto in datos {
                let id = sanitize(auto.id)
                let marca = sanitize(auto.marca)
                let modelo = sanitize(auto.modelo)
                let color = sanitize(auto.color)

                let line = "\(id),\(marca),\(modelo),\(color)\n"
                csvText.append(line)
            }

            try csvText.write(to: url, atomically: true, encoding: .utf8)
            return url

        } catch {
            showError = true
            errorMessage = error.localizedDescription
            return nil
        }
    }

    /// Limpia valores nulos y protege el CSV de comas / saltos de línea
    private func sanitize(_ value: String?) -> String {
        guard
            let value = value?.trimmingCharacters(in: .whitespacesAndNewlines),
            !value.isEmpty
        else {
            return ""
        }

        // Si contiene comas o saltos de línea → envolver entre comillas
        if value.contains(",") || value.contains("\n") {
            return "\"\(value.replacingOccurrences(of: "\"", with: "\"\""))\""
        }

        return value
    }

    func exportarHTML() -> URL? {
        do {
            let datos = try autosRepository.fetch()

            let fileName = "autos_export.html"
            let url = URL(fileURLWithPath: NSTemporaryDirectory())
                .appendingPathComponent(fileName)

            var content = """
                <!DOCTYPE html>
                <html>
                <head>
                    <meta charset="utf-8">
                    <title>Listado de Autos</title>
                    <style>
                        body { font-family: -apple-system, Helvetica, Arial; padding: 20px; }
                        h1 { color: #333; }
                        ul { list-style: none; padding: 0; }
                        li {
                            padding: 10px;
                            background: #f7f7f7;
                            margin-bottom: 8px;
                            border-radius: 8px;
                        }
                    </style>
                </head>
                <body>
                <h1>Listado de Autos</h1>
                <ul>
                """

            for auto in datos {
                let marca = htmlEscape(auto.marca)
                let modelo = htmlEscape(auto.modelo)
                let color = htmlEscape(auto.color)

                content += "<li>\(marca) \(modelo) - \(color)</li>\n"
            }

            content += """
                </ul>
                </body>
                </html>
                """

            try content.write(to: url, atomically: true, encoding: .utf8)
            return url

        } catch {
            showError = true
            errorMessage = error.localizedDescription
            return nil
        }
    }

    /// Escapa caracteres peligrosos de HTML (&, <, >, ", ')
    private func htmlEscape(_ value: String?) -> String {
        guard let text = value else { return "N/A" }
        var escaped = text
        escaped = escaped.replacingOccurrences(of: "&", with: "&amp;")
        escaped = escaped.replacingOccurrences(of: "<", with: "&lt;")
        escaped = escaped.replacingOccurrences(of: ">", with: "&gt;")
        escaped = escaped.replacingOccurrences(of: "\"", with: "&quot;")
        escaped = escaped.replacingOccurrences(of: "'", with: "&#39;")
        return escaped
    }

    func exportarPDF() -> URL? {
        do {
            let datos = try autosRepository.fetch()

            let renderer = ImageRenderer(
                content: VStack {
                    Text("Listado de Autos")
                    ForEach(datos) { auto in
                        HStack {
                            Text(
                                "\(auto.marca ?? "N/A") • \(auto.modelo ?? "N/A") • \(auto.color ?? "N/A")"
                            )
                        }
                    }
                }
            )
            let url = URL.documentsDirectory.appending(path: "reporte.pdf")
            renderer.render {
                size,
                context in
                var box = CGRect(
                    x: 0,
                    y: 0,
                    width: size.width,
                    height: size.height
                )

                guard let pdf = CGContext(url as CFURL, mediaBox: &box, nil)
                else { return }
                pdf.beginPDFPage(nil)
                context(pdf)
                pdf.endPDFPage()
                pdf.closePDF()

            }
            return url

        } catch let error as NSError {
            errorMessage = error.localizedDescription
            showError = true
            return nil
        }
    }

}
