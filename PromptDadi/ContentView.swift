import SwiftUI

struct ContentView: View {
    @StateObject private var promptManager = PromptManager()
    @State private var showingAddPrompt = false
    @State private var showingAddFolder = false
    @State private var showingEditPrompt = false
    @State private var editingPrompt: Prompt?
    @State private var showingHelp = false
    @State private var showingNewFolder = false
    @State private var newFolderTitle = ""
    @State private var newPromptTitle = ""
    @State private var newPromptText = ""
    @State private var newFolderName = ""
    @State private var selectedPrompts: Set<Prompt> = []
    @State private var expandedFolders: Set<String> = []
    @State private var selectedNavigationItem: NavigationItem?
    @State private var showingCommandPalette = false
    @State private var commandPaletteSearch = ""
    @State private var selectedCommandIndex = 0
    @State private var showingClipboardConfirmation = false
    @State private var clipboardConfirmationText = ""
    
    enum NavigationItem: Hashable {
        case folder(String)
        case prompt(Prompt)
    }
    
    var allNavigationItems: [NavigationItem] {
        var items: [NavigationItem] = []
        for folder in promptManager.folders {
            items.append(.folder(folder))
            let folderPrompts = promptManager.prompts.filter { $0.folder == folder }
            for prompt in folderPrompts {
                items.append(.prompt(prompt))
            }
        }
        return items
    }
    
    var filteredPrompts: [Prompt] {
        if commandPaletteSearch.isEmpty {
            return promptManager.prompts
        } else {
            return promptManager.prompts.filter { prompt in
                prompt.title.localizedCaseInsensitiveContains(commandPaletteSearch) ||
                prompt.text.localizedCaseInsensitiveContains(commandPaletteSearch) ||
                prompt.folder.localizedCaseInsensitiveContains(commandPaletteSearch)
            }
        }
    }
    
