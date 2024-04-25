# Loading necessary libraries
library(recommenderlab)  # Importing the recommenderlab library
library(data.table)      # Importing the data.table library
library(reshape2)        # Importing the reshape2 library
library(ggplot2)         # Importing the ggplot2 library
library(tibble)          # Importing the tibble library

# Setting the working directory
setwd("__INSERT HERE YOUR WORKING DIRECTORY__")  # Setting the working directory

# Reading data from CSV files
movies <- fread("data/movies.csv")    # Reading data from the movies.csv file
ratings <- fread("data/ratings.csv")  # Reading data from the ratings.csv file

# Data preparation
# Creating the rating matrix
rating_matrix <- acast(ratings, userId ~ movieId, value.var = "rating", fill = 0)  # Creating the rating matrix

# Handling missing movieIds
all_movie_ids <- unique(movies$movieId)              # Getting all unique movieIds
existing_movie_ids <- colnames(rating_matrix)        # Getting movieIds present in the rating matrix
missing_movie_ids <- setdiff(all_movie_ids, existing_movie_ids)  # Computing missing movieIds
rating_matrix <- cbind(rating_matrix, matrix(0, nrow = nrow(rating_matrix), ncol = length(missing_movie_ids), dimnames = list(rownames(rating_matrix), as.character(missing_movie_ids))))  # Adding columns for missing movieIds to the rating matrix
rating_matrix <- rating_matrix[, order(as.integer(colnames(rating_matrix)))]  # Ordering the rating matrix by movieIds

# Creating the genre matrix
genres_list <- strsplit(movies$genres, "\\|")          # Splitting genres for each movie
unique_genres <- unique(unlist(genres_list))          # Getting unique genres
genre_matrix <- matrix(0, nrow = nrow(movies), ncol = length(unique_genres), dimnames = list(NULL, unique_genres))  # Creating a zero matrix for genres
for (i in 1:nrow(movies)) {                           # Iterating over movies
  genres <- genres_list[[i]]                          # Getting genres for the current movie
  genre_matrix[i, genres] <- 1                        # Setting genre values to 1
}
rownames(genre_matrix) <- movies$movieId              # Setting row names for the genre matrix
movies_with_genres <- cbind(movies[, c("movieId", "title")], genre_matrix)  # Combining movies data with genre matrix
genre_matrix_transposed <- t(genre_matrix)            # Transposing the genre matrix

# Computing similarity
# User similarity
rating_matrix_RRM <- as(rating_matrix, "realRatingMatrix")  # Converting rating matrix to realRatingMatrix
user_similarity <- similarity(rating_matrix_RRM, method = "cosine", which = "users")  # Computing user similarity
user_similarity_matrix <- as.matrix(user_similarity)  # Converting user similarity to matrix

# Item similarity
item_similarity <- similarity(rating_matrix_RRM, method = "cosine", which = "items")  # Computing item similarity
item_similarity_matrix <- as.matrix(item_similarity)  # Converting item similarity to matrix

# Genre-based item similarity
genre_matrix_RRM <- as(genre_matrix_transposed, "realRatingMatrix")  # Converting transposed genre matrix to realRatingMatrix
film_genre_similarity <- similarity(genre_matrix_RRM, method = "cosine", which = "items")  # Computing item similarity based on genres
film_genre_similarity_matrix <- as.matrix(film_genre_similarity)  # Converting genre-based item similarity to matrix

