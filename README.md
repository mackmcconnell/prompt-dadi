# Prompt Dadi 🌹

![Prompt Dadi Banner](assets/prompt-dadi-banner.png)

## What is Prompt Dadi?

**Prompt Dadi** is a way to organize, manage, and quickly access your AI prompts on Mac.

Do you find that you're collecting large pieces of texts for AI prompting in messy notes or google docs? 
Do you wish you could easily summon the baddest prompts in the game? 

Dont worry, Dadi's got you.

## 😎 **Coming Soon**

**Prompt Library**  
Browse a vast amount of dank prompts written by actual based gods. Import them directly into your Prompt Dadi with one click.

## 💡 **Key Benefits:**

- **⚡ Fast** → Find any prompt in seconds with command palette
- **🎨 Looks cool** → Bauhaus aesthetic that's both functional and inspiring
- **📱 Native to macOS** → Snappy and feels right.
- **🔒 Privacy First** → All data stored locally on your machine
- **🔄 Always Available** → Works offline, no internet required
- **📈 Productivity Boost** → Spend less time searching, more time creating

## Features

### ⌨️ Keyboard Shortcuts
Prompt Dadi is built shortcut-first without many interface clues. The only shortcut you really need to know is ```?``` which reveals all of the other shortcuts 🙃
- **?** → Show help overlay
- **Cmd+N** → Create new prompt
- **Cmd+Shift+N** → Create new folder
- **Cmd+E** → Edit selected prompt
- **Cmd+Shift+P** → Command palette (fuzzy search)
- **Cmd+Enter** → Save forms
- **↑/↓** → Navigate folders and prompts
- **←/→** → Expand/collapse folders
- **Enter** → Copy prompt to clipboard

### Some ~hidden features that help
- **Drag and drop** to reorder prompts within folders
- Launch **Command palette** to do pretty much anything
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

### Dependencies
- **SwiftUI** → UI framework
- **Foundation** → Core functionality
- **AppKit** → macOS integration

## Future Features
TBD

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

**Built with 🌹 in Martha's Vineyard & San Francisco** 