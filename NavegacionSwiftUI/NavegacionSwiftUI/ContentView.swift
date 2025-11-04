//
//  ContentView.swift
//  NavegacionSwiftUI
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 03/11/25.
//

import SwiftUI

struct ContentView: View {
    @State private var show:Bool = false
    @State private var texto =  ""
    var body: some View {
        NavigationView {
            VStack{
                TextField("Texto",text: $texto)
                
                
                NavigationLink(destination: SegundaVista()){
                    Text("Segunda vista")
                }
                
                Button("Abrir modal"){
                    show.toggle()
                    
                }.sheet(isPresented: $show, content: {
                    ModalView(texto: texto)
                }).navigationTitle("Navegación")
                    .toolbar{
                        HStack{
                            NavigationLink(destination: SegundaVista()){
                                Image(systemName: "plus")
                            }
                            
                            NavigationLink(destination: TercerVista()){
                                Image(systemName: "camera")
                            }
                        }
                    }
            }.padding(.all)
            
        }
        
    }
}

#Preview {
    ContentView()
}


