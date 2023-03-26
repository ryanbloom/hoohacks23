//
//  FlashCard.swift
//  SmartCards
//
//  Created by William Wang on 3/25/23.
//

import SwiftUI

struct FlashCard: View {
    @StateObject var vm: smartCardsViewModel
    
    @State var toggleButton = false
    @State var currentCard = 0
    
    var body: some View {
        VStack {
            HStack{
                Text("Cards Left: \(vm.cardList.count)")
                Button{
                    for i in vm.cardList.indices{
                        vm.cardList[i].isKnown = false
                    }
                }label: {
                    Text("Reset")
                        .foregroundColor(.black)
                }
                .buttonStyle(.bordered)
            }
                
            
            Spacer()
            
            Button {
                toggleButton.toggle()
            } label: {
                ZStack {
                    Rectangle()
                        .cornerRadius(45.0)
                        .shadow(color: .black, radius: 3.0)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 50)
                        .foregroundColor(.white)
                    
                    if vm.cardsTotal > 0{
                        Text(toggleButton ? "Answer: \(vm.cardList[currentCard].answer)" : "Question: \(vm.cardList[currentCard].question)")
                            .font(.title2)
                            .foregroundColor(.black)
                    } else{
                        Text("You're done!")
                            .foregroundColor(.black)
                            .font(.title)
                    }
                    
                }
                .gesture(DragGesture(minimumDistance: 3.0, coordinateSpace: .local)
                    .onEnded { value in
                        switch (value.translation.width, value.translation.height) {
                            case (...0, -30...30): print("left swipe")
                            case (0..., -30...30): print("right swipe")

                            default: print("NA")
                        }
                    }
                )
            }
            
            Spacer()
            
            HStack {
                Spacer()
                Button {
                    toggleButton = false
                    
                    if currentCard < vm.cardsTotal {
                        if currentCard == vm.cardsTotal - 1 {
                            currentCard = 0
                        } else if vm.cardsNotKnownTotal != 1 {
                            currentCard+=1
                        }
                    }
                    
                    while vm.cardList[currentCard].isKnown == true && currentCard < vm.cardsTotal - 1 {
                        currentCard+=1
                    }
                } label: {
                    Text("Don't Know")
                        .foregroundColor(.black)
                }
                .buttonStyle(.bordered)
                Spacer()
                    
                Button {
                    toggleButton = false
                    
                    if currentCard < vm.cardsTotal {
                        if currentCard == vm.cardsTotal - 1 {
                            currentCard = 0
                        } else if vm.cardsNotKnownTotal != 1 {
                            currentCard+=1
                        }
                    }
                    
                    while vm.cardList[currentCard].isKnown == true && currentCard < vm.cardsTotal - 1 {
                        currentCard+=1
                    }
                    vm.cardsNotKnownTotal -= 1
                } label: {
                    Text("Know")
                        .foregroundColor(.black)
                }.buttonStyle(.bordered)
                Spacer()
            }
        }
    }
}

struct FlashCard_Previews: PreviewProvider {
    static var previews: some View {
        FlashCard(vm: smartCardsViewModel())
    }
}
