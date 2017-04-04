# Project 1 - *Flicks Movie*

**Flicks Movie** is a movies app using the [The Movie Database API](http://docs.themoviedb.apiary.io/#).

Time spent: 8 hours spent in total

## User Stories

The following **required** functionality is completed:

- [x] User can view a list of movies currently playing in theaters. Poster images load asynchronously.
- [x] User can view movie details by tapping on a cell.
- [x] User sees loading state while waiting for the API.
- [x] User sees an error message when there is a network error.
- [x] User can pull to refresh the movie list.

The following **optional** features are implemented:

- [x] Add a tab bar for **Now Playing** and **Top Rated** movies.
- [x] Implement ~~segmented~~ control to switch between list view and grid view.
- [x] Add a search bar.
- [x] All images fade in.
- [x] For the large poster, load the low-res image first, switch to high-res when complete.
- [x] Customize the highlight and selection effect of the cell.
- [x] Customize the navigation bar.

The following **additional** features are implemented:

- [x] Activity Indicator used when user searches in the search bar
- [x] Animate showing/hiding the bottom navigation bar and UILabel depending on the scroll view's state (e.g. begin dragging) in the MovieDetailViewController

## Video Walkthrough

Here's a walkthrough of implemented user stories:
<!-- ![](https://media.giphy.com/media/3oKIP7hu9IbtR3crni/giphy.gif)

![](https://media.giphy.com/media/l0IynChAHsS2M8gIo/giphy.gif) -->

![](./screencast/screen1.gif)

![](./screencast/screen2.gif)

## Notes
- I originally created two UIViewController classes for listing movies of Now Playing and Top Rated, but I noticed that more than 98% of the code is identical:

    To keep the code less redundant, I decided to do a huge refactoring - creating a generic **MovieListViewController** class that can be used for both **Now Playing** and **Top Rated**. It turned out to be a very nice design - saving me an entire class of code (approximately 200 LOC!)

- I created a custom tab bar controller that is added as the RootViewController to the *key window*, which is a nice adventure that works very well :tada:

## License

The MIT License
Copyright (c) [Tony Wang] https://github.com/rcholic/CodePath-FlicksMovie

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