# Function definitions
# Function for item-based collaborative filtering model
ibcf_model <- function(chosen_movie, item_similarity_matrix, movie_list = movies) {
  chosen_movie_index <- which(movie_list$movieId == chosen_movie)
  
  if (length(chosen_movie_index) == 0) {
    cat("MovieId not found in the list of movies.\n")
    return(NULL)
  }
  
  user_ratings <- rep(0, nrow(movie_list))
  similar_movie_ids <- item_similarity_matrix[chosen_movie_index, ]
  top_similar_indices <- order(similar_movie_ids, decreasing = TRUE)
  similar_movie_ids <- names(item_similarity_matrix[chosen_movie_index, top_similar_indices])
  
  num_votes <- 0
  valid_votes <- 0
  while (valid_votes < 5) {
    similar_movie_id <- similar_movie_ids[num_votes + 1]
    movie_index <- which(movie_list$movieId == as.numeric(similar_movie_id))
    movie_name <- movie_list$title[movie_index]
    
    vote_input <- readline(paste("Did you like the movie '", movie_name, "'? [1][2][3][4][5][n]: "))
    if (tolower(vote_input) == "n") {
      # Do not increment num_votes in case of 'n'
    } else if (tolower(vote_input) %in% c("1", "2", "3", "4", "5")) {
      rating <- as.numeric(vote_input)
      user_ratings[movie_index] <- rating
      valid_votes <- valid_votes + 1
    } else {
      cat("Invalid input. Please try again.\n")
    }
    num_votes <- num_votes + 1  # Increment num_votes only for valid votes
  }
  
  user_ratings[chosen_movie_index] <- 5
  return(user_ratings)
}

# Function for user-based collaborative filtering model
ubcf_model <- function(chosen_movie_id, user_ratings, rating_matrix, film_genre_similarity_matrix, movie_list = movies, genre_similarity_threshold = 0.7, user_similarity_threshold = 0.5) {
  rating_matrix <- rbind(rating_matrix, user_ratings)
  normalized_rating_matrix <- rating_matrix - rowMeans(rating_matrix, na.rm = TRUE)
  rating_matrix_RRM <- as(normalized_rating_matrix, "realRatingMatrix")
  user_similarity <- similarity(rating_matrix_RRM, method = "cosine", which = "users")
  user_similarity_matrix <- as.matrix(user_similarity)
  
  user_similarity_row <- tail(user_similarity_matrix, n = 1)
  user_similarity_row <- as.vector(user_similarity_row)
  
  relevant_users <- user_similarity_row > user_similarity_threshold
  relevant_ratings <- normalized_rating_matrix[relevant_users, ]
  
  weighted_mean_ratings <- colMeans(relevant_ratings, na.rm = TRUE)
  
  chosen_movie_index <- which(movie_list$movieId == chosen_movie_id)
  chosen_movie_genre_similarity <- film_genre_similarity_matrix[chosen_movie_index, ]
  relevant_genre_similarity <- chosen_movie_genre_similarity > genre_similarity_threshold
  
  combined_similarity <- weighted_mean_ratings * relevant_genre_similarity
  
  recommended_movies <- movie_list[order(combined_similarity, decreasing = TRUE), ]
  
  return(recommended_movies[1:8, ])
}

# Function definitions for creating plots
# Function to create the plot of user similarity of specific size
create_user_similarity_plot <- function(size, user_similarity_matrix) {
  # Extract the size x size submatrix
  user_similarity_sub <- user_similarity_matrix[1:size, 1:size]
  
  # Convert the submatrix to a dataframe
  user_similarity_sub_df <- as.data.frame(user_similarity_sub)
  user_similarity_sub_df$User <- rownames(user_similarity_sub_df)
  user_similarity_sub_df <- tidyr::pivot_longer(user_similarity_sub_df, -User, names_to = "User2", values_to = "Similarity")
  
  # Create the user similarity matrix plot with more color gradients
  user_similarity_plot <- ggplot(data = user_similarity_sub_df, aes(x = User, y = User2, fill = Similarity)) +
    geom_tile() +
    geom_tile(color = "white") +
    scale_fill_gradientn(colors = c("#eff3ff", "#bdd7e7", "#6baed6", "#3182bd", "#08519c"), guide = "colorbar") + # Adjust colors as needed
    labs(title = paste("Similarity between first", size, "users"), x = NULL, y = NULL) +
    theme_gray() +
    theme(axis.text.x = element_blank(), axis.text.y = element_blank(), axis.ticks = element_blank())
  
  return(user_similarity_plot)
}

