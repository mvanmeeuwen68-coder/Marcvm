# BeachGrooves Radio — Black & White Luxury iOS app

## Open and run
1. On a Mac with Xcode 15 or later, open `BeachGroovesRadio.xcodeproj`.
2. Select the `BeachGroovesRadio` target > Signing & Capabilities, choose your Apple development team, and change the bundle identifier if needed.
3. Select an iPhone or simulator and press Run. For actual audio, test on a physical iPhone.

## Included
- Black-and-white SwiftUI radio interface, official uploaded logo, app icon, share button, volume control, and About page.
- AVPlayer radio streaming from `http://stream.beachgrooves.com:8080/`.
- Background audio configuration, lock-screen play/pause commands, and an HTTP exception limited to the stream host.

## Important limitations
- The stream endpoint and format have **not been verified**; the app cannot guarantee audio until tested.
- “Live on air” reflects the app's play state, not confirmed server connectivity.
- No dynamic track metadata, favorites, or show schedule is implemented.
- The website link is `https://beachgrooves.com` and should be verified before release.
- HTTPS streaming is recommended if available. Provide privacy/support URLs and test on a real device before App Store submission.
- This project was assembled outside macOS and has not been compiled with Xcode.
