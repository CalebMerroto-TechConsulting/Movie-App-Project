//
//  LabelVal.swift
//  Movie-App-Project
//
//  Created by Caleb Merroto on 3/26/25.
//

import SwiftUI

struct LabelVal: View {
    let label: String
    let value: String

    init(_ label: String, _ value: String) {
        self.label = label
        self.value = value
    }

    var body: some View {
        HStack(alignment: .top) {
            Text("\(label):")
                .fontWeight(.bold)
                .multilineTextAlignment(.leading)
            Text(value)
                .multilineTextAlignment(.leading)
            Spacer()
        }
    }
}

#Preview {
    LabelVal("Rated", "PG-13")
}
