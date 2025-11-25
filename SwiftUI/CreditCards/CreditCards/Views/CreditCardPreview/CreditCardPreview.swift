import SwiftUI

struct CreditCardPreview: View {
    let data: PreviewCardData
    var isDetail: Bool = false
    var isClipboardEnabled: Bool = true

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        colors: data.type.gradient,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(radius: 6)

            VStack(alignment: .leading, spacing: 12) {

                // Logo según el tipo
                HStack {
                    data.type.logo
                    Spacer()
                }
                .padding(.top, 4)

                Spacer()

                Text(data.number)
                    .font(.title3.monospaced())
                    .bold()
                    .foregroundColor(.white)

                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("CREDIT")
                            .font(.caption2)
                            .foregroundColor(.white.opacity(0.6))

                        Text(String(data.credit))
                            .font(.caption)
                            .foregroundColor(.white)
                    }

                    Spacer()

                    Image(systemName: "wave.3.right.circle.fill")
                        .font(.title2)
                        .foregroundColor(.white.opacity(0.9))
                }

                Text(data.name)
                    .font(.headline)
                    .foregroundColor(.white)

                HStack {
                    Spacer()
                    // Flecha de detalle abajo a la derecha
                    if isDetail {
                        Image(systemName: "chevron.right.circle.fill")
                            .font(.title2)
                            .foregroundColor(.white.opacity(0.9))
                    }
                }
            }
            .padding(20)

            // MARK: - Botón Clipboard en la esquina superior derecha
            if isClipboardEnabled {
                VStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            let clipboardText = """
                              \(data.name) - \(data.number) - \(data.credit) - \(data.type.rawValue)
                              """
                              UIPasteboard.general.string = clipboardText
                        }) {
                            Image(systemName: "doc.on.doc.fill")
                                .font(.title2)
                                .foregroundColor(.white.opacity(0.9))
                                .padding(8)
                                .background(Color.black.opacity(0.3))
                                .clipShape(Circle())
                        }
                    }
                    Spacer()
                }
                .padding(12)
            }
        }
        .frame(height: 180)
    }
}