    var body: some View {
        NavigationSplitView {
            // Left pane - Folder navigation with nested prompts
            VStack(spacing: 0) {
                // Header
                Rectangle()
                    .fill(Color.black)
                    .frame(height: 2)
                
                HStack {
                    Text("PROMPT DADI 🌹")
                        .font(.system(size: 14, weight: .bold, design: .monospaced))
                        .foregroundColor(.black)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                    
                    Spacer()
                }
                .background(Color.white)
                
                Rectangle()
                    .fill(Color.black)
                    .frame(height: 1)
                
                // Folder list
                List {
                    ForEach(promptManager.folders, id: \.self) { folder in
                        DisclosureGroup(
                            isExpanded: Binding(
                                get: { expandedFolders.contains(folder) },
                                set: { isExpanded in
                                    if isExpanded {
                                        expandedFolders.insert(folder)
                                    } else {
                                        expandedFolders.remove(folder)
                                    }
                                }
                            )
                        ) {
                            // Nested prompts for this folder with drag and drop
                            ForEach(promptManager.prompts.filter { $0.folder == folder }, id: \.id) { prompt in
                                HStack(spacing: 8) {
                                    Rectangle()
                                        .fill(Color.black)
                                        .frame(width: 8, height: 8)
                                    
                                    Text(prompt.title)
                                        .font(.system(size: 13, weight: .medium, design: .monospaced))
                                        .foregroundColor(.black)
                                    
                                    Spacer()
                                }
                                .padding(.leading, 32)
                                .padding(.vertical, 4)
                                .background(
                                    Rectangle()
                                        .fill(selectedNavigationItem == .prompt(prompt) ? Color.black.opacity(0.1) : Color.clear)
                                )
                                .onTapGesture {
                                    selectedNavigationItem = .prompt(prompt)
                                    promptManager.selectedFolder = prompt.folder
                                }
                                .contextMenu {
                                    Button("Copy Text") {
                                        copyPromptToClipboard(prompt)
                                    }
                                    Divider()
                                    Button("Delete", role: .destructive) {
                                        promptManager.deletePrompt(prompt)
                                    }
                                }
                            }
                            .onMove { source, destination in
                                movePrompt(from: source, to: destination, in: folder)
                            }
                        } label: {
                            HStack(spacing: 8) {
                                Rectangle()
                                    .fill(promptManager.getColorForFolder(folder))
                                    .frame(width: 12, height: 12)
                                
                                Text(folder.uppercased())
                                    .font(.system(size: 14, weight: .bold, design: .monospaced))
                                    .foregroundColor(.black)
                                
                                Spacer()
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                selectedNavigationItem = .folder(folder)
                                promptManager.selectedFolder = folder
                            }
                            .background(
                                Rectangle()
                                    .fill(selectedNavigationItem == .folder(folder) ? Color.black.opacity(0.1) : Color.clear)
                            )
                            .contextMenu {
                                if folder != "General" {
                                    Button("Delete Folder", role: .destructive) {
                                        promptManager.deleteFolder(folder)
                                    }
                                }
                            }
                        }
                    }
                }
                .listStyle(.plain)
            }
            .background(Color.white)
        } detail: {
            // Right pane - Prompts list for selected folder
            VStack(spacing: 0) {
                // Header
                Rectangle()
                    .fill(Color.black)
                    .frame(height: 2)
                
                HStack {
                    Text(promptManager.selectedFolder.uppercased())
                        .font(.system(size: 14, weight: .bold, design: .monospaced))
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                    
                    Spacer()
                }
                .background(promptManager.getColorForFolder(promptManager.selectedFolder))
                
                Rectangle()
                    .fill(Color.black)
                    .frame(height: 1)
                
                // Content
                if promptManager.promptsInSelectedFolder.isEmpty {
                    VStack(spacing: 16) {
                        Rectangle()
                            .fill(Color.black)
                            .frame(width: 48, height: 48)
                        
                        Text("NO PROMPTS")
                            .font(.system(size: 16, weight: .bold, design: .monospaced))
                            .foregroundColor(.black)
                        
                        Text("CLICK + TO ADD")
                            .font(.system(size: 12, weight: .medium, design: .monospaced))
                            .foregroundColor(.black.opacity(0.6))
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white)
                } else {
                    List(promptManager.promptsInSelectedFolder, selection: $selectedPrompts) { prompt in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(prompt.title.uppercased())
                                .font(.system(size: 14, weight: .bold, design: .monospaced))
                                .foregroundColor(.black)
                            
                            Rectangle()
                                .fill(Color.black)
                                .frame(height: 1)
                            
                            Text(prompt.text)
                                .font(.system(size: 12, weight: .medium, design: .monospaced))
                                .foregroundColor(.black.opacity(0.8))
                                .lineLimit(3)
                        }
                        .padding(12)
                        .background(
                            Rectangle()
                                .fill(selectedNavigationItem == .prompt(prompt) ? Color.black.opacity(0.1) : Color.clear)
                        )
                        .contextMenu {
                            Button("Copy Text") {
                                copyPromptToClipboard(prompt)
                            }
                            Divider()
                            Button("Delete", role: .destructive) {
                                promptManager.deletePrompt(prompt)
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .background(Color.white)
        }
        .overlay(
            // Overlays
            ZStack {
                // New prompt overlay
                if showingAddPrompt {
                    ZStack {
                        Color.black.opacity(0.5)
                            .ignoresSafeArea()
                            .onTapGesture {
                                showingAddPrompt = false
                            }
                        
                        AddPromptView(promptManager: promptManager, isPresented: $showingAddPrompt, currentFolder: promptManager.selectedFolder)
                            .frame(width: 500, height: 500)
                    }
                    .onKeyPress(.escape) {
                        showingAddPrompt = false
                        return .handled
                    }
                }
                
                // Edit prompt overlay
                if showingEditPrompt, let prompt = editingPrompt {
                    ZStack {
                        Color.black.opacity(0.5)
                            .ignoresSafeArea()
                            .onTapGesture {
                                showingEditPrompt = false
                            }
                        
                        EditPromptView(promptManager: promptManager, isPresented: $showingEditPrompt, prompt: prompt)
                            .frame(width: 500, height: 500)
                    }
                    .onKeyPress(.escape) {
                        showingEditPrompt = false
                        return .handled
                    }
                }
                
                // Help overlay
                if showingHelp {
                    ZStack {
                        Color.black.opacity(0.5)
                            .ignoresSafeArea()
                            .onTapGesture {
                                showingHelp = false
                            }
                        
                        HelpOverlay(isPresented: $showingHelp)
                            .frame(width: 600, height: 700)
                    }
                    .onKeyPress(.escape) {
                        showingHelp = false
                        return .handled
                    }
                }
                
                // New folder overlay
                if showingNewFolder {
                    ZStack {
                        Color.black.opacity(0.5)
                            .ignoresSafeArea()
                            .onTapGesture {
                                showingNewFolder = false
                            }
                        
                        NewFolderOverlay(promptManager: promptManager, isPresented: $showingNewFolder, folderTitle: $newFolderTitle)
                            .frame(width: 400, height: 300)
                    }
                    .onKeyPress(.escape) {
                        showingNewFolder = false
                        return .handled
                    }
                }
            }
        )
        .alert("Add Folder", isPresented: $showingAddFolder) {
            TextField("Folder name", text: $newFolderName)
            Button("Cancel", role: .cancel) { }
            Button("Add") {
                if !newFolderName.isEmpty {
                    promptManager.addFolder(newFolderName)
                    newFolderName = ""
                }
            }
        }
        .overlay(
            CommandPaletteOverlay(
                isVisible: $showingCommandPalette,
                searchText: $commandPaletteSearch,
                selectedIndex: $selectedCommandIndex,
                prompts: filteredPrompts,
                onSelectPrompt: { prompt in
                    selectedNavigationItem = .prompt(prompt)
                    promptManager.selectedFolder = prompt.folder
                    showingCommandPalette = false
                    commandPaletteSearch = ""
                    selectedCommandIndex = 0
                },
                onCopyToClipboard: { prompt in
                    copyPromptToClipboard(prompt)
                }
            )
        )
        .overlay(
            // Clipboard confirmation toast
            VStack {
                Spacer()
                if showingClipboardConfirmation {
                    HStack(spacing: 8) {
                        Rectangle()
                            .fill(Color.black)
                            .frame(width: 12, height: 12)
                        
                        Text(clipboardConfirmationText.uppercased())
                            .font(.system(size: 11, weight: .bold, design: .monospaced))
                            .foregroundColor(.black)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color.white)
                    .overlay(
                        Rectangle()
                            .stroke(Color.black, lineWidth: 2)
                    )
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .animation(.easeInOut(duration: 0.3), value: showingClipboardConfirmation)
                }
            }
            .padding(.bottom, 20)
        )
        .onReceive(NotificationCenter.default.publisher(for: NSApplication.didBecomeActiveNotification)) { _ in
            // Reset any global shortcuts when app becomes active
        }
        .onAppear {
            setupKeyboardShortcuts()
            // Expand all folders by default
            expandedFolders = Set(promptManager.folders)
        }
    }
    
    private func copyPromptToClipboard(_ prompt: Prompt) {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(prompt.text, forType: .string)
        clipboardConfirmationText = "Copied '\(prompt.title)' to clipboard"
        showingClipboardConfirmation = true
        
        // Auto-hide confirmation after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            showingClipboardConfirmation = false
        }
    }
    
    private func movePrompt(from source: IndexSet, to destination: Int, in folder: String) {
        let promptsInFolder = promptManager.prompts.filter { $0.folder == folder }
        guard let sourceIndex = source.first, sourceIndex < promptsInFolder.count else { return }
        
        let movedPrompt = promptsInFolder[sourceIndex]
        
        // Remove the prompt from its current position
        promptManager.prompts.removeAll { $0.id == movedPrompt.id }
        
        // Find all prompts in this folder after removal
        let remainingPromptsInFolder = promptManager.prompts.filter { $0.folder == folder }
        
        // Calculate where to insert the moved prompt
        let insertIndex: Int
        if destination >= remainingPromptsInFolder.count {
            // Insert at the end of the folder's prompts
            let lastPromptInFolder = remainingPromptsInFolder.last
            if let lastPrompt = lastPromptInFolder {
                let lastIndex = promptManager.prompts.firstIndex { $0.id == lastPrompt.id } ?? 0
                insertIndex = lastIndex + 1
            } else {
                // No other prompts in folder, insert at beginning
                insertIndex = 0
            }
        } else {
            // Insert at specific position
            let targetPrompt = remainingPromptsInFolder[destination]
            insertIndex = promptManager.prompts.firstIndex { $0.id == targetPrompt.id } ?? 0
        }
        
        // Insert the moved prompt at the new position
        promptManager.prompts.insert(movedPrompt, at: min(insertIndex, promptManager.prompts.count))
        
        // Save the changes
        promptManager.saveData()
    }
    
    private func setupKeyboardShortcuts() {
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
            // New folder shortcut (check this first - more specific)
            if event.modifierFlags.contains([.command, .shift]) && event.characters == "n" {
                showingNewFolder = true
                newFolderTitle = ""
                return nil
            }
            
            // New prompt shortcut (check this second - less specific)
            if event.modifierFlags.contains(.command) && event.characters == "n" {
                showingAddPrompt = true
                return nil
            }
            
            // Command palette shortcut
            if event.modifierFlags.contains([.command, .shift]) && event.characters == "p" {
                showingCommandPalette = true
                commandPaletteSearch = ""
                selectedCommandIndex = 0
                return nil
            }
            
            // Edit prompt shortcut
            if event.modifierFlags.contains(.command) && event.characters == "e" {
                if case .prompt(let prompt) = selectedNavigationItem {
                    editingPrompt = prompt
                    showingEditPrompt = true
                    return nil
                }
            }
            
            // Help shortcut
            if event.characters == "?" {
                showingHelp = true
                return nil
            }
            
            // Escape key to close overlays
            if event.keyCode == 53 { // Escape key
                if showingHelp {
                    showingHelp = false
                    return nil
                }
                if showingAddPrompt {
                    showingAddPrompt = false
                    return nil
                }
                if showingEditPrompt {
                    showingEditPrompt = false
                    return nil
                }
                if showingCommandPalette {
                    showingCommandPalette = false
                    return nil
                }
            }
            
            // Enter key to copy selected prompt
            if event.keyCode == 36 { // Enter key
                if case .prompt(let prompt) = selectedNavigationItem {
                    copyPromptToClipboard(prompt)
                    return nil
                }
            }
            
            // Cmd+Enter to edit selected prompt (only when not in overlays)
            if event.modifierFlags.contains(.command) && event.keyCode == 36 { // Cmd+Enter
                if !showingAddPrompt && !showingEditPrompt {
                    if case .prompt(let prompt) = selectedNavigationItem {
                        editingPrompt = prompt
                        showingEditPrompt = true
                        return nil
                    }
                }
            }
            
            // Arrow key navigation
            if event.keyCode == 125 { // Down arrow
                navigateDown()
                return nil
            } else if event.keyCode == 126 { // Up arrow
                navigateUp()
                return nil
            } else if event.keyCode == 123 { // Left arrow
                if case .folder(let folder) = selectedNavigationItem {
                    // Collapse folder
                    expandedFolders.remove(folder)
                    return nil
                } else if case .prompt(let prompt) = selectedNavigationItem {
                    // If we're on a prompt, go to its parent folder
                    selectedNavigationItem = .folder(prompt.folder)
                    promptManager.selectedFolder = prompt.folder
                    return nil
                }
            } else if event.keyCode == 124 { // Right arrow
                if case .folder(let folder) = selectedNavigationItem {
                    // Expand folder
                    expandedFolders.insert(folder)
                    return nil
                }
            }
            
            // Only handle other keys if not in a drag operation
            // This prevents interference with drag and drop
            return event
        }
    }
    
    private func navigateDown() {
        let items = allNavigationItems
        guard !items.isEmpty else { return }
        
        if let currentIndex = items.firstIndex(of: selectedNavigationItem ?? .folder(promptManager.folders.first ?? "General")) {
            let nextIndex = min(currentIndex + 1, items.count - 1)
            selectedNavigationItem = items[nextIndex]
            
            // Update selected folder if needed
            switch items[nextIndex] {
            case .folder(let folder):
                promptManager.selectedFolder = folder
            case .prompt(let prompt):
                promptManager.selectedFolder = prompt.folder
            }
        } else {
            selectedNavigationItem = items.first
            if case .folder(let folder) = items.first {
                promptManager.selectedFolder = folder
            }
        }
    }
    
    private func navigateUp() {
        let items = allNavigationItems
        guard !items.isEmpty else { return }
        
        if let currentIndex = items.firstIndex(of: selectedNavigationItem ?? .folder(promptManager.folders.first ?? "General")) {
            let prevIndex = max(currentIndex - 1, 0)
            selectedNavigationItem = items[prevIndex]
            
            // Update selected folder if needed
            switch items[prevIndex] {
            case .folder(let folder):
                promptManager.selectedFolder = folder
            case .prompt(let prompt):
                promptManager.selectedFolder = prompt.folder
            }
        } else {
            selectedNavigationItem = items.first
            if case .folder(let folder) = items.first {
                promptManager.selectedFolder = folder
            }
        }
    }
}

struct CommandPaletteOverlay: View {
    @Binding var isVisible: Bool
    @Binding var searchText: String
    @Binding var selectedIndex: Int
    let prompts: [Prompt]
    let onSelectPrompt: (Prompt) -> Void
    let onCopyToClipboard: (Prompt) -> Void
    @FocusState private var isSearchFocused: Bool
    
    var body: some View {
        if isVisible {
            CommandPaletteContent(
                searchText: $searchText,
                selectedIndex: $selectedIndex,
                prompts: prompts,
                onSelectPrompt: onSelectPrompt,
                onCopyToClipboard: onCopyToClipboard,
                onClose: closeCommandPalette,
                isSearchFocused: _isSearchFocused
            )
            .onAppear {
                selectedIndex = 0
                isSearchFocused = true
            }
            .onKeyPress(.escape) {
                closeCommandPalette()
                return .handled
            }
        }
    }
    
    private func closeCommandPalette() {
        isVisible = false
        searchText = ""
        selectedIndex = 0
        isSearchFocused = false
    }
}

struct CommandPaletteContent: View {
    @Binding var searchText: String
    @Binding var selectedIndex: Int
    let prompts: [Prompt]
    let onSelectPrompt: (Prompt) -> Void
    let onCopyToClipboard: (Prompt) -> Void
    let onClose: () -> Void
    @FocusState var isSearchFocused: Bool
    
    var body: some View {
        ZStack {
            // Background overlay
            Color.black.opacity(0.5)
                .ignoresSafeArea()
                .onTapGesture {
                    onClose()
                }
            
            // Command palette
            VStack(spacing: 0) {
                CommandPaletteSearchBar(
                    searchText: $searchText,
                    isSearchFocused: _isSearchFocused,
                    onCopySelected: {
                        if !prompts.isEmpty && selectedIndex < prompts.count {
                            onCopyToClipboard(prompts[selectedIndex])
                            onClose()
                        }
                    }
                )
                
                CommandPaletteResults(
                    prompts: prompts,
                    selectedIndex: $selectedIndex,
                    onSelectPrompt: onSelectPrompt,
                    onCopyToClipboard: onCopyToClipboard,
                    onClose: onClose
                )
            }
            .frame(width: 600)
            .background(Color.white)
            .overlay(
                Rectangle()
                    .stroke(Color.black, lineWidth: 3)
            )
        }
    }
}

struct CommandPaletteSearchBar: View {
    @Binding var searchText: String
    @FocusState var isSearchFocused: Bool
    let onCopySelected: () -> Void
    
    var body: some View {
        HStack(spacing: 8) {
            Rectangle()
                .fill(Color.black)
                .frame(width: 12, height: 12)
            
            TextField("SEARCH PROMPTS...", text: $searchText)
                .textFieldStyle(.plain)
                .focused($isSearchFocused)
                .font(.system(size: 12, weight: .medium, design: .monospaced))
                .onSubmit {
                    onCopySelected()
                }
        }
        .padding(16)
        .background(Color.white)
        .overlay(
            Rectangle()
                .stroke(Color.black, lineWidth: 2)
        )
    }
}

struct CommandPaletteResults: View {
    let prompts: [Prompt]
    @Binding var selectedIndex: Int
    let onSelectPrompt: (Prompt) -> Void
    let onCopyToClipboard: (Prompt) -> Void
    let onClose: () -> Void
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(Array(prompts.enumerated()), id: \.element.id) { index, prompt in
                    CommandPaletteResultRow(
                        prompt: prompt,
                        isSelected: selectedIndex == index,
                        onSelect: {
                            onSelectPrompt(prompt)
                        },
                        onCopy: {
                            onCopyToClipboard(prompt)
                            onClose()
                        }
                    )
                }
            }
        }
        .frame(maxHeight: 300)
        .background(Color.white)
        .overlay(
            Rectangle()
                .stroke(Color.black, lineWidth: 2)
        )
    }
}

