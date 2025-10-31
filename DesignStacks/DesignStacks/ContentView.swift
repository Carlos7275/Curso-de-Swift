//
//  ContentView.swift
//  DesignStacks
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 30/10/25.
//

import SwiftUI

let numero = "6682566496"
let mensaje = "Hola Como estas"

func sendMessage(){
    let sms = "sms:\(numero)&body=\(mensaje)"
    UIApplication.shared.open(URL(string: sms)!)
}

func sendCall(){
    guard let number  = URL(string:"tel://\(numero)") else{ return}
    
    UIApplication.shared.open(number)
        
}
struct ContentView: View {
    
    //Valores de entorno o EnviromentValues
    //En las nuevas versiones de IOS se recomienda usar vertical y en las anteriores horizontalSizeClass
    @Environment(\.verticalSizeClass)  var sizeClass
    
    var body: some View {
        (sizeClass == .compact ?
         AnyView(compactDesign()) :
            AnyView(regularDesign())
        )
    }
}


struct compactDesign:View {
    var body: some View {
        ZStack{
            Color.mint.edgesIgnoringSafeArea(.all)
            VStack(){
                Image("Image")
                    .resizable()
                    .frame(width: 130,height: 100,alignment: .center)
                    .clipShape(Circle())
                
                Text("Carlos Sandoval").font(.largeTitle).foregroundStyle(.white)
                    .bold()
                Text("FullStack Dev").foregroundColor(.white)
                    .font(.subheadline).italic()
                
                HStack(){
                    Button(action:{
                        sendCall()
                    }){
                        Image(systemName: "phone.fill").modifier(boton(color:.blue))
                    }
                    
                    Button(action:{
                        sendMessage()
                    }){
                        Image(systemName: "message.fill").modifier(boton(color: .red))
                    }
                }
            }
        }
    }
}

struct regularDesign:View {
    var body: some View {
        ZStack{
            Color.mint.edgesIgnoringSafeArea(.all)
            HStack(){
                Image("Image")
                    .resizable()
                    .frame(width: 130,height: 130,alignment: .center)
                    .clipShape(Circle())
                
                VStack(alignment: .leading,spacing: 10){
                    Text("Carlos Sandoval").font(.largeTitle).foregroundStyle(.white)
                        .bold()
                    Text("FullStack Dev").foregroundColor(.white)
                        .font(.subheadline).italic()
                 
                    HStack(){
                        Button(action:{
                            sendCall()
                        }){
                            Image(systemName: "phone.fill").modifier(boton(color: .blue))
                                
                        }
                        
                        Button(action:{
                            sendMessage()
                        }){
                            Image(systemName: "message.fill").modifier(boton(color:.red))
                        }
                    }
                }
            }
        }
    }
}

struct boton:ViewModifier{
    var color:Color
    func body(content: Content) -> some View {
        content .padding()
            .background(color)
            .clipShape(Circle())
            .foregroundColor(.white)
            .font(.title)
        
    }
}

#Preview {
    ContentView()
}
