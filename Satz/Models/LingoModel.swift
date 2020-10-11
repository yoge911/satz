//
//  LingoModel.swift
//  Satz
//
//  Created by Yogesh Rokhade on 29.08.20.
//  Copyright © 2020 Yogesh Rokhade. All rights reserved.
//

import Foundation

struct Glossary: Codable {
    
    let germanSection: SectionType?
    let spanishSection: SectionType?
    let englishSection: SectionType?
    let frenchSection: SectionType?
    
    enum CodingKeys: String, CodingKey {
        case germanSection = "German"
        case spanishSection = "Spanish"
        case englishSection = "English"
        case frenchSection = "French"
    }
}

struct SectionType: Codable {
    let easy: Section?
    let medium: Section?
    let hard: Section?
    
    enum CodingKeys: String, CodingKey {
        case easy = "Easy"
        case medium = "Medium"
        case hard = "Hard"
    }
}

struct SentenceItems: Codable {
    let sentences: [SentenceItem]?
    enum CodingKeys: String, CodingKey {
        case sentences = "sentences"
    }
}

struct WordItems: Codable {
    let words: [WordItem]?
    enum CodingKeys: String, CodingKey {
        case words = "Words"
    }
}

struct Section: Codable {
    let sentencesFileName: String!
    let wordsFileName: String!
    let words: [WordItem]
    let sentences: [SentenceItem]?
    
    enum CodingKeys: String, CodingKey {
        case sentencesFileName = "SentencesListFile"
        case wordsFileName = "WordsListFile"
        case words = "Words"
        case sentences = "Sentences"
    }
}

struct WordItem: Codable {
    let id: String!
    let word: String!
    let translated: String!
    let relatableSentences: [String]!
    
    enum CodingKeys: String, CodingKey {
        case id =  "ID"
        case word = "Word"
        case translated = "Translated"
        case relatableSentences = "Links"
    }
}

struct SentenceItem: Codable {
    let id: String!
    let sentence: String!
    
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case sentence = "Sentence"
    }
}



struct DeepLText: Codable {
    let properties: [TProperty]
    
    enum CodingKeys: String, CodingKey {
        case properties = "translations"
    }
}

struct TProperty : Codable {
    let detectedLanguage: String!
    let translatedText: String!
    
    enum CodingKeys: String, CodingKey {
        case detectedLanguage = "detected_source_language"
        case translatedText = "text"
    }
}

