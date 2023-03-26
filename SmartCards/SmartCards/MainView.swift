//
//  MainView.swift
//  SmartCards
//
//  Created by William Wang on 3/25/23.
//

import SwiftUI

struct MainView: View {
    @StateObject var vm = smartCardsViewModel()

    var body: some View {
        TabView {
            AddCardView(vm: vm)
                .tabItem {
                    Label("Create smartCard", systemImage: "plus")
                }
            LibraryView(vm: vm)
                .tabItem {
                    Label("Library", systemImage: "folder.fill")
                }
            FlashCard(vm: vm)
                .tabItem {
                    Label("Flash Cards", systemImage: "menucard")
                }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
