//
//  ContentView.swift
//  temp
//
//  Created by Marie Mensing on 10/12/23.
//

import SwiftUI

struct ContentView : View {
    @ObservedObject var viewModel = ViewModel()
    var body: some View {
        VStack {
            Circle()
                .frame(width: 100, height: 100, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            Text(viewModel.textLabelValue)
            Button("get weather", action: {
                viewModel.buttonDidPressed()
            })
            Spacer()
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
