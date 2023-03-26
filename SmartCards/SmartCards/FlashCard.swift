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
    
    var body: some View {
        VStack {
            Text("Cards Left: \(vm.cardList.count)")
            
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
                    Text(toggleButton ? "Answer: \(vm.cardList.count)" : "Question: \(vm.cardList.count)")
                        .font(.title2)
                        .foregroundColor(.black)
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
                Button {} label: {
                    Text("Don't Know")
                }
                Button {} label: {
                    Text("Know")
                }
            }
        }
    }
}

struct FlashCard_Previews: PreviewProvider {
    static var previews: some View {
        FlashCard(vm: smartCardsViewModel())
    }
}
