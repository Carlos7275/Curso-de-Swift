import SwiftUI

extension CardType {
    @ViewBuilder
    var logo: some View {
        switch self {
        case .visa:
            Image("visa")
                .resizable()
                .scaledToFit()
                .frame(height: 48)

        case .mastercard:
            Image("mastercard")
                .resizable()
                .scaledToFit()
                .frame(height: 48)

        case .amex:
            Image("amex")
                .resizable()
                .scaledToFit()
                .frame(height: 64)
        }
    }
}
