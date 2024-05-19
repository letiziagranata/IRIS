//
//  APIKey.swift
//  ChatBot
//
//  Created by Letizia Granata on 16/05/24.
//

import Foundation

enum APIKey {
    static var `default`: String {
        
        guard let filePath = Bundle.main.path(forResource: "GenerativeAIAPI", ofType: "plist")
        else {
            fatalError("Couldn't find the Property List, sorry :(")
        }
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "Api_key") as? String else {
            fatalError("Couldn't find the Api_Key, sorry :(")
        }
        if value.starts(with: "_") {
            fatalError("You didn't do a great job with your API! Try again :)")
        }
        return value
    }
}

//Package dependencies imported using this link https://github.com/google-gemini/generative-ai-swift.git

