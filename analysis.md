## Dataset Introduction

For this analysis, I used the smaller dataset provided by MovieLens, although MovieLens offers larger datasets for more in-depth analysis and more precise recommendations. This dataset (ml-latest-small) describes 5-star rating and free-text tagging activity from [MovieLens](http://movielens.org), a movie recommendation service. It contains 100,836 ratings and 3,683 tag applications across 9,742 movies. These data were created by 610 users between March 29, 1996, and September 24, 2018. This dataset was generated on September 26, 2018.

Users were randomly selected for inclusion. All selected users had rated at least 20 movies. No demographic information is included. Each user is represented by an ID, and no other information is provided.

![rating_distribution](https://github.com/walele993/pick_a_movie/assets/64219379/87b51568-36e0-4855-9305-3075851c64bf)

The analysis of the rating distribution shows that the mode of the ratings is 4, indicating that whole number ratings are more common than fractional ratings (e.g., 1.5 or 2.5). We will delve deeper into the distribution later on.

![highest_number_of_votes](https://github.com/walele993/pick_a_movie/assets/64219379/d0054916-4567-4716-8e56-43b538bfcec5)

The movie with the highest number of votes is "Forrest Gump (1994)". Below are nine other movies with a high number of votes.

## Movie Ratings Distribution


![avg_rating_movie](https://github.com/walele993/pick_a_movie/assets/64219379/ef2f89f2-9293-4a43-87c3-0cc7eef6ee47)

The analysis of the rating distribution reveals a predominance of scores above 3, with significantly fewer low ratings (below 3). The trend highlights what we've seen in the first plot: users tend to assign integer ratings more frequently than fractional ones (e.g., 1.5 or 2.5).


![avg_rating_relevant_movies](https://github.com/walele993/pick_a_movie/assets/64219379/f9196612-4b5f-43f6-b372-e824e9767c57)

Then, I focused on films with a significant number of ratings (more than 10). This analysis provides insights into how ratings are distributed among the relevant subset of movies.
The distribution appears more continuous after removing outliers.


![movie_density](https://github.com/walele993/pick_a_movie/assets/64219379/57508658-206a-4152-89c5-73048de35ef8)

The graph above shows the comparison between the distribution of ratings for all movies and that for relevant movies. Setting a relevance threshold improves the quality and reliability of the analysis by excluding extremes and making the distribution more consistent.

## User Ratings Distribution


![avg_rating_user](https://github.com/walele993/pick_a_movie/assets/64219379/442e81ff-15de-457c-abd5-5f9f065ca3f8)

Similar to the movie ratings, this analysis shows the distribution of user ratings. The majority of users tend to give higher ratings, with fewer ratings below 3.


![avg_rating_relevant_user](https://github.com/walele993/pick_a_movie/assets/64219379/4c919e7e-4e6a-4ed6-8763-c4509bc1e41c)

To include only users with a significant number of ratings, a relevance threshold of 200 ratings per user was set. The distribution of ratings for relevant users shows improved continuity and reliability.


![user_density](https://github.com/walele993/pick_a_movie/assets/64219379/75cc4a83-9721-483c-9bd5-28d2bdabe082)

The graph above illustrates the comparison between the distribution of ratings for all users and that for relevant users. Establishing a relevance threshold enhances the quality of the analysis by excluding extremes and creating a more uniform distribution.

## Similarity Analysis


![user_similarity](https://github.com/walele993/pick_a_movie/assets/64219379/10a3e485-75a0-4c76-a5bb-21d9a59f3f14)

The above chart represents the similarity between users based on their ratings. This allows for the identification of user groups with similar tastes, which is useful for personalized recommendations.

*To make it more readable, I selected only the first 18 users; of course, the analysis was conducted on all values.*


![genre_similarity](https://github.com/walele993/pick_a_movie/assets/64219379/e3d3f35e-ae80-47fc-8438-23aaaca78d0d)

This chart shows the similarity between movies based on their genres. Identifying movies with similar genres helps in suggesting films that might appeal to a user based on their previous preferences.

*To make it more readable, I selected only the first 18 movies; of course, the analysis was conducted on all values.*


![movie_similarity](https://github.com/walele993/pick_a_movie/assets/64219379/0181b3dc-db6b-4adf-a4b7-8f8129c8a88e)

The above chart represents the similarity between movies based on user ratings. By utilizing clustering techniques and rating correlation, it is possible to determine the similarity between movies based on user rating patterns. For example, if the same user has given high or low ratings to two movies, these movies are considered similar. This analysis is crucial for building an effective recommendation system as it allows for suggesting movies that might interest the user based on the preferences of other users with similar tastes.

*To make it more readable, I selected only the first 18 movies; of course, the analysis was conducted on all values.*