create_item_similarity_plot <- function(size, item_similarity_matrix) {
  # Extract the size x size submatrix
  item_similarity_sub <- item_similarity_matrix[1:size, 1:size]
  
  # Convert the submatrix to a dataframe
  item_similarity_sub_df <- as.data.frame(item_similarity_sub)
  item_similarity_sub_df$Film <- rownames(item_similarity_sub_df)
  item_similarity_sub_df <- tidyr::pivot_longer(item_similarity_sub_df, -Film, names_to = "Film2", values_to = "Similarity")
  
  # Create the item similarity matrix plot with more color gradients
  item_similarity_plot <- ggplot(data = item_similarity_sub_df, aes(x = Film, y = Film2, fill = Similarity)) +
    geom_tile() +
    geom_tile(color = "white") +
    scale_fill_gradientn(colors = c("#f1eef6", "#d7b5d8", "#df65b0", "#dd1c77", "#980043"), guide = "colorbar") + # Adjust colors as needed
    labs(title = paste("Similarity between first", size, "movies"), x = NULL, y = NULL) +
    theme_gray() +
    theme(axis.text.x = element_blank(), axis.text.y = element_blank(), axis.ticks = element_blank())
  
  return(item_similarity_plot)
}

create_genre_similarity_plot <- function(size, genre_similarity_matrix) {
  # Extract the size x size submatrix
  genre_similarity_sub <- genre_similarity_matrix[1:size, 1:size]
  
  # Convert the submatrix to a dataframe
  genre_similarity_sub_df <- as.data.frame(genre_similarity_sub)
  genre_similarity_sub_df$Film <- rownames(genre_similarity_sub_df)
  genre_similarity_sub_df <- tidyr::pivot_longer(genre_similarity_sub_df, -Film, names_to = "Film2", values_to = "Similarity")
  
  # Create the genre similarity matrix plot with more color gradients
  genre_similarity_plot <- ggplot(data = genre_similarity_sub_df, aes(x = Film, y = Film2, fill = Similarity)) +
    geom_tile() +
    geom_tile(color = "white") +
    scale_fill_gradientn(colors = c("#edf8e9", "#bae4b3", "#74c476", "#31a354", "#006d2c"), guide = "colorbar") + # Adjust colors as needed
    labs(title = paste("Similarity between first", size, "movies by genres"), x = NULL, y = NULL) +
    theme_gray() +
    theme(axis.text.x = element_blank(), axis.text.y = element_blank(), axis.ticks = element_blank())
  
  return(genre_similarity_plot)
}

# Data visualization
# Rating distribution
vector_ratings <- as.vector(rating_matrix)           # Converting rating matrix to vector
unique_ratings <- unique(vector_ratings)             # Getting unique ratings
table_ratings <- table(vector_ratings)               # Computing rating frequency

# Number of views per movie
views_per_movie <- colSums(rating_matrix != 0)       # Computing number of views per movie
threshold <- 10                                      # Setting threshold
movies_with_views <- movies_with_genres              # Copying movies with genres data
movies_with_views$views <- views_per_movie[match(movies_with_views$movieId, colnames(rating_matrix))]  # Adding views column to movies data
relevant_movies <- movies_with_views[movies_with_views$views >= threshold, ]  # Filtering relevant movies

# Most viewed movies
movies_with_views <- movies_with_views[order(movies_with_views$views, decreasing = TRUE), ]  # Sorting movies by views
x <- 10                                              # Number of top movies to display
top_movies <- movies_with_views[1:x, ]               # Selecting top movies

