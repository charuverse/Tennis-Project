import streamlit as st
import pandas as pd


st.set_page_config(page_title="Tennis Analytics", layout="wide")

st.title("🎾 Tennis Analytics Dashboard")
st.markdown("Explore competitions, venues, and player rankings")


@st.cache_data
def load_data():
    categories = pd.read_csv("category.csv")
    competitions = pd.read_csv("competition.csv")
    complexes = pd.read_csv("complexes.csv")
    venues = pd.read_csv("venues.csv")
    competitors = pd.read_csv("competitors.csv")
    rankings = pd.read_csv("competitor_ranking.csv")
    
    return categories, competitions, complexes, venues, competitors, rankings

categories, competitions, complexes, venues, competitors, rankings = load_data()

option = st.sidebar.selectbox(
    " Select Section",
    ["🏆 Competitions", "🏟️ Venues & Complexes", "👤 Players & Rankings"]
)


if option == "🏆 Competitions":
    st.subheader("🏆 Competitions Data")

    # Merge with categories
    comp_df = competitions.merge(categories, on="category_id", how="left")

    st.dataframe(comp_df)

    # Filter
    category_filter = st.selectbox(
        "Filter by Category",
        comp_df["category_name"].dropna().unique()
    )

    filtered = comp_df[comp_df["category_name"] == category_filter]
    st.write("Filtered Data")
    st.dataframe(filtered)

    # Chart
    st.subheader("Competition Type Distribution")
    st.bar_chart(comp_df["type"].value_counts())


elif option == "🏟️ Venues & Complexes":
    st.subheader("🏟️ Venues & Complexes")

    # Merge venues + complexes
    venue_df = venues.merge(complexes, on="complex_id", how="left")

    st.dataframe(venue_df)

    # Filter by country
    country = st.selectbox(
        "Select Country",
        venue_df["country_name"].dropna().unique()
    )

    filtered = venue_df[venue_df["country_name"] == country]
    st.write("Filtered Venues")
    st.dataframe(filtered)

    # Chart
    st.subheader("Venues by Country")
    st.bar_chart(venue_df["country_name"].value_counts())


else:
    st.subheader("👤 Players & Rankings")

    # Merge competitors + rankings
    player_df = rankings.merge(competitors, on="competitor_id", how="left")

    st.dataframe(player_df)

    # Top 10 players
    st.subheader("🏅 Top 10 Players by Rank")
    top10 = player_df.sort_values("rank").head(10)
    st.dataframe(top10[["name", "rank", "points"]])

    # Chart
    st.subheader("Points Distribution")
    st.bar_chart(player_df["points"])