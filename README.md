# Movie App

A Flutter app for browsing and managing movies, featuring movie details, genres, and ratings. The app supports saving favorite movies and handles offline scenarios.

## DONE

Simple version: ALL
Advanced version: ALL

## Features

Fetch the genres from the API to be able to associate the genre ids with the genre names
● Fetch popular movies from the API
● Cache the movies into a database of your choice (Hive, sqflite,...)
● Implement pagination when fetching movies
● Use the api_key as the query parameter in each request in order to successfully authorise
the API requests
● When the user selects a movie, open the details page
● Implement the navigation bar
● Add the favourite movies feature - NOTE: the user can toggle the movie as a favourite in the
Movie list, Favourites list and in the Movie details page
● Cache the favourite movies into a database of your choice
● Bearer token header authorization
● Show notification when user is offline - NOTE: show cached movies but let the user know he is
offline
● Add some animation transition between overview and details page

## Dependencies

- `http: ^0.13.5` - For making HTTP requests.
- `sqflite: ^2.0.0+4` - For local database storage.
- `path_provider: ^2.0.11` - For finding the correct paths on the filesystem.
- `provider: ^6.0.5` - For state management.
- `flutter_svg: ^1.1.6` - For rendering SVG images.
- `dio: ^5.0.3` - For advanced HTTP requests.
- `connectivity_plus: ^3.0.3` - For checking network connectivity.
- `path: ^1.8.3` - For manipulating paths.

## Setup

1. **Clone the repository:**

   ```bash
   git clone https://github.com/yourusername/movie_app.git
   cd movie_app

Acknowledgements

    Flutter - The framework used to build the app. (FLUTTER SDK: 3.16.5, DART SDK: 3.2.3)
    The Movie Database (TMDb) - Provides movie data.  