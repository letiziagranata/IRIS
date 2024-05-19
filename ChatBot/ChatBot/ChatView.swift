//
//  ContentView.swift
//  ChatBot
//
//  Created by Letizia Granata on 16/05/24.
//

import SwiftUI
import GoogleGenerativeAI

struct ChatView: View {
    
    let model = GenerativeModel(name: "gemini-pro", apiKey: APIKey.default)
    @State var userPrompt: String = ""
    @State var response: String = ""
    @State var isLoading: Bool = false
    
    @Environment(\.dismiss) var dismiss
    @State var messageText: String = ""
    @State var chatMessages: [chatMessage] = []
    
    var body: some View {
        NavigationStack {
            VStack {
                ZStack {
                    Color.lightYellow.edgesIgnoringSafeArea(.all)
                    ScrollView {
                        LazyVStack {
                            ForEach(chatMessages, id: \.id) { message in
                                messageView(message: message)
                                //                                Text(response)
                            }
                            .padding()
                        }
                        .rotationEffect(.degrees(180))
                    }
                    .rotationEffect(.degrees(180))
                    .padding(.bottom, 80)
                    
                    HStack {
                        TextField("Type here to ask something...", text: $userPrompt, axis: .horizontal)
                            .lineLimit(5)
                            .padding()
                            .background(Color.lightGreen)
                            .cornerRadius(25)
                        Button("", systemImage: "paperplane.fill" ) {
                            generateResponse()
                        }
                        .font(.largeTitle)
                        .foregroundColor(.darkGreen)
                    }
                    .safeAreaInset(edge: .top, content: {
                        EmptyView()
                    })
                    .padding(.horizontal)
                    .navigationBarItems(
                        leading: Button(action: {
                            dismiss()
                        }) {
                            HStack{
                                Image(systemName: "chevron.left")
                                    .foregroundColor(Color("dark green"))
                                Text("Back")
                                    .foregroundColor(Color("dark green"))
                            }
                        })
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .darkGreen))
                            .scaleEffect(1)
                    }
                }
            }
            
        }
    }
    
    func generateResponse() {
        let userMessage = chatMessage(id: UUID().uuidString, content: .string(userPrompt), dateCreated: Date(), sender: .user)
        chatMessages.append(userMessage)
        userPrompt = ""
        isLoading = true
        
        Task {
            do {
                let result = try await model.generateContent(userMessage.content.stringValue)
                response = result.text ?? "I don't have an answer to this problem, sorry :("
                let responseMessage = chatMessage(id: UUID().uuidString, content: .string(response), dateCreated: Date(), sender: .chatBot)
                chatMessages.append(responseMessage)
            } catch {
                response = "Something went wrong :(\n\(error.localizedDescription)"
                let errorMessage = chatMessage(id: UUID().uuidString, content: .string(response), dateCreated: Date(), sender: .chatBot)
                chatMessages.append(errorMessage)
            }
            isLoading = false
        }
    }
    
    
    func messageView(message: chatMessage) -> some View {
        HStack {
            if message.sender == .user {Spacer()}
            switch message.content {
            case .string(let text):
                Text(text)
                    .padding()
                    .foregroundStyle(message.sender == .user ? .black : .black)
                    .background(message.sender == .user ? .darkGreen : .greeny)
                    .cornerRadius(25)
                
            }
            if message.sender == .chatBot { Spacer() }
            
        }
        .padding(.vertical, -10)
    }
    
}

#Preview {
    ChatView()
}

struct chatMessage {
    let id: String
    let content: typesOfContent
    let dateCreated: Date
    let sender: MessageSender
}

enum MessageSender {
    case user
    case chatBot
}

enum typesOfContent {
    case string(String)
    
    var stringValue: String {
        switch self {
        case .string(let text):
            return text
        }
    }
}

