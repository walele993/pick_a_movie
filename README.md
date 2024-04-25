# Film Recommendation Analysis

## Program Description

This program is designed to create a movie recommendation system using collaborative filtering based on both item-based and user-based approaches. It utilizes user ratings data to suggest new movies to users based on their preferences.

### Dependencies

The program relies on the following libraries:

- `recommenderlab`
- `data.table`
- `reshape2`
- `ggplot2`
- `tibble`

### Usage Instructions

To use the program, follow these steps:

1. Ensure you have R installed on your system.
2. Install the required libraries by running `install.packages(c("recommenderlab", "data.table", "reshape2", "ggplot2", "tibble"))`.
3. Make sure the working directory contains the `movies.csv` and `ratings.csv` CSV files in the `data` directory.
4. Run the provided R code to create a recommendation system and visualize the data analyses.

## Data Analysis
*An analysis of user ratings data will be published shortly.*

The program performs various analyses on movie and user ratings data, including:

- Distribution of ratings
- Number of views per movie
- Most viewed movies
- Distribution of average ratings per movie
- Density of average ratings relative to relevant ratings
- Distribution of average ratings per user
- Density of average ratings per user relative to relevant users

### Data Visualization

The program creates various types of graphs to visualize the data analyses, including:

- Histogram of rating distribution
- Histogram of the number of views per movie
- Histogram of the distribution of average ratings per movie
- Density of average ratings relative to relevant ratings
- Density of average ratings per user relative to relevant users

 *** 

## Recommender System Operation

The implemented recommendation system comprises two main models: IBCF (Item-Based Collaborative Filtering) and UBCF (User-Based Collaborative Filtering). Below are detailed descriptions of both models:

#### IBCF Model (Item-Based Collaborative Filtering):

- **Movie Selection**: Choose a reference movie for which recommendations are desired.
- **Calculation of Film Similarity**: Using an item similarity matrix, calculate the similarity between the reference movie and all other movies in the dataset.
- **Selection of Similar Movies**: Identify the movies most similar to the reference movie based on the calculated similarity.
- **User Interaction**: To provide personalized recommendations, the user is prompted to rate some of the selected similar movies.

#### UBCF Model (User-Based Collaborative Filtering):

- **Addition of User Ratings**: User ratings are integrated into the ratings dataset.
- **Normalization of Ratings**: To consider user rating behavior, ratings are normalized.
- **Calculation of User Similarity**: Using a user similarity matrix, calculate the similarity between the current user and other users in the dataset.
- **Selection of Similar Users**: Identify users most similar to the current user based on the calculated similarity.
- **Cross-Data with Genre Similarity**: User movie ratings are weighted based on their similarity to the initial user. These ratings are further weighted based on genre similarity to the initially proposed movie.

#### Recommendation Generation:

Finally, the top 8 movies are chosen to be recommended to the user based on the weights obtained from the cross-data of user ratings and genre similarity with the reference movie.

 *** 

## Additional Notes

- The data was sourced from MovieLens, a popular movie recommendation dataset.
- Note that I used the smaller dataset provided by MovieLens for this analysis, but MovieLens also offers larger datasets for more in-depth analysis and more precise recommendations.

### Future Enhancements

In future updates, I plan to incorporate additional features to enhance the recommendation system, including:

- **Genre-Specific Recommendations**: Introduce functionality to recommend movies of a specific genre to users who have a preference for particular genres.
- **Actor and Director Specific Recommendations**: Implement features to recommend movies featuring specific actors or directors based on user preferences or interests.
- **Recommendations for Rare and Less-Viewed Films**: Develop functionality to provide recommendations focusing on lesser-known or less-viewed films, catering to users interested in discovering hidden gems or niche content.

These enhancements aim to further personalize the recommendation experience and offer users a wider range of options tailored to their individual preferences and interests.

### Feedback and Contributions

If you have any questions, comments, or suggestions, feel free to contact me. I am also open to accepting pull requests or forks of the project on GitHub.

## Credits

This project was created by Gabriele Meucci.
