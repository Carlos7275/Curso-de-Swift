//
//  ContentView.swift
//  SwiftData-ImportExport
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 03/12/25.
//

import SwiftData
import SwiftUI

struct ContentView: View {

    @Environment(IMCViewModel.self) var imcViewModel
    @Environment(\.modelContext) var context
    var body: some View {
        @Bindable var vm = imcViewModel
        NavigationStack {
            VStack {
                Text(vm.resIMC).font(.title).bold()
                TextField("Nombre", text: $vm.nombre).textFieldStyle(
                    RoundedBorderTextFieldStyle()
                )
                TextField("Altura", text: $vm.altura)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                TextField("Peso", text: $vm.peso)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                HStack {
                    Button(
                        action: {
                            vm.resIMC = vm.calcularIMC()
                        },
                        label: {
                            Text("Calcular").bold()
                        }
                    ).buttonStyle(.borderedProminent).tint(.green)

                    Button(
                        action: {
                            vm.limpiarCampos()
                        },
                        label: {
                            Text("Limpiar").bold()
                        }
                    ).buttonStyle(.borderedProminent).tint(.red)

                    Button(
                        action: {
                            withAnimation {
                                context.insert(
                                    IMC(
                                        nombre: imcViewModel.nombre,
                                        imc: imcViewModel.resIMC
                                    )
                                )
                                vm.limpiarCampos()

                            }

                        },
                        label: {
                            Text("Guardar").bold()
                        }
                    ).buttonStyle(.borderedProminent).tint(.blue)

                }
                Spacer()
            }.navigationTitle("Calcular IMC")
                .padding(.all)
                .toolbar {
                    NavigationLink(destination: DataView()) {
                        Image(systemName: "book.pages.fill")
                    }
                }
        }
    }
}

#Preview {
    ContentView()
}
