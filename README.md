# groupGrub Backend

This is the API for [groupGrub Frontend](https://github.com/bjelinek42/groupGrub-front).

groupGrub is an app that aims to reduce the frustration when groups are trying to decide democratically where they will go out to eat together. Each user is a part of a group, and each user has a profile with favorite restaurants. When a group decides they want to go out to eat, a member can create a new vote which will take all the favorites from each user and find the top three most popular restaurants. These three restaurants will then be voted on by each member. Following the vote, the winning restaurant will be displayed on the group page. No more awkwardness deciding where to eat!

Usernames and passwords can be found in seeds file

View on heroku (still a work in progress): https://desolate-shore-45884.herokuapp.com/

## Installation

Uses Ruby 3.0.3 and Rails 7.0.2.3. Clone and bundle install

Clone

```bash
git clone https://github.com/bjelinek42/groupGrub-back.git
```

```bash
bundle install
```
Included seeds file will allow the app to run without having to add all new users and favorites. Just create, seed, and migrate. The first three groups (Ultimate, Party, and Lyft) are populated with favorites and are ready for votes. The final group (Home) is empty and let's you see what the experience is like without pre-existing members. 

```bash
rails db:create db:migrate db:seed
```

Remember to start the server

```bash
rails server
```

## Usage

post "/restaurants" => "restaurants#create" creates restaurants in the database when favoriting them, avoiding duplicates

"/restaurants/search" => "restaurants#find_city" find the location id of the city for searching restaurants

get "/restaurants/search" => "restaurants#search" uses the third party api to search for restaurants based on the city location id

"/vote_restaurants" => "vote_restaurants#index" shows the active votes

"/vote_restaurants" => "vote_restaurants#create" creates the votes using the top three restaurants compiled from all users in a group

"/vote_restaurants/:id" => "vote_restaurants#update" adds the restaurant votes and on the final vote tallies and saves the winning restaurant on the groups table to see on the groups page

### Known Problems

Currently when adding restaurants it is saving some but not others. The error is occuring in the create action when comparing the selected restaurant to the favorites table.

### Roadmap

-Ability to create groups

-Users can be in multiple groups

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License
MIT License

Copyright (c) 2022 Benjamin Jelinek

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.