struct CommandPaletteResultRow: View {
    let prompt: Prompt
    let isSelected: Bool
    let onSelect: () -> Void
    let onCopy: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(prompt.title.uppercased())
                    .font(.system(size: 12, weight: .bold, design: .monospaced))
                    .foregroundColor(.black)
                Text(prompt.folder.uppercased())
                    .font(.system(size: 10, weight: .medium, design: .monospaced))
                    .foregroundColor(.black.opacity(0.6))
            }
            Spacer()
            
            Button("COPY") {
                onCopy()
            }
            .font(.system(size: 10, weight: .bold, design: .monospaced))
            .foregroundColor(.black)
            .buttonStyle(.plain)
        }
        .padding(12)
        .background(
            Rectangle()
                .fill(isSelected ? Color.black.opacity(0.1) : Color.clear)
        )
        .onTapGesture {
            onSelect()
        }
    }
}

struct AddPromptView: View {
    @ObservedObject var promptManager: PromptManager
    @Binding var isPresented: Bool
    let currentFolder: String
    @State private var title = ""
    @State private var text = ""
    @State private var selectedFolder: String
    @FocusState private var isTitleFocused: Bool
    
    init(promptManager: PromptManager, isPresented: Binding<Bool>, currentFolder: String) {
        self.promptManager = promptManager
        self._isPresented = isPresented
        self.currentFolder = currentFolder
        self._selectedFolder = State(initialValue: currentFolder)
    }
    
