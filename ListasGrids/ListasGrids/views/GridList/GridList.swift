//
//  GridList.swift
//  ListasGrids
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 03/11/25.
//

import SwiftUI

struct GridList: View {

    //    let gridItem = [
    //        GridItem(.flexible()),
    //        GridItem(.flexible())]

    //    let gridItem :[GridItem] = Array(repeating: .init(.flexible(maximum:80)), count:2)

    @ObservedObject var gridObj = Columnas()

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(
                    columns: gridObj.gridItem,
                    spacing: 30,
                    content: {
                        ForEach(lista) { item in
                            Text(item.emoji).font(.system(size: 80))

                        }
                    }
                )
            }
            .navigationBarTitle("Grid List")
            .toolbar {
                ToolbarItem {
                    Menu("Opciones") {
                        Section {
                            ForEach(1...5, id: \.self) { i in
                                Button("\(i) Columna", systemImage: "grid") {
                                    gridObj.columnas(num: i)
                                }

                            }
                            Button(
                                "Eliminar preferencias",
                                systemImage: "trash"
                            ) {
                                UserDefaults.standard.removeObject(
                                    forKey: "columnas"
                                )
                                gridObj.columnas(num: 1)
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    GridList()
}
