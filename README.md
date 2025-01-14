# setup for local environment #

```
* `make init`: check out all repositories and create network
========================

## After checkout all repository, run the following commands:
* `make dev`: run all containers for development
```

# IF NOT USE GNU MAKE #
From here:

- git clone https://github.com/quocthuan920/ascend-entry-test.git
- cd ./ascend-entry-test
- npm install 
- cp ./.env.local ./.env
- cp ./id_rsa_priv_local.pem ./id_rsa_priv.pem
- docker network ls | grep ascend-stack > /dev/null || docker network create ascend-stack
- cd ../
- docker compose -f ./docker-compose.dev.yml down && docker compose -f ./docker-compose.dev.yml up --build -d

# URL #
- Server run at: http://localhost:8000
- Swagger: http://localhost:8000/docs/dlZwSzZJKnmhc2iMv0AqBD79NV3FsjhoWjWDbQOacO7M

===============================
# Database Schema

This project uses MongoDB as the database, with Mongoose as the ODM (Object Data Modeling) library. Below is an explanation of the database schema for the project.

## Collections

### 1. Users

The `users` collection stores information about the users of the application.

#### Schema Definition

```javascript
const userSchema = new Schema(
  {
    name: {
      type: String,
      required: true,
    },
    email: {
      type: String,
      required: true,
      unique: true,
    },
    password: {
      type: String,
      required: true,
    },
    status: {
      type: String,
      default: "active",
    },
    verify: {
      type: Boolean,
      default: false,
    },
    role: {
      type: String,
      enum: ["admin", "user"],
      default: "user",
    },
  },
  {
    timestamps: true,
    collection: "users",
  }
);
```
#### Fields
- name: The name of the user (String, required).
- email: The email address of the user (String, required, unique).
- password: The password of the user (String, required).
- status: The status of the user account (String, default: "active").
- verify: Whether the user's email is verified (Boolean, default: false).
- role: The role of the user, either "admin" or "user" (String, default: "user").
- timestamps: Automatically adds createdAt and updatedAt fields.

### 2. Movies
The movies collection stores information about the movies.

#### Schema Definition
```javascript
const movieSchema = new Schema(
  {
    title: {
      type: String,
      required: true,
    },
    genre: {
      type: String,
      required: true,
    },
    releaseYear: {
      type: Number,
      required: true,
    },
    averageRating: {
      type: Number,
      default: 0,
    },
    createdBy: {
      type: Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },
  },
  {
    timestamps: true,
    collection: "movies",
  }
);
```
#### Fields
- title: The title of the movie (String, required).
- genre: The genre of the movie (String, required).
- releaseYear: The release year of the movie (Number, required).
- averageRating: The average rating of the movie (Number, default: 0).
- createdBy: The user who created the movie entry (ObjectId, reference to User, required).
- timestamps: Automatically adds createdAt and updatedAt fields.
#### Middleware
- pre("findOneAndDelete"): Before deleting a movie, all associated ratings are also deleted.

### 3. Ratings
The ratings collection stores ratings given by users to movies.

#### Schema Definition
```javascript
const ratingSchema = new Schema(
  {
    user: {
      type: Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },
    movie: {
      type: Schema.Types.ObjectId,
      ref: "Movie",
      required: true,
    },
    score: {
      type: Number,
      required: true,
      min: 1,
      max: 5,
    },
    comment: {
      type: String,
      default: null,
    },
  },
  {
    timestamps: true,
    collection: "ratings",
  }
);
```
#### Fields
- user: The user who gave the rating (ObjectId, reference to User, required).
- movie: The movie that was rated (ObjectId, reference to Movie, required).
- score: The rating score (Number, required, between 1 and 5).
- comment: An optional comment about the movie (String, default: null).
- timestamps: Automatically adds createdAt and updatedAt fields.

### Relationships
- A Admin User can create multiple Movies.
- A User can give multiple Ratings. But limit 1 rating per 1 movie.
- A Movie can have multiple Ratings.

### Middleware
When a Movie is deleted, all associated Ratings are also deleted.