    var body: some View {
        VStack(spacing: 24) {
            Text("ADD NEW PROMPT")
                .font(.system(size: 18, weight: .bold, design: .monospaced))
                .foregroundColor(.black)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("TITLE")
                    .font(.system(size: 12, weight: .bold, design: .monospaced))
                    .foregroundColor(.black)
                
                TextField("PROMPT TITLE", text: $title)
                    .textFieldStyle(.plain)
                    .font(.system(size: 12, weight: .medium, design: .monospaced))
                    .padding(8)
                    .background(Color.white)
                    .overlay(
                        Rectangle()
                            .stroke(Color.black, lineWidth: 2)
                    )
                    .focused($isTitleFocused)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("FOLDER")
                    .font(.system(size: 12, weight: .bold, design: .monospaced))
                    .foregroundColor(.black)
                
                Picker("Folder", selection: $selectedFolder) {
                    ForEach(promptManager.folders, id: \.self) { folder in
                        Text(folder.uppercased()).tag(folder)
                    }
                }
                .pickerStyle(.menu)
                .font(.system(size: 12, weight: .medium, design: .monospaced))
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("PROMPT TEXT")
                    .font(.system(size: 12, weight: .bold, design: .monospaced))
                    .foregroundColor(.black)
                
                TextEditor(text: $text)
                    .font(.system(size: 12, weight: .medium, design: .monospaced))
                    .frame(height: 200)
                    .padding(8)
                    .background(Color.white)
                    .overlay(
                        Rectangle()
                            .stroke(Color.black, lineWidth: 2)
                    )
            }
            
            HStack(spacing: 16) {
                Button("CANCEL") {
                    isPresented = false
                }
                .font(.system(size: 12, weight: .bold, design: .monospaced))
                .foregroundColor(.black)
                .buttonStyle(.plain)
                .keyboardShortcut(.escape)
                
                Spacer()
                
                Button("ADD PROMPT") {
                    if !title.isEmpty && !text.isEmpty {
                        promptManager.addPrompt(title: title, text: text, folder: selectedFolder)
                        isPresented = false
                    }
                }
                .font(.system(size: 12, weight: .bold, design: .monospaced))
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    Rectangle()
                        .fill(title.isEmpty || text.isEmpty ? Color.gray : Color.black)
                )
                .buttonStyle(.plain)
                .keyboardShortcut(.return, modifiers: .command)
                .disabled(title.isEmpty || text.isEmpty)
            }
        }
        .padding(24)
        .background(Color.white)
        .overlay(
            Rectangle()
                .stroke(Color.black, lineWidth: 3)
        )
        .frame(width: 500, height: 500)
        .onAppear {
            isTitleFocused = true
        }
        .onKeyPress(.return) {
            if let event = NSApplication.shared.currentEvent,
               event.modifierFlags.contains(.command) {
                if !title.isEmpty && !text.isEmpty {
                    promptManager.addPrompt(title: title, text: text, folder: selectedFolder)
                    isPresented = false
                }
                return .handled
            }
            return .ignored
        }
    }
}