# Average rating distribution per movie
average_ratings <- colSums(rating_matrix * (rating_matrix != 0)) / colSums(rating_matrix != 0)  # Computing average ratings per movie
movies_with_views$avg_rating <- average_ratings[match(movies_with_views$movieId, colnames(rating_matrix))]  # Adding average rating column to movies data
avg_rating_mean <- mean(movies_with_views$avg_rating, na.rm = TRUE)
avg_rating_median <- median(movies_with_views$avg_rating, na.rm = TRUE)
avg_rating_5_percentile <- quantile(movies_with_views$avg_rating, probs = 0.05, na.rm = TRUE)
avg_rating_95_percentile <- quantile(movies_with_views$avg_rating, probs = 0.95, na.rm = TRUE)

# Average rating distribution per movie for relevant movies
relevant_average_ratings <- colSums(rating_matrix * (rating_matrix != 0)) / colSums(rating_matrix != 0)  # Computing average ratings per movie for all movies
relevant_movies$avg_rating <- relevant_average_ratings[match(relevant_movies$movieId, colnames(rating_matrix))]  # Adding average rating column to relevant movies data
relevant_avg_rating_mean <- mean(relevant_movies$avg_rating, na.rm = TRUE)
relevant_avg_rating_median <- median(relevant_movies$avg_rating, na.rm = TRUE)
relevant_avg_rating_5_percentile <- quantile(relevant_movies$avg_rating, probs = 0.05, na.rm = TRUE)
relevant_avg_rating_95_percentile <- quantile(relevant_movies$avg_rating, probs = 0.95, na.rm = TRUE)

# Average rating distribution per user
avg_rating_per_user <- rowSums(rating_matrix* (rating_matrix != 0)) / rowSums(rating_matrix != 0)  # Computing average rating per user
avg_rating_per_user <- avg_rating_per_user[is.finite(avg_rating_per_user)]  # Filtering out non-finite values
user_avg_rating_mean <- mean(avg_rating_per_user, na.rm = TRUE)
user_avg_rating_median <- median(avg_rating_per_user, na.rm = TRUE)
user_avg_rating_5_percentile <- quantile(avg_rating_per_user, probs = 0.05, na.rm = TRUE)
user_avg_rating_95_percentile <- quantile(avg_rating_per_user, probs = 0.95, na.rm = TRUE)

# Average rating distribution per relevant user
relevant_users <- rowSums(rating_matrix > 0) >= 200  # Filtering relevant users
avg_rating_per_relevant_user <- rowSums(rating_matrix[relevant_users, ]) / rowSums(rating_matrix[relevant_users, ] > 0)  # Computing average rating per relevant user
avg_rating_per_relevant_user <- avg_rating_per_relevant_user[is.finite(avg_rating_per_relevant_user)]  # Filtering out non-finite values
relevant_user_avg_rating_mean <- mean(avg_rating_per_relevant_user, na.rm = TRUE)
relevant_user_avg_rating_median <- median(avg_rating_per_relevant_user, na.rm = TRUE)
relevant_user_avg_rating_5_percentile <- quantile(avg_rating_per_relevant_user, probs = 0.05, na.rm = TRUE)
relevant_user_avg_rating_95_percentile <- quantile(avg_rating_per_relevant_user, probs = 0.95, na.rm = TRUE)

# Creating plots
rating_histogram_no_zeros <- ggplot(data = data.frame(Rating = as.numeric(names(table_ratings[-1])), Frequency = as.numeric(table_ratings[-1])), aes(x = Rating, y = Frequency)) +
  geom_bar(stat = "identity", fill = "white", color = "#48443D") +
  labs(title = "Rating distribution", x = "Rating", y = "Number of ratings") +
  theme_gray()+
  theme(axis.line = element_line(color = "#48443D"))

top_movies_histogram <- ggplot(data = top_movies, aes(x = reorder(title, -views), y = views)) +
  geom_bar(stat = "identity", fill = "white", color = "#48443D") +
  labs(title = paste("The", x, "movies with the highest number of votes"), x = "Movie", y = "Number of votes") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

