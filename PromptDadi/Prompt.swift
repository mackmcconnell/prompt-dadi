import Foundation

struct Prompt: Identifiable, Codable, Hashable {
    var id: UUID
    var title: String
    var text: String
    var folder: String
    var createdAt: Date
    
    init(title: String, text: String, folder: String) {
        self.id = UUID()
        self.title = title
        self.text = text
        self.folder = folder
        self.createdAt = Date()
    }
    
    // Hashable conformance
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Prompt, rhs: Prompt) -> Bool {
        lhs.id == rhs.id
    }
} 