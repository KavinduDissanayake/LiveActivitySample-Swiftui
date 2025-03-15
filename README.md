![Untitled](https://github.com/user-attachments/assets/e980e6af-0286-4a01-9243-a5ce20d0a163)

### Video Demonstration
[Watch on LinkedIn](https://www.linkedin.com/posts/kavindu-dissanayake-92a8791b4_ios-liveactivities-swift-activity-7306007865423446017-KwU-?utm_source=share&utm_medium=member_desktop&rcm=ACoAADH2WPIBJyR5-LrZANtlCngFFzlyz-brAyE)


# Live Activity Setup Guide

## Frontend Setup

1. Add your `GoogleService-Info.plist` file to your Xcode project.
2. Enable **Signing & Capabilities** in your project settings.

## Backend Setup

1. Add your `Auth.p8` file inside the `live-activity-backend` folder.
2. Update the `index.ts` file with the following details:
   - **teamID**
   - **keyID**
   - **p8FilePath**
   - **bundleID**
3. Deploy the Firebase functions by running the following command inside the `functions` folder:
   ```sh
   firebase deploy --only functions
   ```

## Testing the Setup

1. Navigate to the `TestingJsonCreate` folder using the terminal.
2. Run the following commands to generate JSON responses:

   - To get the **start** JSON response:
     ```sh
     swift run JSONPayload 1
     ```
   - To get the **update** JSON response:
     ```sh
     swift run JSONPayload 2
     ```
   - To get the **end** JSON response:
     ```sh
     swift run JSONPayload 3
     ```

3. Log in to your **Apple Push Notification Console** and test the setup:  
   [Apple Push Notification Console](https://developer.apple.com/notifications/push-notifications-console/)

4. Use the **start token** to initiate the live activity.
5. To update or delete the live activity:
   - Use the **update live activity token**.
   - Ensure you update the **timestamp**, otherwise, the request will not work.
6. If everything is set up correctly, you should receive a `200` status response from Apple.

## Sending Notifications from Apple Push Notification Console

1. Add your **device token**.
2. Set the **APNs type** to `liveactivity`.
3. Set your **payload**.
4. Click the **Send** button.

---

### Screenshots

![Push Notification Console](https://github.com/user-attachments/assets/70fa2915-affc-44c2-83de-08f273aac6ac)

![CloudKit-Push-Notifications](https://github.com/user-attachments/assets/63e3ef28-572a-4132-a2f6-e505895e9e88)

You are now ready to work with Live Activities! 🚀