struct EditPromptView: View {
    @ObservedObject var promptManager: PromptManager
    @Binding var isPresented: Bool
    let prompt: Prompt
    @State private var title: String
    @State private var text: String
    @State private var selectedFolder: String
    @FocusState private var isTitleFocused: Bool
    
    init(promptManager: PromptManager, isPresented: Binding<Bool>, prompt: Prompt) {
        self.promptManager = promptManager
        self._isPresented = isPresented
        self.prompt = prompt
        self._title = State(initialValue: prompt.title)
        self._text = State(initialValue: prompt.text)
        self._selectedFolder = State(initialValue: prompt.folder)
    }
    
    var body: some View {
        VStack(spacing: 24) {
            Text("EDIT PROMPT")
                .font(.system(size: 18, weight: .bold, design: .monospaced))
                .foregroundColor(.black)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("TITLE")
                    .font(.system(size: 12, weight: .bold, design: .monospaced))
                    .foregroundColor(.black)
                
                TextField("PROMPT TITLE", text: $title)
                    .textFieldStyle(.plain)
                    .font(.system(size: 12, weight: .medium, design: .monospaced))
                    .padding(8)
                    .background(Color.white)
                    .overlay(
                        Rectangle()
                            .stroke(Color.black, lineWidth: 2)
                    )
                    .focused($isTitleFocused)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("FOLDER")
                    .font(.system(size: 12, weight: .bold, design: .monospaced))
                    .foregroundColor(.black)
                
                Picker("Folder", selection: $selectedFolder) {
                    ForEach(promptManager.folders, id: \.self) { folder in
                        Text(folder.uppercased()).tag(folder)
                    }
                }
                .pickerStyle(.menu)
                .font(.system(size: 12, weight: .medium, design: .monospaced))
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("PROMPT TEXT")
                    .font(.system(size: 12, weight: .bold, design: .monospaced))
                    .foregroundColor(.black)
                
                TextEditor(text: $text)
                    .font(.system(size: 12, weight: .medium, design: .monospaced))
                    .frame(height: 200)
                    .padding(8)
                    .background(Color.white)
                    .overlay(
                        Rectangle()
                            .stroke(Color.black, lineWidth: 2)
                    )
            }
            
            HStack(spacing: 16) {
                Button("CANCEL") {
                    isPresented = false
                }
                .font(.system(size: 12, weight: .bold, design: .monospaced))
                .foregroundColor(.black)
                .buttonStyle(.plain)
                .keyboardShortcut(.escape)
                
                Spacer()
                
                Button("SAVE CHANGES") {
                    if !title.isEmpty && !text.isEmpty {
                        // Delete old prompt and add new one
                        promptManager.deletePrompt(prompt)
                        promptManager.addPrompt(title: title, text: text, folder: selectedFolder)
                        isPresented = false
                    }
                }
                .font(.system(size: 12, weight: .bold, design: .monospaced))
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    Rectangle()
                        .fill(title.isEmpty || text.isEmpty ? Color.gray : Color.black)
                )
                .keyboardShortcut(.return, modifiers: .command)
                .disabled(title.isEmpty || text.isEmpty)
            }
        }
        .padding(24)
        .background(Color.white)
        .overlay(
            Rectangle()
                .stroke(Color.black, lineWidth: 3)
        )
        .frame(width: 500, height: 500)
        .onAppear {
            isTitleFocused = true
        }
        .onKeyPress(.return) {
            // Check if Cmd is pressed using NSEvent
            if let event = NSApplication.shared.currentEvent,
               event.modifierFlags.contains(.command) {
                if !title.isEmpty && !text.isEmpty {
                    // Delete old prompt and add new one
                    promptManager.deletePrompt(prompt)
                    promptManager.addPrompt(title: title, text: text, folder: selectedFolder)
                    isPresented = false
                }
                return .handled
            }
            return .ignored
        }
    }
}

