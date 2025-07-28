# Prompt Dadi 🌹

A native macOS app for organizing AI prompts with a beautiful Bauhaus design aesthetic.

## Features

### 🎨 Design
- **Bauhaus aesthetic** with clean geometric shapes
- **No rounded corners** anywhere
- **Bold colors** and minimalist design
- **Hard window corners** for authentic Bauhaus look

### ⌨️ Keyboard Shortcuts
- **Cmd+N** → Create new prompt
- **Cmd+Shift+N** → Create new folder
- **Cmd+E** → Edit selected prompt
- **Cmd+Shift+P** → Command palette (fuzzy search)
- **Cmd+Enter** → Save forms
- **?** → Show help overlay
- **↑/↓** → Navigate folders and prompts
- **←/→** → Expand/collapse folders
- **Enter** → Copy prompt to clipboard

### 📁 Organization
- **Folder-based organization** with nested prompts
- **Unique Bauhaus colors** for each folder
- **Drag and drop** to reorder prompts within folders
- **Persistent storage** across app sessions

### 🔍 Search & Navigation
- **Command palette** with fuzzy search
- **Arrow key navigation** through all items
- **Context menus** for quick actions
- **Clipboard integration** with confirmation

### 💾 Data Management
- **Local storage** using UserDefaults
- **Automatic saving** of all changes
- **Persistent across sessions** and app restarts
- **No internet required** - works completely offline

## Installation

### Prerequisites
- **macOS 14.0+** (Sonoma or later)
- **Xcode Command Line Tools** (will be installed automatically if missing)

### Quick Install

1. **Clone the repository:**
   ```bash
   git clone https://github.com/mackmcconnell/prompt-dadi.git
   cd prompt-dadi
   ```

2. **Run the installation script:**
   ```bash
   chmod +x install.sh
   ./install.sh
   ```

3. **Launch the app:**
   ```bash
   open PromptDadi.app
   ```

### Manual Installation

If you prefer to install manually:

```bash
# Install Command Line Tools (if needed)
xcode-select --install

# Clone and build
git clone https://github.com/mackmcconnell/prompt-dadi.git
cd prompt-dadi
swift build -c release

# Create app bundle
mkdir -p PromptDadi.app/Contents/MacOS
cp .build/release/PromptDadi PromptDadi.app/Contents/MacOS/
chmod +x PromptDadi.app/Contents/MacOS/PromptDadi

# Launch
open PromptDadi.app
```

### Install to Applications Folder

To install the app permanently:

```bash
cp -r PromptDadi.app /Applications/
```

## Usage

### Getting Started
1. **Launch the app** → Prompt Dadi opens with a clean interface
2. **Create folders** → Use Cmd+Shift+N to create new folders
3. **Add prompts** → Use Cmd+N to create new prompts
4. **Organize** → Drag prompts to reorder, use folders to categorize

### Navigation
- **Left pane** → Folder navigation with nested prompts
- **Right pane** → Prompt details for selected folder
- **Arrow keys** → Navigate through all items
- **Click** → Select folders or prompts

### Search
- **Cmd+Shift+P** → Open command palette
- **Type** → Fuzzy search across all prompts
- **Enter** → Copy selected prompt to clipboard
- **Escape** → Close command palette

### Help
- **?** → Show comprehensive help overlay
- **All shortcuts** → Listed in help overlay
- **Escape** → Close help overlay

## Data Storage

### Local Storage
- **UserDefaults** → Apple's built-in local storage
- **Automatic saving** → Every change saved immediately
- **Persistent** → Data survives app restarts and system updates
- **No internet** → Works completely offline

### Storage Location
```
~/Library/Containers/com.promptdadi.app/Data/Library/Preferences/
```

### Backup
- **Time Machine** → Automatically included in backups
- **Manual backup** → Copy UserDefaults file
- **Export** → Future feature for data portability

## Development

### Building from Source
```bash
git clone https://github.com/mackmcconnell/prompt-dadi.git
cd prompt-dadi
swift build
```

### Project Structure
```
PromptDadi/
├── ContentView.swift      # Main UI and interactions
├── PromptManager.swift    # Data management and persistence
├── Prompt.swift          # Data model
├── PromptDadiApp.swift   # App entry point
├── Info.plist           # App configuration
└── Assets.xcassets/     # App icons and resources
```

### Dependencies
- **SwiftUI** → UI framework
- **Foundation** → Core functionality
- **AppKit** → macOS integration

## Features in Detail

### Bauhaus Design
- **Geometric shapes** → Rectangles instead of rounded corners
- **Monospaced fonts** → Clean, technical aesthetic
- **High contrast** → Black, white, and bold colors
- **Minimalist layout** → Focus on content and functionality

### Keyboard Navigation
- **Arrow keys** → Navigate through folders and prompts
- **Enter** → Copy selected prompt to clipboard
- **Escape** → Close overlays and return to main view
- **Cmd shortcuts** → Quick access to all features

### Command Palette
- **Fuzzy search** → Find prompts by title or content
- **Keyboard navigation** → Arrow keys to select results
- **Quick copy** → Enter to copy prompt to clipboard
- **Instant results** → Real-time search as you type

### Drag and Drop
- **Reorder prompts** → Drag within folders
- **Visual feedback** → Clear indication of drag state
- **Persistent order** → Changes saved automatically
- **No conflicts** → Works alongside keyboard navigation

## Future Features

### Planned Enhancements
- **Global search** → Search across all content
- **Tags system** → Multiple tags per prompt
- **Export functionality** → Markdown, JSON, PDF export
- **Dark mode** → Theme toggle
- **Cloud sync** → Supabase or Firebase integration
- **Template library** → Pre-built prompt templates
- **Version history** → Track changes to prompts
- **Sharing** → Share prompts with others

### Potential Integrations
- **AI testing** → Test prompts with AI models
- **Prompt optimization** → AI suggestions for improvement
- **Workflow automation** → Chain prompts together
- **Analytics** → Usage insights and statistics

## Contributing

1. **Fork the repository**
2. **Create a feature branch** → `git checkout -b feature/amazing-feature`
3. **Make your changes** → Add new features or fix bugs
4. **Test thoroughly** → Ensure everything works
5. **Commit your changes** → `git commit -m 'Add amazing feature'`
6. **Push to the branch** → `git push origin feature/amazing-feature`
7. **Open a Pull Request** → Describe your changes

## License

This project is open source and available under the [MIT License](LICENSE).

## Support

- **Issues** → Report bugs on GitHub
- **Features** → Request new features via issues
- **Questions** → Ask questions in discussions

---

**Built with ❤️ and 🌹 for the AI prompt community** 