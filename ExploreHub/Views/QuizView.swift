//
//  QuizView.swift
//  ExploreHub
//
//  Created by Vitalii Kohut on 11.05.2023.
//

import SwiftUI

struct QuizView: View {
    @Binding var mainTitle : String

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .onAppear {
                mainTitle = "Quiz"
            }
    }
}

struct QuizView_Previews: PreviewProvider {
    static var previews: some View {
        QuizView(mainTitle: .constant("Quiz"))
    }
}