struct HelpOverlay: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack(spacing: 24) {
            Text("KEYBOARD SHORTCUTS")
                .font(.system(size: 18, weight: .bold, design: .monospaced))
                .foregroundColor(.black)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Navigation
                    ShortcutSection(title: "NAVIGATION", shortcuts: [
                        ("↑/↓", "Navigate folders and prompts"),
                        ("←", "Go to parent folder or collapse folder"),
                        ("→", "Expand folder"),
                        ("Enter", "Copy selected prompt to clipboard")
                    ])
                    
                    // Prompt Management
                    ShortcutSection(title: "PROMPT MANAGEMENT", shortcuts: [
                        ("Cmd+N", "Create new prompt"),
                        ("Cmd+Shift+N", "Create new folder"),
                        ("Cmd+E", "Edit selected prompt"),
                        ("Cmd+Enter", "Edit selected prompt (when not in forms)"),
                        ("Cmd+Enter", "Save form (when creating/editing prompts)")
                    ])
                    
                    // Command Palette
                    ShortcutSection(title: "COMMAND PALETTE", shortcuts: [
                        ("Cmd+Shift+P", "Open command palette"),
                        ("Escape", "Close command palette"),
                        ("Enter", "Copy selected prompt to clipboard"),
                        ("↑/↓", "Navigate search results")
                    ])
                    
