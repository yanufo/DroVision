import streamlit as st
import pandas as pd
import streamlit.components.v1 as components

from sql_tool.queries import get_all_reports
from ui.drone_model import display_3d_drone
from ui.upload import show_new_report
from ui.usagi_model import display_3d_usagi
from ui.drone_model import display_3d_drone
import base64

# ============================================================
# Hide Streamlit Deploy button
# ============================================================
# region Hide Deploy Button
st.markdown("""
<style>
[data-testid="stAppDeployButton"] {
    display: none;
}
</style>
""", unsafe_allow_html=True)

# endregion

# ============================================================
# New Report
# ============================================================
# region New Report
st.title("Inspection Report Generation")

show_new_report()

# endregion

# ============================================================
# 3D Drone Viewer
# ============================================================

display_3d_drone()


# ============================================================
# 3D King Usagi Viewer
# ============================================================

# display_3d_usagi()

