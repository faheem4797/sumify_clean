# Sumify

**Sumify** is an AI-powered Flutter application that allows users to generate summaries, titles, reports, and comments for articles or text content. The project demonstrates a clean architecture approach with Bloc state management, ensuring maintainable and scalable code. Comprehensive unit testing was employed to ensure reliability.

---

## Features

- **Automatic Title Suggestion**: Generate concise and relevant article titles.
- **Article Summarization**: Write or paste an article, and get a summarized version.
- **Report Generation**: Generate detailed reports based on the input article.
- **Comment Generation**: Create realistic, contextually appropriate comments for articles (similar to Facebook comments).
- **Profile Page**: Allows users to manage their profile.
- **Contact Us Page**: Users can reach out for support or feedback.

---

## Screenshots

### Onboarding

<p align="middle" float="left">
  <img align="top" src="https://github.com/user-attachments/assets/a5db8bb0-29ad-4e80-adcd-98c7982075e0" width="32%" />
  <img align="top" src="https://github.com/user-attachments/assets/24d75d9e-0cbb-4b38-8775-432f0bc84d62" width="32%" />
</p>


### Authentication

<p align="middle" float="left">
  <img align="top" src="https://github.com/user-attachments/assets/43bd0366-6c75-43df-901b-8a7ba30bf29e" width="32%" />
  <img align="top" src="https://github.com/user-attachments/assets/5b032979-1cc0-4a1f-82da-8695c300c454" width="32%" />
</p>

### Home Screen With Title and Summary Generation

<p align="middle" float="left">
  <img align="top" src="https://github.com/user-attachments/assets/8fc47477-6a51-444d-85f2-1e0ac3db1b39" width="32%" />
  <img align="top" src="https://github.com/user-attachments/assets/883ef1c0-124a-4607-8eae-a6e9a4f79e84" width="32%" />
  <img align="top" src="https://github.com/user-attachments/assets/93e83984-c6df-4592-9504-ec83bbe0f5c9" width="32%" />
</p>

### Report Generation

<p align="middle" float="left">
  <img align="top" src="https://github.com/user-attachments/assets/d94239cf-685d-40cc-b177-416fd333e4a9" width="32%" />
  <img align="top" src="https://github.com/user-attachments/assets/512923b7-d38e-40f7-8bbf-cfc46fd069c1" width="32%" />
</p>

### Comment Generation

<p align="middle" float="left">
  <img align="top" src="https://github.com/user-attachments/assets/11053ccb-6876-4081-be1e-1780d61d9df1" width="32%" />
  <img align="top" src="https://github.com/user-attachments/assets/9a6602fc-14ed-4d32-ad4e-fe6bf67897a5" width="32%" />
</p>

### Contact Us Page

<p align="middle" float="left">
  <img align="top" src="https://github.com/user-attachments/assets/ec59fe02-11f0-45c8-abf6-d56cbc752775" width="32%" />
  <img align="top" src="https://github.com/user-attachments/assets/260b85b4-5677-4ece-a016-93f0c02b2851" width="32%" />
</p>

### Profile Page

<p align="middle" float="left">
  <img align="top" src="https://github.com/user-attachments/assets/29379067-29ec-42ab-b87e-cfa549edcb05" width="32%" />
  <img align="top" src="https://github.com/user-attachments/assets/65589a30-3f76-4ac6-ad8e-83a7e28938be" width="32%" />
</p>

---

## Tech Stack

- **Frontend**: Flutter
- **Architecture**: Clean Architecture
- **State Management**: BLoC
- **Testing**: Unit Testing (mocktail and bloc_test)
- **Backend**: Firebase (Firestore for data storage, Firebase Storage for file handling)

---

## How to Run the Project

1. Clone this repository:

   ```bash
   git clone https://github.com/faheem4797/sumify_clean.git
   cd sumify_clean
   ```

2. Install dependencies:

   ```bash
   flutter pub get
   ```

3. Set up Firebase:

   - Create a Firebase project and enable Firestore and Firebase Storage.
   - Add the `google-services.json` file (for Android) and `GoogleService-Info.plist` file (for iOS) to the respective folders.

4. Run the app:

   ```bash
   flutter run
   ```

---

## Project Structure

This project follows a clean architecture structure:

- **Presentation**: UI components and Bloc for state management.
- **Domain**: Use cases and entities.
- **Data**: Repositories and remote/local data sources.

---

## Contributions

Contributions are welcome! If you'd like to contribute, please fork the repository and create a pull request.

---

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

## Contact

For any queries or suggestions, please contact:

- **Name**: Muhammad Faheem Amin
- **Email**: [mfaheemamin4797@gmail.com](mailto\:mfaheemamin4797@gmail.com)
- **GitHub**: [faheem4797](https://github.com/faheem4797)/

