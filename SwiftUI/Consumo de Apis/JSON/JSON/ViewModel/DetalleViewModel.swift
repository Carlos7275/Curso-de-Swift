//
//  DetalleViewModel.swift
//  JSON
//
//  Created by Jorge Maldonado Borbón on 05/01/21.
//

import Foundation

class DetalleViewModel: ObservableObject {
    
    @Published var first_name = ""
    @Published var email = ""
    @Published var avatar = ""
    
    func fetch(id: Int){
        guard let url = URL(string: "https://reqres.in/api/users/\(id)") else { return  }
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("reqres-free-v1", forHTTPHeaderField: "x-api-key")
        URLSession.shared.dataTask(with: url){data,_,_ in
            
            guard let data = data else { return }
            do{
                let json = try JSONDecoder().decode(User.self, from: data)
                DispatchQueue.main.async {
                    self.first_name = json.data.first_name
                    self.email = json.data.email
                    self.avatar = json.data.avatar
                }
            }catch let error as NSError{
                print("Error en el json", error.localizedDescription)
            }
            
        }.resume()
    }
}
