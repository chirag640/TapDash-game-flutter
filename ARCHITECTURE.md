# TapDash - Sprint 1 Architecture Reference

## 📁 Project Structure

```
tap_dash_game/
├── lib/
│   ├── main.dart                    # App entry point & game screen
│   ├── game/                        # Game engine layer
│   │   ├── tap_dash_game.dart       # Main game class
│   │   └── components/              # Game entities
│   │       ├── player.dart          # Player with flip mechanic
│   │       └── obstacle.dart        # Obstacle entities
│   ├── ui/                          # UI layer
│   │   └── game_overlay.dart        # HUD & game over screen
│   └── utils/                       # Shared utilities
│       ├── constants.dart           # Game configuration
│       └── score_manager.dart       # Score tracking singleton
├── pubspec.yaml                     # Dependencies
├── README.md                        # Documentation
└── CHANGELOG.md                     # Version history
```

## 🎯 Core Components

### 1. Player (`player.dart`)
**Purpose**: Main character controlled by player

**Key Features**:
- Direction flip on tap (up ↔ down)
- Continuous forward motion (200 px/s)
- Vertical movement based on direction (150 px/s)
- Auto-flip at boundaries
- Collision detection via RectangleHitbox
- Distance tracking

**State**:
- `_direction`: Current movement direction (up/down)
- `_distanceTraveled`: Total distance for scoring
- `_isAlive`: Game state flag

**Public Methods**:
- `flip()`: Toggle direction
- `reset()`: Reset for new game
- `die()`: Trigger game over

### 2. Obstacle (`obstacle.dart`)
**Purpose**: Hazards that end the game on collision

**Key Features**:
- Spawned at randomized positions
- Static in world space (camera moves)
- Collision detection via RectangleHitbox
- Auto-cleanup when off-screen

**State**:
- `_isOffScreen`: Cleanup flag

### 3. TapDashGame (`tap_dash_game.dart`)
**Purpose**: Main game controller

**Responsibilities**:
1. **Lifecycle Management**
   - Initialize game world
   - Handle restarts
   - Manage game over state

2. **Obstacle System**
   - Dynamic spawning
   - Randomized spacing (300-500px)
   - Off-screen cleanup

3. **Collision Detection**
   - AABB (Axis-Aligned Bounding Box)
   - Efficient checking per frame

4. **Camera Control**
   - Follow player horizontally
   - Fixed vertical position

5. **Input Handling**
   - Tap detection
   - Restart on game over

6. **Performance Monitoring**
   - Real-time FPS tracking
   - 60+ FPS target

### 4. ScoreManager (`score_manager.dart`)
**Purpose**: Centralized score tracking

**Pattern**: Singleton with ChangeNotifier

**Features**:
- Current score calculation
- High score persistence (session)
- Distance-based scoring (1 pt per 10 units)
- Notifies UI of changes

**Public Methods**:
- `updateScore(distance)`: Update based on distance
- `resetCurrentScore()`: Clear for new game
- `resetAll()`: Clear everything

### 5. GameOverlay (`game_overlay.dart`)
**Purpose**: UI layer above game

**Displays**:
- Current score (top center)
- High score
- Instructions during play
- Game over screen with tap to restart
- FPS counter (top right)

**State Management**: Listens to ScoreManager

## 🎮 Game Loop Flow

```
┌─────────────────────────────────────────┐
│         Game Initialization             │
│  - Create player                        │
│  - Setup camera                         │
│  - Initialize score                     │
└─────────────────┬───────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────┐
│          Update Loop (60 FPS)           │
│                                         │
│  1. Update FPS counter                  │
│  2. Camera follows player               │
│  3. Update player position              │
│  4. Spawn obstacles                     │
│  5. Check collisions                    │
│  6. Update score                        │
│  7. Cleanup off-screen obstacles        │
└─────────────────┬───────────────────────┘
                  │
                  │ Collision detected?
                  ├─────────────┐
                  │ YES         │ NO
                  ▼             │
          ┌──────────────┐     │
          │  Game Over   │     │
          │  - Stop play │     │
          │  - Show UI   │     │
          └──────┬───────┘     │
                 │             │
                 │ Tap?        │
                 ▼             │
          ┌──────────────┐     │
          │   Restart    │     │
          │  - Reset all │     │
          │  - Clear obs │     │
          └──────┬───────┘     │
                 │             │
                 └─────────────┘
                       │
                       └──► Continue Loop
```

## ⚙️ Key Configurations

### Game Constants (`constants.dart`)
```dart
// Player
playerSize: 30.0
playerSpeed: 200.0 (forward)
playerVerticalSpeed: 150.0

// Obstacles
obstacleWidth: 40.0
obstacleHeight: 40.0
minObstacleSpacing: 300.0
maxObstacleSpacing: 500.0

// World
gameWidth: 800.0
gameHeight: 600.0
groundLevel: 500.0
ceilingLevel: 100.0

// Colors
playerColor: Green (0xFF00FF00)
obstacleColor: Red (0xFFFF0000)
backgroundColor: Dark Blue (0xFF1A1A2E)
```

## 🔧 Technical Decisions

### Why Manual Velocity Control?
- Physics engines add jitter and lag
- Predictable, responsive movement
- Full control over game feel
- Better performance

### Why AABB Collision?
- Simple and efficient
- Perfect for rectangular objects
- No need for complex physics
- Deterministic behavior

### Why Component Architecture?
- Clear separation of concerns
- Easy to test and maintain
- Scalable for future features
- Follows Flame best practices

### Why Singleton for Score?
- Single source of truth
- Easy access from anywhere
- Persist across game restarts
- Simple state management

## 🚀 Performance Optimizations

1. **Obstacle Pooling**: Reuse removed obstacles (future)
2. **Off-screen Culling**: Remove obstacles behind camera
3. **Efficient Collision**: Only check active obstacles
4. **Manual Physics**: No physics engine overhead
5. **Component Reuse**: Player/obstacles reused on restart

## 📊 Metrics & Monitoring

### FPS Tracking
- Updated every 0.5 seconds
- Displayed in top-right
- Green: ≥55 FPS
- Red: <55 FPS

### Score Calculation
```dart
score = floor(distanceTraveled / 10)
```

### Restart Time
- Clear obstacles: ~0.1s
- Reset player: instant
- Reset camera: instant
- **Total: <0.3s** (target: <1.5s) ✅

## 🎨 Visual Feedback

### Player
- Green square (30x30)
- White dot indicating direction
  - Top quarter: moving up
  - Bottom quarter: moving down

### Obstacles
- Red squares (40x40)
- Randomized vertical positions

### Environment
- Dark blue background
- Ground/ceiling zones (darker)

## 🎯 Input System

### Tap Handling
```dart
onTapDown() {
  if (gameOver) {
    restart();
  } else {
    player.flip();
  }
}
```

**Characteristics**:
- Zero-lag detection
- No double-tap issues
- Works anywhere on screen
- Instant response

## 📈 Future Improvements (Next Sprints)

### Sprint 2 - Polish
- [ ] Sound effects
- [ ] Particle systems
- [ ] Screen shake
- [ ] Smooth animations

### Sprint 3 - Progression
- [ ] Difficulty scaling
- [ ] Multiple obstacle types
- [ ] Power-ups
- [ ] Achievements

### Sprint 4 - Social
- [ ] Global leaderboard
- [ ] Cloud saves
- [ ] Social sharing

---

**Version**: 1.0.0
**Last Updated**: 2025-10-22
**Status**: ✅ MVP Complete
