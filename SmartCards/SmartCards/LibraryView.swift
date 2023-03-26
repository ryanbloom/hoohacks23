//
//  LibraryView.swift
//  SmartCards
//
//  Created by William Wang on 3/25/23.
//

import SwiftUI

struct LibraryView: View {
    @StateObject var vm: smartCardsViewModel
    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(vm.cardList) { cards in

                        NavigationLink {
                            VStack {
                                Text("Question : \(cards.question)")
                                Text("Answer \(cards.answer)")
                            }
                        } label: {
                            Text("\(cards.answer)")
                        }
                    }
                }
            }
        }
    }
}

struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView(vm: smartCardsViewModel())
    }
}
