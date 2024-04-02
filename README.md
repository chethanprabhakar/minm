# Minm

This is a simple Flutter app to catalog, manage and share books with the community.

## Features

- Add new books by entering details like name, author, publisher and barcode
- Form validation to ensure required fields are entered
- Submit button to save new book entries

## Code Overview

The main.dart file contains:

- MyApp - The root widget that sets up the MaterialApp
- MyHomePage - Stateful widget that contains the main UI
- MyHomePageState - State class that builds the UI and handles form submission

The UI consists of:

- AppBar with title
- Padding widget for spacing
- Form widget with validation and text fields for book details
- ElevatedButton to submit the form

The text fields use Controllers to retrieve input data. Form validation is implemented to require book name, author, publisher and barcode.

When the submit button is tapped, form validation is checked before saving the book data.

## Next Steps

Some ideas for extending the app:

- Display saved books in a ListView
- Implement delete book functionality
- Add book images/covers
- Use local database or API to persist data
- Search books by title, author etc
