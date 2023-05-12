//
//  MainNavigation.swift
//  ExploreHub
//
//  Created by Vitalii Kohut on 11.05.2023.
//

import SwiftUI

struct MainNavigation: View {
    
    @State private var selection: Tab = .quiz
    enum Tab {
        case quiz
        case chat
    }
    @State private var mainTitle = "Quiz"
    
    var body: some View {
        NavigationStack {
            TabView(selection: $selection) {
                QuizView(mainTitle: $mainTitle)
                    .background(.gray.opacity(0.1))
                    .tabItem {
                        Label("Quiz", systemImage: "brain.head.profile")
                    }
                    .tag(Tab.quiz)
                ChatView(mainTitle: $mainTitle)
                    .tabItem {
                        Label("Chat", systemImage: "message.fill")
                    }
                    .tag(Tab.chat)
                    
            }
            .navigationTitle(mainTitle)
        }
    }
}

struct MainNavigation_Previews: PreviewProvider {
    static var previews: some View {
        MainNavigation()
    }
}
