# 🎬 Film Recommendation System

### 🔍 Overview

**Film Recommendation System** is an intelligent movie recommendation engine built using **collaborative filtering**. By analyzing user ratings, it suggests personalized movie recommendations using **item-based** and **user-based** filtering approaches. Whether you're looking for your next favorite film or just exploring trending movies, this system helps you find what fits your taste! 🍿

---

## ⚙️ Features

✅ **Item-Based Collaborative Filtering (IBCF)** – Finds movies similar to a reference film based on rating patterns.  
✅ **User-Based Collaborative Filtering (UBCF)** – Identifies users with similar preferences to generate recommendations.  
✅ **Data Visualization** – Graphs and statistics to analyze movie ratings and trends.  
✅ **Personalized Suggestions** – Adjusts recommendations based on user inputs.  
✅ **Future Enhancements Planned** – Expanding to include actor, director, and genre-specific suggestions.  

---

## 🛠️ Installation & Setup

### 📌 Prerequisites
Ensure you have **R** installed on your system.

### 📥 Install Required Libraries
```r
install.packages(c("recommenderlab", "data.table", "reshape2", "ggplot2", "tibble"))
```

### 📂 Data Requirements
Ensure the dataset files (`movies.csv` and `ratings.csv`) are available in the `data/` directory.

### ▶️ Running the Program
Run the provided R script to generate recommendations and visualize data insights.

---

## 📊 Data Analysis & Visualization

The system performs detailed analyses of user ratings and movie trends, including:

🎞️ **Movie Popularity** – Determines the most-watched films.  
⭐ **Rating Distributions** – Analyzes how users rate different movies.  
📈 **Average Ratings per Movie** – Tracks trends and user preferences.  
📊 **Graphical Visualizations** – Histograms and density plots provide insights into movie rating behaviors.

---

## 🔮 How the Recommendation System Works

### 🎥 **Item-Based Collaborative Filtering (IBCF)**
- Selects a **reference movie**.
- Computes **similarity** scores between movies.
- Suggests movies with **similar rating patterns**.
- Asks the user for input to refine recommendations.

### 🧑‍🤝‍🧑 **User-Based Collaborative Filtering (UBCF)**
- Integrates **user ratings** into the dataset.
- Normalizes scores to account for rating bias.
- Identifies **users with similar preferences**.
- Uses genre-based weightings to refine suggestions.

### 🎯 **Generating Recommendations**
The system selects the **top 8 movies** based on weighted ratings from similar users and genre preferences.

---

## 🚀 Future Enhancements

🔹 **Genre-Specific Recommendations** – Tailored suggestions based on genre preferences.  
🔹 **Actor & Director-Based Suggestions** – Recommends movies featuring specific actors or directors.  
🔹 **Discover Hidden Gems** – Focus on lesser-known films to provide fresh and unique recommendations.  

---

## 🤝 Contributing & Feedback

Have ideas or suggestions? Feel free to reach out or contribute via GitHub! Pull requests and forks are welcome. 😊

---

## 📄 Credits

Developed by **Gabriele Meucci** – Passionate about data science and film analytics! 🎬📊

---

🎥 *Let the perfect movie find you!* 🍿
