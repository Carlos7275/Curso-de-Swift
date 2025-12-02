//
//  ContentView.swift
//  ImagenesSwiftData
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 02/12/25.
//

import SwiftData
import SwiftUI

struct ContentView: View {

    @Environment(\.modelContext) private var modelContext
    @Query private var images: [Photo]
    @State private var show: Bool = false

    var body: some View {
        NavigationStack {
            VStack {
                if images.isEmpty {
                    ContentUnavailableView("Sin imagenes", systemImage: "photo")
                } else {
                    List {
                        ForEach(images) {
                            image in
                            CardPhoto(item: image).swipeActions {
                                Button(role: .destructive) {
                                    withAnimation {
                                        modelContext.delete(image)
                                    }
                                } label: {
                                    Image(systemName: "trash")
                                }
                            }
                        }.listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)

                    }.shadow(color: Color.black, radius: 4, x: 3, y: 2)
                        .listStyle(.plain)
                        .scrollContentBackground(.hidden)
                        .background(Color.white)
                }

            }.padding(.all)
                .navigationTitle("Images Data")
                .toolbar {
                    ToolbarItem {
                        Button {
                            show.toggle()
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }.sheet(isPresented: $show) {
                    NavigationStack {
                        AddPhoto()
                    }
                }
        }
    }
}

#Preview {
    ContentView().modelContainer(for: Photo.self, inMemory: true)
}
