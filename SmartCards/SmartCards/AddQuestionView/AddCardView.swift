//
//  ContentView.swift
//  SmartCards
//
//  Created by William Wang on 3/25/23.
//

import SwiftUI

@MainActor
struct AddCardView: View {
    @StateObject var vm: smartCardsViewModel
    @FocusState private var nameIsFocused: Bool
    @State var tempList: [smartCard] = []
    
    var body: some View {
        NavigationStack {
            List {
                Image("AddCardPhoto")
                    .resizable()
                    .scaledToFit()
                
                Section("TERM") {
                    TextField("Enter Term here", text: $vm.questionText)
                        .focused($nameIsFocused)
                }
                Section("Answer") {
                    TextField("Enter Answer Here!", text: $vm.answerText)
                        .focused($nameIsFocused)
                    Button {
                        tempList = []
                        vm.cardsNotKnownTotal += 1
                        vm.cardsTotal += 1
                        vm.cardList.append(smartCard(question: vm.questionText, answer: vm.answerText))
                        nameIsFocused = false
                            
                    } label: {
                        Text("Manually Create Smartcard")
                    }
                }
                
                Section("I'm Feeling Lucky") {
                    Button {
                        tempList = []
                        if vm.questionText != "" {
                            for _ in 1 ... 3 { tempList.append(smartCard(question: vm.questionText, answer: vm.AIGenerate(prompt: vm.questionText)))
                            }
                        }
                        nameIsFocused = false
                  
                    } label: {
                        Text("Let AI Create the question!")
                    }
                }
                
                Section("AI Generated Responses") {
                    ForEach(tempList, id: \.self) { card in
                        
                        Button {
                            vm.cardsTotal += 1
                            vm.cardsNotKnownTotal += 1
                            vm.cardList.append(smartCard(question: vm.questionText, answer: card.answer))
                        } label: {
                            Text(card.answer.trimmingCharacters(in: .whitespacesAndNewlines))
                        }
                        
                        .listRowBackground(Color.white)
                    }
                }
            }
        }
    }
}
    
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        AddCardView(vm: smartCardsViewModel())
    }
}
