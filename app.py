import streamlit as st

is_dark = st.context.theme.type == "dark"

LOGO_FULL = (
    "assets/images/logo_full_dark.png"
    if is_dark
    else "assets/images/logo_full_light.png"
)

LOGO_ICON = (
    "assets/images/logo_icon_dark.png"
    if is_dark
    else "assets/images/logo_icon_light.png"
)

st.logo(LOGO_FULL, icon_image=LOGO_ICON)

st.set_page_config(
    page_title="DroVision",
    page_icon="🛩️",
    layout="wide",
)

# App's version number
__version__ = "0.1.0"
st.sidebar.caption(f"Version {__version__}")


home = st.Page(
    "src/pages/home.py",
    title="Home",
    icon="🏠",
)

row_reports = st.Page(
    "src/pages/Row_report.py",
    title="Right-of-Way Reports",
    icon="⚡️",
)


# solar_reports = st.Page(
#     "src/pages/Solar_report.py",
#     title="Solar Reports",
#     icon="☀️",
# )

pg = st.navigation([
    home,
    row_reports
])

pg.run()