avg_rating_histogram <- ggplot(data = movies_with_views, aes(x = avg_rating)) +
  geom_histogram(binwidth = 0.1, fill = "white", color = "#48443D") +
  labs(title = "Distribution of average rating per movie", x = "Average Rating", y = "Number of Movies") +
  theme_gray() +
  theme(axis.line = element_line(color = "#48443D")) +
  annotate("text", x = 0.5, y = max(hist(movies_with_views$avg_rating, breaks = seq(0, 5, by = 0.05))$counts), label = paste("Mean:", round(avg_rating_mean, 2)), color = "#48443D", size = 3, hjust = 0) +
  annotate("text", x = 0.5, y = max(hist(movies_with_views$avg_rating, breaks = seq(0, 5, by = 0.05))$counts) * 0.95, label = paste("Median:", round(avg_rating_median, 2)), color = "#48443D", size = 3, hjust = 0) +
  annotate("text", x = 0.5, y = max(hist(movies_with_views$avg_rating, breaks = seq(0, 5, by = 0.05))$counts) * 0.9, label = paste("5th percentile:", round(avg_rating_5_percentile, 2)), color = "#48443D", size = 3, hjust = 0) +
  annotate("text", x = 0.5, y = max(hist(movies_with_views$avg_rating, breaks = seq(0, 5, by = 0.05))$counts) * 0.85, label = paste("95th percentile:", round(avg_rating_95_percentile, 2)), color = "#48443D", size = 3, hjust = 0)

relevant_avg_rating_histogram <- ggplot(data = relevant_movies, aes(x = avg_rating)) +
  geom_histogram(binwidth = 0.1, fill = "white", color = "#48443D") +
  labs(title = "Distribution of average rating per relevant movie", subtitle = "Movies with more than 10 votes", x = "Average Rating", y = "Number of Movies") +
  theme_gray() +
  theme(axis.line = element_line(color = "#48443D")) +
  annotate("text", x = 0.5, y = max(hist(relevant_movies$avg_rating, breaks = seq(0, 5, by = 0.1))$counts), label = paste("Mean:", round(relevant_avg_rating_mean, 2)), color = "#48443D", size = 3, hjust = 0) +
  annotate("text", x = 0.5, y = max(hist(relevant_movies$avg_rating, breaks = seq(0, 5, by = 0.1))$counts) * 0.95, label = paste("Median:", round(relevant_avg_rating_median, 2)), color = "#48443D", size = 3, hjust = 0) +
  annotate("text", x = 0.5, y = max(hist(relevant_movies$avg_rating, breaks = seq(0, 5, by = 0.1))$counts) * 0.9, label = paste("5th percentile:", round(relevant_avg_rating_5_percentile, 2)), color = "#48443D", size = 3, hjust = 0) +
  annotate("text", x = 0.5, y = max(hist(relevant_movies$avg_rating, breaks = seq(0, 5, by = 0.1))$counts) * 0.85, label = paste("95th percentile:", round(relevant_avg_rating_95_percentile, 2)), color = "#48443D", size = 3, hjust = 0)

user_avg_rating_histogram <- ggplot(data = NULL, aes(x = avg_rating_per_user)) +
  geom_histogram(binwidth = 0.1, fill = "white", color = "#48443D") +
  labs(title = "Distribution of average rating per user", x = "Average Rating", y = "Number of Users") +
  theme_gray() +
  theme(axis.line = element_line(color = "#48443D")) +
  annotate("text", x = 0.5, y = max(hist(avg_rating_per_user, breaks = seq(0, 5, by = 0.1))$counts), label = paste("Mean:", round(user_avg_rating_mean, 2)), color = "#48443D", size = 3, hjust = 0) +
  annotate("text", x = 0.5, y = max(hist(avg_rating_per_user, breaks = seq(0, 5, by = 0.1))$counts) * 0.95, label = paste("Median:", round(user_avg_rating_median, 2)), color = "#48443D", size = 3, hjust = 0) +
  annotate("text", x = 0.5, y = max(hist(avg_rating_per_user, breaks = seq(0, 5, by = 0.1))$counts) * 0.9, label = paste("5th percentile:", round(user_avg_rating_5_percentile, 2)), color = "#48443D", size = 3, hjust = 0) +
  annotate("text", x = 0.5, y = max(hist(avg_rating_per_user, breaks = seq(0, 5, by = 0.1))$counts) * 0.85, label = paste("95th percentile:", round(user_avg_rating_95_percentile, 2)), color = "#48443D", size = 3, hjust = 0)

