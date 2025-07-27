# Prompt Dadi

A native macOS app for organizing and managing AI prompts. Built with SwiftUI.

## Features

- **Two-pane interface**: Folder navigation on the left, prompts list on the right
- **Create and delete prompts**: Simple prompt management with title and text
- **Folder organization**: Organize prompts into custom folders
- **Copy to clipboard**: Right-click prompts to copy text
- **Native macOS design**: Follows Apple's design guidelines
- **Persistent storage**: Data saved locally using UserDefaults

## Building the App

1. Open `PromptDadi.xcodeproj` in Xcode
2. Select your Mac as the target device
3. Click the Run button (▶️) or press Cmd+R

## Usage

- **Add folders**: Click the + button next to "Folders" in the left pane
- **Add prompts**: Click the + button in the right pane when a folder is selected
- **Delete prompts**: Right-click a prompt and select "Delete"
- **Copy prompt text**: Right-click a prompt and select "Copy Text"
- **Delete folders**: Click the trash icon next to folder names (except "General")

## Requirements

- macOS 14.0 or later
- Xcode 15.0 or later

## App Structure

- `PromptDadiApp.swift`: Main app entry point
- `ContentView.swift`: Main UI with two-pane layout
- `Prompt.swift`: Data model for prompts
- `PromptManager.swift`: Data management and persistence 