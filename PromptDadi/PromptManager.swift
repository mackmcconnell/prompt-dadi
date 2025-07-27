import Foundation
import SwiftUI

class PromptManager: ObservableObject {
    @Published var prompts: [Prompt] = []
    @Published var folders: [String] = ["General"]
    @Published var selectedFolder: String = "General"
    @Published var folderColors: [String: Color] = [:]
    
    private let userDefaults = UserDefaults.standard
    private let promptsKey = "savedPrompts"
    private let foldersKey = "savedFolders"
    private let folderColorsKey = "savedFolderColors"
    
    // Bauhaus color palette
    private let bauhausColors: [Color] = [
        Color.red,
        Color.blue,
        Color.yellow,
        Color.green,
        Color.orange,
        Color.purple,
        Color.pink,
        Color.cyan,
        Color.mint,
        Color.indigo
    ]
    
    init() {
        loadData()
        // Force reassign colors to all folders to fix any black colors
        reassignAllFolderColors()
        // Save the reassigned colors
        saveData()
    }
    
    func addPrompt(title: String, text: String, folder: String) {
        let prompt = Prompt(title: title, text: text, folder: folder)
        prompts.append(prompt)
        saveData()
    }
    
    func deletePrompt(_ prompt: Prompt) {
        prompts.removeAll { $0.id == prompt.id }
        saveData()
    }
    
    func addFolder(_ folderName: String) {
        if !folders.contains(folderName) {
            folders.append(folderName)
            assignColorToFolder(folderName)
            saveData()
        }
    }
    
    func deleteFolder(_ folderName: String) {
        if folderName != "General" {
            folders.removeAll { $0 == folderName }
            folderColors.removeValue(forKey: folderName)
            prompts.removeAll { $0.folder == folderName }
            if selectedFolder == folderName {
                selectedFolder = "General"
            }
            saveData()
        }
    }
    
    func getColorForFolder(_ folderName: String) -> Color {
        // If folder doesn't have a color, assign one
        if folderColors[folderName] == nil {
            assignColorToFolder(folderName)
            saveData()
        }
        // Return the assigned color or a default Bauhaus color
        return folderColors[folderName] ?? bauhausColors.first ?? Color.red
    }
    
    private func assignColorToFolder(_ folderName: String) {
        // Get available colors (not already assigned)
        let usedColors = Set(folderColors.values)
        let availableColors = bauhausColors.filter { !usedColors.contains($0) }
        
        if let randomColor = availableColors.randomElement() {
            folderColors[folderName] = randomColor
        } else {
            // If all colors are used, pick a random one from the palette
            folderColors[folderName] = bauhausColors.randomElement() ?? Color.red
        }
    }
    
    private func reassignAllFolderColors() {
        // Clear existing colors and reassign
        folderColors.removeAll()
        for folder in folders {
            assignColorToFolder(folder)
        }
    }
    
    var promptsInSelectedFolder: [Prompt] {
        prompts.filter { $0.folder == selectedFolder }
    }
    
    private func loadData() {
        if let data = userDefaults.data(forKey: promptsKey),
           let decoded = try? JSONDecoder().decode([Prompt].self, from: data) {
            prompts = decoded
        }
        
        if let savedFolders = userDefaults.stringArray(forKey: foldersKey) {
            folders = savedFolders
        }
        
        // Load folder colors
        if let colorData = userDefaults.dictionary(forKey: folderColorsKey) as? [String: [Double]] {
            folderColors = colorData.compactMapValues { components in
                guard components.count >= 4 else { return nil }
                return Color(.sRGB, red: components[0], green: components[1], blue: components[2], opacity: components[3])
            }
        }
    }
    
    func saveData() {
        if let encoded = try? JSONEncoder().encode(prompts) {
            userDefaults.set(encoded, forKey: promptsKey)
        }
        userDefaults.set(folders, forKey: foldersKey)
        
        // Save folder colors
        let colorData = folderColors.mapValues { color in
            if let components = color.cgColor?.components {
                return [components[0], components[1], components[2], components[3]]
            }
            return [0.0, 0.0, 0.0, 1.0]
        }
        userDefaults.set(colorData, forKey: folderColorsKey)
    }
} 