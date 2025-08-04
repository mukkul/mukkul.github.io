# Abhishek Singh's Portfolio Website

A modern, interactive portfolio website built with Flutter showcasing my skills, experience, and projects as a Senior Software Engineer.

## 🚀 Features

### ✨ Interactive Animations
- **Scroll Reveal Animations**: Sections animate in as you scroll down the page
- **Particle Effects**: Floating particles with connecting lines for a futuristic feel
- **Animated Text**: Typewriter and fade animations for dynamic text display
- **Smooth Transitions**: Elegant animations between sections and interactions

### 🎨 Modern UI/UX
- **Responsive Design**: Works perfectly on desktop, tablet, and mobile devices
- **Dark/Light Theme**: Toggle between dark and light themes with smooth transitions
- **Glass Morphism**: Blurred navigation header with backdrop filter effects
- **Neon Effects**: Glowing buttons and borders for a futuristic aesthetic

### 📱 Multi-Section Layout
- **Hero Section**: Animated introduction with contact information
- **About Section**: Personal introduction and background
- **Skills Section**: Interactive skill bars with progress indicators
- **Experience Preview**: Highlighted work experience with "View All" option
- **Projects Preview**: Featured projects with technology stack
- **Contact Form**: Interactive contact form for recruiters

### 💼 Professional Features
- **Resume Download**: One-click resume download for recruiters
- **Contact Form**: Professional contact form with validation
- **Navigation**: Smooth scroll navigation between sections
- **Social Links**: Direct links to LinkedIn, email, and phone

## 🛠️ Technical Stack

- **Framework**: Flutter
- **Language**: Dart
- **State Management**: Provider
- **Navigation**: Go Router
- **Animations**: Custom animation controllers + Animated Text Kit
- **UI Components**: Custom widgets with Material Design
- **Particles**: Custom particle system
- **Scroll Effects**: Scroll to Index + Custom reveal animations

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.2
  lottie: ^2.7.0
  animated_text_kit: ^4.2.2
  flutter_staggered_animations: ^1.1.1
  font_awesome_flutter: ^10.6.0
  google_fonts: ^6.1.0
  go_router: ^12.1.3
  provider: ^6.1.1
  url_launcher: ^6.2.5
  flutter_svg: ^2.0.9
  particles_flutter: ^1.0.1
  scroll_to_index: ^3.0.1
  path_provider: ^2.1.1
  form_validator: ^2.1.1
```

## 🎯 Key Features for Recruiters

### 📄 Resume Download
- Prominent "Download Resume" button in the hero section
- Direct access to professional resume in PDF format
- Fallback to LinkedIn profile for easy access

### 📧 Contact Form
- Professional contact form with validation
- Fields for name, email, and message
- Real-time form validation
- Success/error feedback messages
- Backend integration ready

### 🎨 Interactive Experience
- Smooth scroll navigation between sections
- Reveal animations as sections come into view
- Hover effects on interactive elements
- Responsive design for all devices

## 🚀 Getting Started

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/portfolio.git
   cd portfolio
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the application**
   ```bash
   flutter run -d chrome
   ```

## 📱 Supported Platforms

- ✅ Web (Chrome, Firefox, Safari, Edge)
- ✅ Mobile (iOS, Android)
- ✅ Desktop (Windows, macOS, Linux)

## 🎨 Customization

### Colors and Themes
The app uses a custom theme system with:
- Primary neon colors for dark theme
- Gradient colors for light theme
- Easy customization in `lib/core/theme/app_theme.dart`

### Animations
- Scroll reveal animations can be customized in `lib/presentation/widgets/scroll_reveal_animation.dart`
- Particle effects can be modified in `lib/presentation/widgets/particles/particle_widget.dart`

### Content
- Update personal information in the respective section methods
- Modify skills, experience, and projects in the home screen
- Add new sections by extending the scroll controller

## 🔧 Development

### Project Structure
```
lib/
├── core/
│   ├── providers/
│   └── theme/
├── models/
├── presentation/
│   ├── screens/
│   └── widgets/
├── services/
└── main.dart
```

### Key Widgets
- `HomeScreen`: Main portfolio page with all sections
- `AnimatedGradientBackground`: Animated background with grid
- `NeonButton`: Interactive neon-styled buttons
- `ParticleWidget`: Floating particle effects
- `ScrollRevealAnimation`: Scroll-triggered animations

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📞 Contact

- **Email**: abhishekvsingh1@gmail.com
- **LinkedIn**: [Abhishek Vinod Singh](https://www.linkedin.com/in/abhishek-vinod-singh/)
- **Phone**: +91 8446059660

---

Built with ❤️ using Flutter
