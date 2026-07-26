#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Fig. 1a — Contamination frequency across archaeal groups

Reproduces the published panel showing genome-level contamination frequencies
(%) for bacterial, eukaryotic, viral and unclassified contaminants in isolate
genomes versus MAG-derived genomes across Asgard, TACK, Euryarchaeota and DPANN.

Data source (deposited with the manuscript):
    data/decontamination/assessment/contamination_by_lineage.xlsx
Summary percentages below match the deposited assessment tables and are
embedded here for figure layout only.

Dependencies:
    pip install matplotlib numpy

Outputs (written to the current working directory):
    contamination_frequency_archaea.png
    contamination_frequency_archaea.svg
    contamination_frequency_archaea.pdf

Usage (from repository root, or adjust paths as needed):
    python scripts/figure_reproduction/fig1a_contamination_frequency.py
"""

import numpy as np
import matplotlib as mpl
import matplotlib.pyplot as plt
from matplotlib.patches import FancyBboxPatch, Circle, Rectangle, Polygon
from matplotlib.colors import LinearSegmentedColormap

mpl.rcParams["font.family"] = "DejaVu Sans"
mpl.rcParams["svg.fonttype"] = "none"
mpl.rcParams["pdf.fonttype"] = 42

# ---------------------------------------------------------------------------
# Summary statistics (from data/decontamination/assessment/contamination_by_lineage.xlsx)
# Values are percentages of genomes with ≥1 contaminant contig in each
# category. Sample sizes (N) are genome counts used as denominators.
# ---------------------------------------------------------------------------
groups = ["Asgard", "TACK", "Euryarchaeota", "DPANN"]

# Number of isolate genomes and MAG-derived genomes per group
isolate_n = [4, 155, 466, 4]
mag_n = [469, 469, 469, 469]  # update if assessment tables differ by group

categories = [
    "Bacterial\ncontamination",
    "Eukaryotic\ncontamination",
    "Viral\ncontamination",
    "Unclassified\ncontamination",
]

# Rows = groups (Asgard, TACK, Euryarchaeota, DPANN)
# Columns = bacterial, eukaryotic, viral, unclassified (%)
isolate_values = np.array([
    [0.00, 0.00, 0.00, 0.00],   # Asgard isolates
    [0.00, 0.00, 0.00, 0.00],   # TACK isolates
    [0.21, 0.00, 1.29, 0.43],   # Euryarchaeota isolates
    [0.00, 0.00, 0.00, 0.00],   # DPANN isolates
])

mag_values = np.array([
    [63.33, 2.99, 25.59, 17.27],  # Asgard MAGs
    [30.49, 1.07, 12.37, 5.33],   # TACK MAGs
    [45.63, 0.43, 14.29, 14.93],  # Euryarchaeota MAGs
    [43.71, 0.64, 12.79, 9.81],   # DPANN MAGs
])

# Total N shown in side labels (must match assessment tables)
N_ISOLATE_TOTAL = 629
N_MAG_TOTAL = 1876

# ---------------------------------------------------------------------------
# Colours and colormaps
# ---------------------------------------------------------------------------
blue = "#1455B3"
red = "#E91E24"
purple = "#6D2DA8"
gray = "#5E5E5E"
header_colors = [blue, red, purple, gray]

cmaps = [
    LinearSegmentedColormap.from_list("bluegrad", ["#FFFFFF", "#D9E9F7", blue]),
    LinearSegmentedColormap.from_list("redgrad", ["#FFFFFF", "#F8D6D6", red]),
    LinearSegmentedColormap.from_list("purplegrad", ["#FFFFFF", "#E4D8F1", purple]),
    LinearSegmentedColormap.from_list("graygrad", ["#FFFFFF", "#D9D9D9", gray]),
]

mag_max = mag_values.max(axis=0)

# ---------------------------------------------------------------------------
# Figure layout
# ---------------------------------------------------------------------------
fig = plt.figure(figsize=(8.8, 10.8), dpi=300)
ax = fig.add_axes([0, 0, 1, 1])
ax.set_xlim(0, 1)
ax.set_ylim(0, 1)
ax.axis("off")

ax.text(0.03, 0.965, "a", fontsize=20, fontweight="bold", va="center")
ax.text(
    0.11, 0.965,
    "Contamination frequency across archaeal groups",
    fontsize=20, fontweight="bold", va="center",
)

col_x = [0.43, 0.58, 0.73, 0.88]
for x, label, color in zip(col_x, categories, header_colors):
    ax.text(
        x, 0.905, label, ha="center", va="center",
        fontsize=12, fontweight="bold", color=color,
    )

# --- Column icons (schematic only) ---
# Bacterial
x, y = col_x[0], 0.82
for dx, dy, angle in [(-0.018, 0.010, 25), (0.022, -0.020, 25)]:
    box = FancyBboxPatch(
        (x + dx - 0.020, y + dy - 0.038), 0.040, 0.076,
        boxstyle="round,pad=0.005,rounding_size=0.02",
        facecolor="#BDD5F3", edgecolor=blue, linewidth=1.2,
    )
    t = mpl.transforms.Affine2D().rotate_deg_around(x + dx, y + dy, angle) + ax.transData
    box.set_transform(t)
    ax.add_patch(box)

# Eukaryotic
x, y = col_x[1], 0.82
ax.add_patch(Circle((x, y), 0.054, facecolor="#FAD1D1", edgecolor=red, linewidth=1.2))
ax.add_patch(Circle((x, y), 0.022, facecolor="#F38A8D", edgecolor=red, linewidth=1.0))

# Viral
x, y = col_x[2], 0.82
ax.add_patch(Circle((x, y), 0.048, facecolor="#D9C2EE", edgecolor=purple, linewidth=1.2))
for ang in np.linspace(0, 2 * np.pi, 8, endpoint=False):
    x1, y1 = x + 0.050 * np.cos(ang), y + 0.050 * np.sin(ang)
    x2, y2 = x + 0.062 * np.cos(ang), y + 0.062 * np.sin(ang)
    ax.plot([x1, x2], [y1, y2], color=purple, lw=1.1)
    ax.add_patch(Circle((x2, y2), 0.0045, facecolor="#D9C2EE", edgecolor=purple, linewidth=1.0))
theta = np.linspace(0, 2 * np.pi, 7)[:-1] + np.pi / 6
pts = np.c_[x + 0.026 * np.cos(theta), y + 0.026 * np.sin(theta)]
ax.add_patch(Polygon(pts, closed=True, fill=False, edgecolor=purple, linewidth=1.0))

# Unclassified
x, y = col_x[3], 0.82
ax.add_patch(Circle((x, y), 0.054, facecolor="#F1F1F1", edgecolor=gray, linewidth=1.2))
ax.text(x, y - 0.003, "?", ha="center", va="center", fontsize=42, fontweight="bold", color=gray)

ax.text(0.57, 0.72, "Contamination frequency (%)", fontsize=18, fontweight="bold", ha="center")

group_label_x0 = 0.19
table_x0 = 0.37
table_x1 = 0.96
row_h = 0.064
col_edges = np.linspace(table_x0, table_x1, 5)


def rounded_outer_box(x0, y0, w, h, edgecolor="black", facecolor="white", lw=1.6):
    patch = FancyBboxPatch(
        (x0, y0), w, h,
        boxstyle="round,pad=0.002,rounding_size=0.028",
        facecolor=facecolor, edgecolor=edgecolor, linewidth=lw,
    )
    ax.add_patch(patch)
    return patch


# Side labels: isolate vs MAG blocks
iso_y0 = 0.435
iso_h = row_h * 4
rounded_outer_box(0.035, iso_y0, 0.145, iso_h, edgecolor="black", facecolor="#EFF5FC", lw=1.5)
ax.text(
    0.108, iso_y0 + iso_h * 0.62, "Isolate\ngenomes",
    ha="center", va="center", fontsize=13, fontweight="bold", color=blue,
)
ax.text(
    0.108, iso_y0 + 0.035, f"(N={N_ISOLATE_TOTAL})",
    ha="center", va="center", fontsize=12, fontweight="bold", color=blue,
)

mag_y0 = 0.155
mag_h = row_h * 4
rounded_outer_box(0.035, mag_y0, 0.145, mag_h, edgecolor="black", facecolor="#F4ECFA", lw=1.5)
ax.text(
    0.108, mag_y0 + mag_h * 0.73, "MAG-derived\ngenomes",
    ha="center", va="center", fontsize=13, fontweight="bold", color=purple,
)
ax.text(
    0.108, mag_y0 + 0.040, f"(N={N_MAG_TOTAL})",
    ha="center", va="center", fontsize=12, fontweight="bold", color=purple,
)


def draw_section(y0, values, ns, use_heatmap):
    """Draw one block (isolates or MAGs): group labels + frequency grid."""
    section_h = row_h * 4
    rounded_outer_box(
        group_label_x0, y0, table_x1 - group_label_x0, section_h,
        edgecolor="black", facecolor="white", lw=1.6,
    )
    for i in range(1, 4):
        y = y0 + i * row_h
        ax.plot([group_label_x0, table_x1], [y, y], color="#C9C9C9", lw=0.8)
    ax.plot([table_x0, table_x0], [y0, y0 + section_h], color="#C9C9C9", lw=0.8)
    for xe in col_edges[1:-1]:
        ax.plot([xe, xe], [y0, y0 + section_h], color="#C9C9C9", lw=0.8)

    for r, (group, n) in enumerate(zip(groups, ns)):
        yy = y0 + section_h - (r + 0.5) * row_h
        ax.text(
            group_label_x0 + 0.012, yy, f"{group}\n(N = {n})",
            ha="left", va="center", fontsize=11.5, fontweight="bold",
        )
        for c in range(4):
            xleft, xright = col_edges[c], col_edges[c + 1]
            val = values[r, c]
            if use_heatmap:
                norm_val = val / mag_max[c] if mag_max[c] > 0 else 0
                ax.add_patch(
                    Rectangle(
                        (xleft, yy - row_h / 2), xright - xleft, row_h,
                        facecolor=cmaps[c](norm_val), edgecolor="none",
                    )
                )
            if use_heatmap and val >= 0.70 * mag_max[c]:
                text_color = "white"
            elif not use_heatmap and val == 0:
                text_color = header_colors[c]
            else:
                text_color = "black"
            ax.text(
                (xleft + xright) / 2, yy, f"{val:.2f}",
                ha="center", va="center", fontsize=12,
                fontweight="bold", color=text_color,
            )


draw_section(iso_y0, isolate_values, isolate_n, use_heatmap=False)
draw_section(mag_y0, mag_values, mag_n, use_heatmap=True)

ax.text(0.57, 0.112, "Contamination frequency (%)", fontsize=17, fontweight="bold", ha="center")

# Colour bars (scale = max frequency per category among MAGs)
bar_y = 0.079
bar_h = 0.012
for c in range(4):
    x0, x1 = col_edges[c], col_edges[c + 1]
    grad = np.linspace(0, 1, 256).reshape(1, -1)
    ax.imshow(
        grad, extent=[x0 + 0.010, x1 - 0.010, bar_y, bar_y + bar_h],
        origin="lower", aspect="auto", cmap=cmaps[c], interpolation="bicubic",
    )
    ax.text(x0 + 0.003, bar_y - 0.014, "0", ha="left", va="center", fontsize=10.5)
    ax.text(x1 - 0.003, bar_y - 0.014, f"{mag_max[c]:.2f}", ha="right", va="center", fontsize=10.5)

ax.text(
    0.57, 0.030,
    "Color intensity based on frequency within each contamination category.",
    fontsize=12, fontweight="bold", ha="center",
)

plt.savefig("contamination_frequency_archaea.png", dpi=600, bbox_inches="tight", facecolor="white")
plt.savefig("contamination_frequency_archaea.svg", bbox_inches="tight", facecolor="white")
plt.savefig("contamination_frequency_archaea.pdf", bbox_inches="tight", facecolor="white")