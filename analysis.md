## Dataset Introduction

For this analysis, I used the smaller dataset provided by MovieLens, although MovieLens offers larger datasets for more in-depth analysis and more precise recommendations. This dataset (ml-latest-small) describes 5-star rating and free-text tagging activity from [MovieLens](http://movielens.org), a movie recommendation service. It contains 100,836 ratings and 3,683 tag applications across 9,742 movies. These data were created by 610 users between March 29, 1996, and September 24, 2018. This dataset was generated on September 26, 2018.

Users were randomly selected for inclusion. All selected users had rated at least 20 movies. No demographic information is included. Each user is represented by an ID, and no other information is provided.

## Movie Ratings Distribution

### Distribution of Movie Ratings

The analysis of the rating distribution reveals a predominance of scores above 3, with significantly fewer low ratings (below 3). The mode of the ratings is 4, indicating that whole number ratings are more common than fractional ratings (e.g., 1.5 or 2.5).

### Top-Rated Movies

I identified the top-rated movies by computing their average rating. This analysis shows the distribution of average movie ratings, with a noticeable absence of movies rated either 1 or 5. Movies with fewer than 10 ratings were excluded from this analysis.

### Relevant Movie Ratings Distribution

After filtering out movies with fewer than 10 ratings, this analysis displays the distribution of average ratings for relevant movies. The distribution appears more continuous after removing outliers.

## User Ratings Distribution

### Distribution of User Ratings

Similar to the movie ratings, this analysis shows the distribution of user ratings. The majority of users tend to give higher ratings, with fewer ratings below 3.

### Relevant User Ratings Distribution

By considering only users with more than 200 ratings, this analysis depicts the distribution of average ratings among relevant users. It helps in understanding the preferences of more active users in the dataset.

## Similarity Analysis

### Film Similarity Based on Ratings

This analysis represents the similarity between movies based on the ratings given by users. Movies that receive similar ratings from users are considered more similar. This is crucial for the recommendation system.
