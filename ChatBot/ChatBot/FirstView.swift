//
//  FirstView.swift
//  ChatBot
//
//  Created by Letizia Granata on 17/05/24.
//

import SwiftUI

struct FirstView: View {
    @State private var isPresented = false
    var body: some View {
                ZStack {
                    Image("background")
                        .resizable()
                        .scaledToFill()
                        .padding(.top, -37)
                    VStack {
                        Text("Hi! I'm Iris, I'm here to help you with your daily struggles.")
                            .multilineTextAlignment(.center)
                            .font(.title3)
                            .fontWeight(.light)
                            .italic()
                
                        Button(action: {
                            isPresented.toggle()
                        }, label: {
                            Text("Talk to Iris")
                                .fontWeight(.light)
                                .foregroundStyle(.black)
                                .font(.title2)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 20, style: .circular)
                                        .fill(Color("yellowish"))
                                        .frame(width: 180, height: 50, alignment: .center)
                                        
                                )
                        })
                        .fullScreenCover(isPresented: $isPresented, content: {
                            ChatView()
                                .preferredColorScheme(.light)

                        })
                    .padding(.top,10)
                }
                .padding(.top, 600)

        }
//        .background(Image("background"))
//        .scaledToFill()
    }
}

#Preview {
    FirstView()
}