                    // Form Controls
                    ShortcutSection(title: "FORM CONTROLS", shortcuts: [
                        ("Escape", "Cancel/close overlay"),
                        ("Cmd+Enter", "Save form"),
                        ("Tab", "Navigate between fields")
                    ])
                    
                    // Help
                    ShortcutSection(title: "HELP", shortcuts: [
                        ("?", "Show this help overlay"),
                        ("Escape", "Close help overlay")
                    ])
                }
                .padding(.horizontal, 24)
            }
            
            HStack {
                Spacer()
                
                Button("CLOSE") {
                    isPresented = false
                }
                .font(.system(size: 12, weight: .bold, design: .monospaced))
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    Rectangle()
                        .fill(Color.black)
                )
                .buttonStyle(.plain)
                .keyboardShortcut(.escape)
            }
        }
        .padding(24)
        .background(Color.white)
        .overlay(
            Rectangle()
                .stroke(Color.black, lineWidth: 3)
        )
    }
}

struct ShortcutSection: View {
    let title: String
    let shortcuts: [(String, String)]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 14, weight: .bold, design: .monospaced))
                .foregroundColor(.black)
            
            Rectangle()
                .fill(Color.black)
                .frame(height: 1)
            
            ForEach(shortcuts, id: \.0) { shortcut in
                HStack {
                    Text(shortcut.0)
                        .font(.system(size: 12, weight: .bold, design: .monospaced))
                        .foregroundColor(.black)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            Rectangle()
                                .stroke(Color.black, lineWidth: 1)
                        )
                    
                    Text(shortcut.1)
                        .font(.system(size: 12, weight: .medium, design: .monospaced))
                        .foregroundColor(.black)
                    
                    Spacer()
                }
            }
        }
    }
}

