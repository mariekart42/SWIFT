
import SwiftUI

struct ContentViewEx01: View
{
    var body: some View
    {
        GeometryReader { geometry in
            HStack
            {
                Button(action: {
                    print("button 1")
                }, label: {
                    Text("Button 1")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue.opacity(0.6))
                        .cornerRadius(69)
                        .frame(width: geometry.size.width * 0.4, height: geometry.size.width * 0.4) // Adjust button size dynamically
                })
                
                Button(action: {
                    print("button 2")
                }, label: {
                    Text("Button 2")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.red.opacity(0.6))
                        .cornerRadius(69)
                        .frame(width: geometry.size.width * 0.4, height: geometry.size.width * 0.4) // Adjust button size dynamically
                })
                .padding()
            }
        }
    }
}
