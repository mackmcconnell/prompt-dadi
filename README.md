# Prompt Dadi 🌹

![Prompt Dadi Banner](assets/prompt-dadi-banner.png)

A native macOS app for organizing AI prompts with swaggy Bauhaus design aesthetic.

## What is Prompt Dadi?

**Prompt Dadi** is a way to organize, manage, and quickly access your AI prompts on Mac.

Do you find that you're collecting large pieces of texts for AI prompting in messy notes or google docs? Do you wish you could easily summon the baddest prompts in the game? 

Dont worry, Dadi's got you.

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

### Quick Install (Recommended)

**Option 1: One-liner**
```bash
git clone https://github.com/mackmcconnell/prompt-dadi.git && cd prompt-dadi && chmod +x install.sh && ./install.sh && open PromptDadi.app
```

**Option 2: Step by step**
```bash
# 1. Clone the repository
git clone https://github.com/mackmcconnell/prompt-dadi.git

# 2. Navigate to the directory
cd prompt-dadi

# 3. Make the install script executable
chmod +x install.sh

# 4. Run the installation
./install.sh

# 5. Launch the app
open PromptDadi.app
```

### What the Installation Does

The installation script automatically:

1. **📦 Checks prerequisites** → Ensures Xcode Command Line Tools are installed
2. **🔨 Builds the app** → Compiles with Swift Package Manager
3. **📱 Creates app bundle** → Proper macOS app structure
4. **🎨 Generates icon** → Creates the rose icon programmatically
5. **🔧 Sets permissions** → Makes the app executable
6. **✅ Provides feedback** → Shows progress and completion status

### Manual Installation

If you prefer to install manually or troubleshoot:

```bash
# 1. Install Command Line Tools (if needed)
xcode-select --install

# 2. Clone the repository
git clone https://github.com/mackmcconnell/prompt-dadi.git
cd prompt-dadi

# 3. Build the app
swift build -c release

# 4. Create app bundle structure
mkdir -p PromptDadi.app/Contents/MacOS
mkdir -p PromptDadi.app/Contents/Resources

# 5. Copy the executable
cp .build/release/PromptDadi PromptDadi.app/Contents/MacOS/

# 6. Set permissions
chmod +x PromptDadi.app/Contents/MacOS/PromptDadi

# 7. Create Info.plist (copy from PromptDadi/Info.plist)
cp PromptDadi/Info.plist PromptDadi.app/Contents/

# 8. Launch the app
open PromptDadi.app
```

### Install to Applications Folder

To install the app permanently in your Applications folder:

```bash
# After running the installation script
cp -r PromptDadi.app /Applications/

# Or use the one-liner
./install.sh && cp -r PromptDadi.app /Applications/
```

### Troubleshooting

**If the build fails:**
```bash
# Check if Command Line Tools are installed
xcode-select -p

# If not installed, install them
xcode-select --install

# Try building again
swift build -c release
```

**If the app doesn't launch:**
```bash
# Check if the executable exists
ls -la PromptDadi.app/Contents/MacOS/

# Check permissions
ls -la PromptDadi.app/Contents/MacOS/PromptDadi

# Try running directly
./PromptDadi.app/Contents/MacOS/PromptDadi
```

**If you get a security warning:**
1. Go to **System Preferences** → **Security & Privacy**
2. Click **"Open Anyway"** for PromptDadi
3. Or run: `sudo spctl --master-disable` (temporarily)

### System Requirements

- **macOS 14.0+** (Sonoma or later)
- **4GB RAM** minimum
- **500MB** free disk space
- **Xcode Command Line Tools** (installed automatically)

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

**Option 1: Xcode Project (Recommended for Contributors)**
```bash
git clone https://github.com/mackmcconnell/prompt-dadi.git
cd prompt-dadi
open PromptDadi.xcodeproj
```
Then in Xcode:
1. Select your Mac as the target device
2. Click the Run button (▶️) or press Cmd+R

**Option 2: Swift Package Manager (Command Line)**
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

PromptDadi.xcodeproj/    # Xcode project for visual development
Package.swift            # Swift Package Manager configuration
install.sh               # Automated installation script
```

### Development Approaches

**For Contributors:**
- **Xcode Project** → Familiar visual development environment
- **Built-in debugging** → Step-through debugging and breakpoints
- **Interface Builder** → Visual UI design (if needed)
- **Standard workflow** → Most iOS/macOS developers expect this

**For End Users:**
- **Swift Package Manager** → Command-line build with `install.sh`
- **Automated installation** → One-command setup
- **No Xcode required** → Just Command Line Tools

**For CI/CD:**
- **Swift Package Manager** → Easy automation
- **Cross-platform** → Works on Linux, CI systems

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

**Built with 🌹 ** 