struct NewFolderOverlay: View {
    @ObservedObject var promptManager: PromptManager
    @Binding var isPresented: Bool
    @Binding var folderTitle: String
    @FocusState private var isTitleFocused: Bool
    
    var body: some View {
        VStack(spacing: 24) {
            Text("CREATE NEW FOLDER")
                .font(.system(size: 18, weight: .bold, design: .monospaced))
                .foregroundColor(.black)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("FOLDER NAME")
                    .font(.system(size: 12, weight: .bold, design: .monospaced))
                    .foregroundColor(.black)
                
                TextField("FOLDER NAME", text: $folderTitle)
                    .textFieldStyle(.plain)
                    .font(.system(size: 12, weight: .medium, design: .monospaced))
                    .padding(8)
                    .background(Color.white)
                    .overlay(Rectangle().stroke(Color.black, lineWidth: 2))
                    .focused($isTitleFocused)
            }
            
            HStack(spacing: 16) {
                Button("CANCEL") {
                    isPresented = false
                }
                .font(.system(size: 12, weight: .bold, design: .monospaced))
                .foregroundColor(.black)
                .buttonStyle(.plain)
                .keyboardShortcut(.escape)
                
                Spacer()
                
                Button("CREATE FOLDER") {
                    if !folderTitle.isEmpty {
                        promptManager.addFolder(folderTitle)
                        isPresented = false
                        folderTitle = ""
                    }
                }
                .font(.system(size: 12, weight: .bold, design: .monospaced))
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    Rectangle()
                        .fill(folderTitle.isEmpty ? Color.gray : Color.black)
                )
                .buttonStyle(.plain)
                .keyboardShortcut(.return, modifiers: .command)
                .disabled(folderTitle.isEmpty)
            }
        }
        .padding(24)
        .background(Color.white)
        .overlay(
            Rectangle()
                .stroke(Color.black, lineWidth: 3)
        )
        .onAppear {
            isTitleFocused = true
        }
        .onKeyPress(.return) {
            if let event = NSApplication.shared.currentEvent, event.modifierFlags.contains(.command) {
                if !folderTitle.isEmpty {
                    promptManager.addFolder(folderTitle)
                    isPresented = false
                    folderTitle = ""
                }
                return .handled
            }
            return .ignored
        }
    }
}

#Preview {
    ContentView()
} 