import streamlit as st

# import os
# from dotenv import load_dotenv
# load_dotenv()
# DATABASE_ACCESS=os.getenv("DATABASE_ACCESS")

st.set_page_config(
    page_title="Formular",
    # layout="wide"
    )

st.header("Speicherumfrage 2026")
st.write("Liebes Mitglied, wir ersuchen dich um Rückmeldung über \"Aktuelle Speichersituation\" in unserer Energiegemeinschaft")

with st.form("form"):

    with st.expander("Stammdaten", expanded=True):
        eg = st.text_input("Energiegemeinschaft")

        mitgliedsnummer = st.text_input("Mitgliedsnummer") # only digit (text_input to not lose first 0)

        st.divider()


        col1, col2 = st.columns(2)

        with col1:
            st.text_input("Vorname / Firmenname")

        with col2:
            st.text_input("Nachname")

        email = st.text_input("Email")
        handynummer = st.text_input("Handynummer") # only digit

        st.divider()

        strasse = st.text_input("Strasse")
        hausnummer = st.text_input("Hausnummer")

        col1, col2 = st.columns([3,1])

        with col1:
            st.text_input("Postleitzahl") # only digit

        with col2:
            st.text_input("Ort")

    with st.expander("Einspeiseanlage", expanded=True):
        st.text_input("Einspeisezählpunkt")
    
        speicheroptionen = [
            "Ich habe bereits einen Speicher",
            "Ich plane die Anschaffung eines Speichers",
            "Ich habe noch eine Überlegung hinsichtlich Speicher"
        ]

        speicher = st.selectbox(
            "Speicher",
            speicheroptionen,
            index=None,
            placeholder="Bitte auswählen"
        )

        wr_hersteller_optionen = [
            "Fronius",
            "Huawai",
            "SMA",
            "Solar Edge",
            "Victron",
            "Other"
        ]

        wr_hersteller = st.selectbox(
            "Wechselrichterhersteller :red[*]",
            wr_hersteller_optionen,
            index=None,
            placeholder="Bitte auswählen"
        )

        kw_peak = st.number_input(
            "Wie groß ist deine PV Anlage [kW-PEAK]",
            min_value=0,
            step=100
        )

        speicherkapazität = st.number_input(
            "Wie groß ist die nutzbare Speicherkapazität [kWh] :red[*]",
            min_value=0,
            step=100
        )

        eeg_anteil = st.slider(
            "Anteil für EEG [%] :red[*]",
            min_value=0,
            max_value=100,
            step=25
        )

        kostenbeteiligung = st.slider(
            "Bereitschaft zur Kostenbeteiligung [€]",
            min_value=0,
            max_value=225,
            step=75
        )

        priorität = st.text_area("Priorität :red[*]")

        pilotgruppe = st.selectbox(
            "Dürfen wir dich in eien Pilotgruppe aufnehmen?",
            ["Ja gerne", "Nein bitte nicht"],
            index=None,
            placeholder="Bitte auswählen"
        )
    
    with st.expander("Zusatzinformationen", expanded=True):
        zusatzinfo = st.text_area(
            "Zusatzinformationen",
            placeholder="Gibt es sonst noch etwas das du uns mitteilen möchtest?"
        )

        files = st.file_uploader(
            "zusätzliche Unterlagen",
            type=["pdf", "jpg", "png"],
            accept_multiple_files=True
        )

    # _, col, _ = st.columns([1,1,1])

    # with col:
    #     st.form_submit_button("Absenden", use_container_width=True)
    
    st.form_submit_button("Absenden", use_container_width=True)

    # hoover, center btn, hide form?, subheader?, press enter to submit form?