import SwiftUI

struct ContentView: View {
    
    let name = "Carlos Fernando Sandoval Lizarraga"
    let birthDay = DateComponents(year: 2001, month: 2, day: 14)
    let height: Double = 1.72
    let career = "Software Engineer"
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    
                    Image("me")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 200, height: 200)
                        .clipShape(Circle())
                        .overlay(
                            Circle().stroke(Color.gray, lineWidth: 1)
                        )
                        .shadow(radius: 5)
                    
                    Text(name)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Age:")
                                .fontWeight(.semibold)
                            Spacer()
                            Text("\(DateUtils.calculateAge(birthDay: birthDay)) years")
                        }
                        
                        HStack {
                            Text("Birth Date:")
                                .fontWeight(.semibold)
                            Spacer()
                            Text(
                                Calendar.current.date(from: birthDay)
                                    .map { DateFormatter.localizedString(from: $0, dateStyle: .long, timeStyle: .none) } ?? ""
                            )
                        }
                        
                        HStack {
                            Text("Height:")
                                .fontWeight(.semibold)
                            Spacer()
                            Text("\(height, specifier: "%.2f") m")
                        }
                        
                        HStack {
                            Text("Profession:")
                                .fontWeight(.semibold)
                            Spacer()
                            Text(career)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 3)
                    .padding(.horizontal, 35)
                    
                    
                    Spacer()
                }
                .padding(.top, 50)
            }
            .navigationTitle("About Me")
            .padding()
        
            
            
        }
    }
}


#Preview {
    ContentView()
}
