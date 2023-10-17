//
//  ContentView.swift
//  CardGame
//
//  Created by Marie Mensing on 11.06.23.
//

import SwiftUI

struct ContentView: View {
        // Array<String> is the same as [String]
        //    let contentArray: Array<String> = ["🔥", "🗿"]
        //    let contentArray: [String] = ["🔥", "🗿"]
    // but no need for specifing here
    let emos = ["🔥", "🗿", "🌙", "🍆", "🚨", "💿", "💊", "💙", "✅", "⚠️", "👾", "🧢", "🐙", "🌏"]
    
//    @State var emosCount = 14
    @State var emosCount = 8
    
    var body: some View {
        VStack {
            ScrollView {
            
                // amount of "GridItems()" is amount of coloumns
                // is a function, cause stuff can get specified in them
                // adaptive -> adjusts minimum width of each card that should fit in the row
                // makes sure that also in horizontal phone holding, there are as many cards as possible and not to a fixed size
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 65))]) {
                    // emos[0..<6] syntax for a range
                    ForEach(emos[0..<emosCount], id: \.self) { em in
                        CardView(content: em).aspectRatio(2/3, contentMode: .fit)
                    }
                }
            }
            Divider()
            Spacer()
                            
            HStack {
                remove  // self writte remove func
                Spacer()
                add     // self writte add  func
            } .padding(.horizontal).font(.largeTitle)

        }
        .padding(.horizontal)
        .foregroundColor(Color("AccentColor"))
    }
    
    // creating functions to make code smoler
    var add: some View {
        Button(action: {
            if emosCount < emos.count {
                emosCount += 1
            }
        }, label: {
                Image(systemName: "plus.square")
        })
    }
    var remove: some View {
        Button(action: {
            if emosCount > 1 {
                emosCount -= 1
            }
        }, label: {
                Image(systemName: "minus.square")
        })
    }
}

struct CardView: View {
    // @State is a pointer to the variable, makes it changeable
    @State var isFaceUp: Bool = false
    
    var content: String
    var body: some View {
        
        ZStack {
            let shape = RoundedRectangle(cornerRadius: 10)
            
            if isFaceUp {   //front of the card
                shape.fill()
                    .foregroundColor(Color(hue: 0.107, saturation: 0.0, brightness: 0.8))
                // keyword stroke is drawing line around the actual element
                // instead strokeBorder itself is the border
                shape.strokeBorder(lineWidth: 4)
                Text(content)
                    
//                    .font(.largeTitle)
            } else {    // back of the card
                shape.fill()
                    .foregroundColor(Color("AccentColor"))
//                    .font(.largeTitle)
            }
        }
        .onTapGesture {
            // switching bool state to the opposite
//            isFaceUp = !isFaceUp
            isFaceUp.toggle()
        }
    }
}

struct ContentView_Preview: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.light)
        ContentView()
            .preferredColorScheme(.dark)
    }
}
