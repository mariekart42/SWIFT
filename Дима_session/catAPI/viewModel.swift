//
//  viewModel.swift
//  temp
//
//  Created by Marie Mensing on 10/12/23.
//

import Foundation
import SwiftUI

class ViewModel : ObservableObject {
    @Published var textLabelValue : String = "nothing"
    var catDTO : CatFactDTO? {
        didSet {
            guard let dto = catDTO,
                  let string = dto.fact else {return}
            self.textLabelValue = string
        }
    }
}

