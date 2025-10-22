# Changelog

All notable changes to TapDash will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-10-22

### Added
- Core Flame game loop with player, obstacle, and scoring systems
- Player component with one-tap direction flip mechanic
- Continuous forward motion with manual velocity control
- Dynamic obstacle spawning with randomized spacing
- AABB collision detection system triggering game over
- Distance-based scoring system (1 point per 10 units)
- High score tracking within game session
- Instant restart flow (<0.3s restart time)
- Real-time FPS monitoring and display
- Modular folder structure (/game, /ui, /utils)
- Production-ready code with null safety
- Game launches directly into gameplay (no menus)
- Automatic direction flip at ceiling and ground boundaries
- Visual direction indicator on player
- Game over overlay with score display
- Landscape orientation lock for optimal gameplay
- Immersive system UI mode

### Technical Details
- Player speed: 200 px/s forward, 150 px/s vertical
- Obstacle spacing: 300-500 pixels (randomized)
- Game resolution: 800x600 (scaled to device)
- Target FPS: 60+
- Zero physics engine usage for maximum responsiveness

### Architecture
- Separation of concerns: game logic, UI, and utilities
- Singleton pattern for ScoreManager
- Component-based architecture using Flame
- Clean code following Flutter best practices

## [Unreleased]

### Planned for Sprint 2 - Polish & Feedback
- Sound effects for tap, collision, and scoring
- Particle effects on collision
- Screen shake feedback
- Score animations
- Multiple obstacle types/colors

### Planned for Sprint 3 - Progression System
- Progressive difficulty scaling
- Power-ups (shield, slow-mo, score multiplier)
- Achievement system
- Daily challenges

### Planned for Sprint 4 - Social & Persistence
- Firebase/Supabase integration
- Global leaderboard
- Friend comparisons
- Social sharing
- Cloud save synchronization
- Persistent high score storage

---

[1.0.0]: https://github.com/yourusername/tap_dash_game/releases/tag/v1.0.0
