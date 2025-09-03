
import streamlit as st


st.set_page_config(page_title="Shipment Dashboard", layout="wide")

st.title("📦 Shipment Dashboard M&S")
st.write(' Welcome to the M&S Shipment Dashboard! Here you can upload your dataset and visualize shipment data interactively ... Let´s get started with the magic of data!')

# File uploader that accepts CSV files



st.sidebar.title("📁 Upload & Filter")
uploaded_file = st.sidebar.file_uploader("Upload your dataset (CSV)", type=["csv"])


# Process the uploaded file
if uploaded_file:
    import pandas as pd
    df = pd.read_csv(uploaded_file)

    # format date column for filtering
    df['DATE'] = pd.to_datetime(df['DATE'])

    # default date range to earliest and latest date in the dataset
    default_start, default_end = df['DATE'].min(), df['DATE'].max()
     
    # Initialize session state for date range if not already set...used to persist date range selection across reruns
    if 'data range' not in st.session_state:
        st.session_state['data range'] = (default_start, default_end)

    # Date range picker
    start_date, end_date = st.date_input("Select date range", [df['DATE'].min(), df['DATE'].max()])

    # reset button

    if st.button("Reset date range"):
        st.session_state['data range'] = (default_start, default_end)
        start_date, end_date = st.session_state['data range']
        

    filtered_df = df[(df['DATE'] >= pd.to_datetime(start_date)) & (df['DATE'] <= pd.to_datetime(end_date))]

    st.write("Preview of your data:")
    st.dataframe(df)

    # Example visualization
    st.subheader("Shipment Planned vs Actual Start Time")
    import matplotlib.pyplot as plt
    import seaborn as sns

    fig1,ax1 = plt.subplots(figsize=(8, 4))
    sns.countplot(data=filtered_df, x='DELTA_TRANSPORT_START_TIME', ax = ax1)
    plt.xlabel('Delta start time (minutes)')
    plt.ylabel('count of shipmentes')
    plt.ylim(0,600)
    plt.title('Shipment Status Distribution')
    st.write('here you can see the difference in time between planned and actual start time of the transport')
    st.pyplot(fig1,ax1)

     
    st.subheader('Shipment Planned vs Actual End Time')

    fig2 = plt.figure(figsize=(8, 4))
    sns.countplot(data=df, x='DELTA_TRANSPORT_END_TIME')
    plt.xlabel('Delta end time (minutes)')
    plt.ylabel('count of shipmentes')
    plt.ylim(0,600)
    plt.title('Shipment End time differences')
    st.pyplot(fig2)


    
    st.subheader('📈 Most relevant KPIs')

    total_shipments_with_time_registered = len(df)
    avg_start_time = df['DELTA_TRANSPORT_START_TIME'].mean()
    avg_end_time = df['DELTA_TRANSPORT_END_TIME'].mean()

    col1, col2, col3 = st.columns(3)
    col1.metric('Total Shipments with start and end time registered', total_shipments_with_time_registered)
    col2.metric('Average extra planned Start Time (min)', f"{avg_start_time:.2f}")
    col3.metric('Average Delay End Time (min)', f"{avg_end_time:.2f}")



    st.caption('Created and Developed by Alex')