relevant_user_avg_rating_histogram <- ggplot(data = NULL, aes(x = avg_rating_per_relevant_user)) +
  geom_histogram(binwidth = 0.1, fill = "white", color = "#48443D") +
  labs(title = "Distribution of average rating per user", subtitle = "User with more than 200 votes", x = "Average Rating", y = "Number of Users") +
  theme_gray() +
  theme(axis.line = element_line(color = "#48443D")) +
  annotate("text", x = 0.5, y = max(hist(avg_rating_per_relevant_user, breaks = seq(0, 5, by = 0.1))$counts), label = paste("Mean:", round(relevant_user_avg_rating_mean, 2)), color = "#48443D", size = 3, hjust = 0) +
  annotate("text", x = 0.5, y = max(hist(avg_rating_per_relevant_user, breaks = seq(0, 5, by = 0.1))$counts) * 0.95, label = paste("Median:", round(relevant_user_avg_rating_median, 2)), color = "#48443D", size = 3, hjust = 0) +
  annotate("text", x = 0.5, y = max(hist(avg_rating_per_relevant_user, breaks = seq(0, 5, by = 0.1))$counts) * 0.9, label = paste("5th percentile:", round(relevant_user_avg_rating_5_percentile, 2)), color = "#48443D", size = 3, hjust = 0) +
  annotate("text", x = 0.5, y = max(hist(avg_rating_per_relevant_user, breaks = seq(0, 5, by = 0.1))$counts) * 0.85, label = paste("95th percentile:", round(relevant_user_avg_rating_95_percentile, 2)), color = "#48443D", size = 3, hjust = 0)

avg_rating_density <- ggplot(data = movies_with_views, aes(x = avg_rating)) +
  geom_density(aes(color = "All Movies"), linewidth = 0.5) +
  geom_density(data = relevant_movies, aes(x = avg_rating, color = "Relevant Movies"), linewidth = 1) +
  scale_color_manual(values = c("All Movies" = "#48443D", "Relevant Movies" = "yellowgreen")) +
  labs(title = "Density of average ratings vs. Relevant average ratings", x = "Average Rating", y = "Density",
       color = "Category") +
  theme_gray() +
  theme(axis.line = element_line(color = "#48443D"),
        axis.text.y = element_blank(),  # Remove y-axis labels
        axis.ticks.y = element_blank(),
        legend.position = "right")  # Legend position

user_avg_rating_density <- ggplot() +
  geom_density(data = data.frame(avg_rating_per_user), aes(x = avg_rating_per_user, color = "All Users"), linewidth = 0.5) +
  geom_density(data = data.frame(avg_rating_per_relevant_user), aes(x = avg_rating_per_relevant_user, color = "Relevant Users"), linewidth = 1) +
  scale_color_manual(values = c("All Users" = "#48443D", "Relevant Users" = "yellowgreen")) +
  labs(title = "Density of user average ratings vs. Relevant user average ratings", x = "Average Rating", y = "Density",
       color = "Category") +
  theme_gray() +
  theme(axis.line = element_line(color = "#48443D"),
        axis.text.y = element_blank(),  # Remove y-axis labels
        axis.ticks.y = element_blank(),
        legend.position = "right")  # Legend position