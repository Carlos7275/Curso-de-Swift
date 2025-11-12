import Foundation

class Calculadora {
    func evaluar(_ expresion: String) -> Double {
        let exp = expresion
            .replacingOccurrences(of: "×", with: "*")
            .replacingOccurrences(of: "x", with: "*")
            .replacingOccurrences(of: "÷", with: "/")
            .replacingOccurrences(of: "%", with: "*0.01")

        let regex = try! NSRegularExpression(pattern: #"/\s*0(\.0*)?([^\d]|$)"#)
        if regex.firstMatch(in: exp, range: NSRange(exp.startIndex..., in: exp)) != nil {
            return Double.infinity
        }

        let expr = NSExpression(format: exp)
        if let resultado = expr.expressionValue(with: nil, context: nil) as? Double {
            return resultado
        }
        return 0
    }
}
