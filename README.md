# OpenChatApp - LINE-style Anonymous Chat App

A modern, anonymous chat application built with SwiftUI that allows users to join chat rooms and participate in conversations without revealing their real identity.

## Features

### 🚀 Core Functionality
- **Anonymous Chat**: Users can chat without revealing personal information
- **Multiple Chat Rooms**: Join different topic-based chat rooms
- **Real-time Messaging**: Instant message delivery and updates
- **User Avatars**: Colorful, customizable avatars with initials
- **Room Categories**: Organized rooms by topics (Gaming, Music, Technology, etc.)

### 🎨 User Experience
- **LINE-style Interface**: Familiar chat bubble design with modern aesthetics
- **Responsive Design**: Optimized for both iPhone and iPad
- **Dark Mode Support**: Automatic adaptation to system appearance
- **Smooth Animations**: Fluid transitions and interactions
- **Search & Filter**: Easy room discovery with search and category filtering

### 🔒 Privacy & Security
- **Anonymous Users**: No personal data collection
- **Random Nicknames**: Auto-generated anonymous usernames
- **No Registration**: Start chatting immediately
- **Temporary Sessions**: No persistent user accounts

## Screenshots

The app features:
- **Room List**: Browse available chat rooms with participant counts
- **Chat Interface**: LINE-style message bubbles with user avatars
- **User Profile**: Customize nickname and avatar color
- **Room Creation**: Create new chat rooms with custom categories

## Technical Details

### Architecture
- **SwiftUI**: Modern declarative UI framework
- **MVVM Pattern**: Clean separation of concerns
- **Combine**: Reactive programming for state management
- **iOS 17+**: Latest iOS features and design guidelines

### Key Components
- `ChatViewModel`: Central state management
- `User`: Anonymous user model with avatar support
- `ChatRoom`: Room management and participant tracking
- `ChatMessage`: Message handling and display
- `MessageBubbleView`: Custom chat bubble implementation

### Data Models
```swift
struct User {
    let id: String
    var nickname: String
    var avatarColor: String
    var isOnline: Bool
    var lastSeen: Date
}

struct ChatRoom {
    let id: String
    let name: String
    let description: String
    let category: RoomCategory
    var participants: [User]
    var messages: [ChatMessage]
}

struct ChatMessage {
    let id: String
    let content: String
    let sender: User
    let timestamp: Date
    let messageType: MessageType
}
```

## Getting Started

### Prerequisites
- Xcode 15.0 or later
- iOS 17.0 or later
- macOS 14.0 or later (for development)

### Installation
1. Clone the repository
2. Open `OpenChatApp.xcodeproj` in Xcode
3. Select your target device or simulator
4. Build and run the project

### Usage
1. **Launch the App**: The app starts with a room list
2. **Join a Room**: Tap on any chat room to enter
3. **Start Chatting**: Type messages in the input field
4. **Customize Profile**: Tap your avatar to change nickname/color
5. **Create Rooms**: Use the + button to create new chat rooms

## Deployment with Fastlane

This project includes a complete Fastlane setup for automated iOS deployment.

### Prerequisites for Deployment
- Ruby 2.6 or later
- Apple Developer Account
- App Store Connect API Key

### Quick Start
1. **Install dependencies:**
   ```bash
   bundle install
   ```

2. **Setup the project:**
   ```bash
   ./deploy.sh setup          # macOS/Linux
   .\deploy.ps1 setup         # Windows
   ```

3. **Deploy to TestFlight:**
   ```bash
   ./deploy.sh beta           # macOS/Linux
   .\deploy.ps1 beta          # Windows
   ```

4. **Submit to App Store:**
   ```bash
   ./deploy.sh release        # macOS/Linux
   .\deploy.ps1 release       # Windows
   ```

### Available Commands
- `setup` - Setup project and install dependencies
- `build` - Build app for development
- `test` - Run tests
- `beta` - Deploy to TestFlight
- `release` - Submit to App Store
- `ci_release` - CI-friendly non-interactive release (for GitHub Actions)
- `clean` - Clean build artifacts

### Configuration
1. Edit `fastlane/Appfile` with your app details
2. Configure App Store Connect API key in `fastlane/AppStoreConnect_API_Key.json`
3. Update bundle identifier in Xcode project
4. Optional: Place metadata in `fastlane/metadata` to be used by deliver

For detailed Fastlane documentation, see [fastlane/README.md](fastlane/README.md).

## Room Categories

The app includes predefined categories:
- 🗣️ **General**: General discussions
- 🎮 **Gaming**: Gaming-related conversations
- 🎵 **Music**: Music discussions and sharing
- ⚽ **Sports**: Sports talk and updates
- 💻 **Technology**: Tech discussions and programming
- 🎬 **Entertainment**: Movies, TV shows, and media
- 💚 **Lifestyle**: Health, fitness, and wellness
- 📰 **News**: Current events and politics
- 🎲 **Random**: Miscellaneous conversations

## Customization

### User Profile
- **Nickname**: Set a custom anonymous name
- **Avatar Color**: Choose from 20+ color options
- **Real-time Updates**: Changes apply immediately

### Room Management
- **Create Rooms**: Add new chat rooms with custom names
- **Category Selection**: Choose appropriate room categories
- **Description**: Add room descriptions for context

## Future Enhancements

Potential features for future versions:
- **Stickers & Emojis**: Enhanced expression options
- **Image Sharing**: Photo and media support
- **Voice Messages**: Audio communication
- **Private Messages**: Direct user-to-user chat
- **Room Moderation**: Admin tools and content filtering
- **Push Notifications**: Real-time activity alerts
- **Offline Support**: Message caching and sync

## Contributing

This is a sample project demonstrating SwiftUI best practices. Feel free to:
- Report bugs or issues
- Suggest new features
- Submit pull requests
- Share your modifications

## License

This project is provided as-is for educational and demonstration purposes.

## Support

For questions or support:
- Check the code comments for implementation details
- Review the SwiftUI documentation
- Explore iOS development resources
- For deployment issues, see the [Fastlane documentation](fastlane/README.md)

---

**Built with ❤️ using SwiftUI and modern iOS development practices**