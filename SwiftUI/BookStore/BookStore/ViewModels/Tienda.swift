//
//  Tienda.swift
//  BookStore
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 14/11/25.
//

import Combine
import Foundation
import StoreKit

typealias FetchCompleteHandler = (([SKProduct]) -> Void)
typealias PurchasesCompleteHandler = ((SKPaymentTransaction) -> Void)
class Tienda: NSObject, ObservableObject {

    @Published var libros = [Libros]()

    private let todosIdentificadores = Set([
        "com.carlos.BookStore.CodigoDaVinci",
        "com.carlos.BookStore.harrypoter1",
        "com.carlos.BookStore.fullAccess",
    ])

    private var comprasCompletas = [String]() {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }

                for indice in self.libros.indices {
                    self.libros[indice].bloqueo = !self.comprasCompletas
                        .contains(self.libros[indice].id)
                }
            }
        }
    }

    private var productosSolicitados: SKProductsRequest?
    private var fetchProductos = [SKProduct]()
    private var fetchCompleteHandler: FetchCompleteHandler?
    private var purchasesCompleteHandler: PurchasesCompleteHandler?

    override init() {
        super.init()
        startObserverPayment()
        fetchProductos {
            productos in
            self.libros = productos.map { Libros(product: $0) }
        }

    }

    func startObserverPayment() {
        SKPaymentQueue.default().add(self)
    }

    private func fetchProductos(_ completion: @escaping FetchCompleteHandler) {
        guard self.productosSolicitados == nil else { return }
        self.fetchCompleteHandler = completion
        productosSolicitados = SKProductsRequest(
            productIdentifiers: todosIdentificadores
        )

        productosSolicitados?.delegate = self
        productosSolicitados?.start()
    }

    private func buy(
        _ product: SKProduct,
        _ completion: @escaping PurchasesCompleteHandler
    ) {
        purchasesCompleteHandler = completion
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }

}

extension Tienda: SKProductsRequestDelegate {
    func productsRequest(
        _ request: SKProductsRequest,
        didReceive response: SKProductsResponse
    ) {
        let productosCargados = response.products
        let invalidProduct = response.invalidProductIdentifiers
        guard !productosCargados.isEmpty else {

            productosSolicitados = nil
            return

        }

        fetchProductos = productosCargados
        DispatchQueue.main.async {
            self.fetchCompleteHandler?(productosCargados)
            self.fetchCompleteHandler = nil
            self.productosSolicitados = nil
        }

    }

}

extension Tienda: SKPaymentTransactionObserver {
    func paymentQueue(
        _ queue: SKPaymentQueue,
        updatedTransactions transactions: [SKPaymentTransaction]
    ) {
        for transaction in transactions {
            var finishTransaction = false
            switch transaction.transactionState {
            case .purchased, .restored:
                comprasCompletas.append(transaction.payment.productIdentifier)
                finishTransaction = true
            case .failed:
                finishTransaction = true
                break
            case .purchasing, .deferred:
                break

            @unknown default:
                break
            }

            if finishTransaction {
                SKPaymentQueue.default().finishTransaction(transaction)
                DispatchQueue.main.async {
                    self.purchasesCompleteHandler?(transaction)
                    self.purchasesCompleteHandler = nil
                }
            }
        }

    }

}

extension Tienda {
    func producto(for identifier: String) -> SKProduct? {
        return fetchProductos.first(where: {
            $0.productIdentifier == identifier
        })
    }

    func comprarProducto(producto: SKProduct) {
        startObserverPayment()
        buy(producto) { _ in }
    }

    func restablecerCompra() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}
