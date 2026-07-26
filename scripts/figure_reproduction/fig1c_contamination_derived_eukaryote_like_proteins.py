#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Fig. 1c — MAGs harbouring contamination-derived eukaryote-like proteins (%)

Reproduces the published panel: percentage of MAGs in each major archaeal
group that encode proteins located on contaminant contigs and showing
apparent similarity to eukaryotic homologues (bacterial-, eukaryotic-,
viral- and unclassified-derived categories).

Data source (deposited with the manuscript):
    data/decontamination/assessment/contamination_derived_eukaryote_like_protein_frequency.xlsx
Summary percentages below match the deposited assessment tables and are
embedded here for figure layout only.

Dependencies:
    pip install matplotlib numpy

Outputs (current working directory):
    contamination_derived_eukaryote_like_proteins.png
    contamination_derived_eukaryote_like_proteins.svg
    contamination_derived_eukaryote_like_proteins.pdf

Usage:
    python scripts/figure_reproduction/fig1c_contamination_derived_eukaryote_like_proteins.py
"""

import numpy as np
import matplotlib as mpl
import matplotlib.pyplot as plt
from matplotlib.patches import Circle, FancyBboxPatch, Polygon
from matplotlib.gridspec import GridSpec

mpl.rcParams["font.family"] = "DejaVu Sans"
mpl.rcParams["svg.fonttype"] = "none"
mpl.rcParams["pdf.fonttype"] = 42
mpl.rcParams["axes.linewidth"] = 1.2

# ---------------------------------------------------------------------------
# Summary statistics (from data/decontamination/assessment/contamination_derived_eukaryote_like_protein_frequency.xlsx)
# values = % of MAGs with ≥1 contamination-derived protein that has
#          apparent similarity to eukaryotic homologues
# Rows in each list: Asgard, TACK, Euryarchaeota, DPANN (same N for all)
# ---------------------------------------------------------------------------
groups = ["Asgard", "TACK", "Euryarchaeota", "DPANN"]
n = 469  # MAG count per group used as denominator; confirm against assessment tables

datasets = [
    {
        "title": "Bacterial-derived",
        "color": "#1F5FAF",
        "values": [0.85, 0.21, 0.00, 0.21],
        "xmax": 1.00,
        "xticks": [0.00, 0.25, 0.50, 0.75, 1.00],
    },
    {
        "title": "Eukaryotic-derived",
        "color": "#ED1C24",
        "values": [2.99, 1.07, 0.43, 0.64],
        "xmax": 3.00,
        "xticks": [0, 1, 2, 3],
    },
    {
        "title": "Viral-derived",
        "color": "#6F2DA8",
        "values": [1.71, 0.85, 0.21, 0.64],
        "xmax": 2.00,
        "xticks": [0.0, 0.5, 1.0, 1.5, 2.0],
    },
    {
        "title": "Unclassified-derived",
        "color": "#666666",
        "values": [0.64, 0.00, 0.00, 0.00],
        "xmax": 0.80,
        "xticks": [0.0, 0.2, 0.4, 0.6, 0.8],
    },
]

# ---------------------------------------------------------------------------
# Figure
# ---------------------------------------------------------------------------
fig = plt.figure(figsize=(18, 4.8), dpi=300)
gs = GridSpec(
    1, 5,
    width_ratios=[1.05, 2.15, 2.15, 2.15, 2.15],
    wspace=0.32, left=0.025, right=0.995, top=0.78, bottom=0.17,
)

fig.text(0.015, 0.92, "c", fontsize=19, fontweight="bold", va="center")
fig.text(
    0.04, 0.92,
    "MAGs harbouring contamination-derived eukaryote-like proteins (%)",
    fontsize=20, fontweight="bold", va="center",
)

ax_labels = fig.add_subplot(gs[0, 0])
ax_labels.set_xlim(0, 1)
ax_labels.set_ylim(-0.5, 3.5)
ax_labels.axis("off")
ypos = np.arange(len(groups))[::-1]
for y, g in zip(ypos, groups):
    ax_labels.text(
        0.02, y, f"{g}\n(N={n})",
        ha="left", va="center", fontsize=12.5, fontweight="bold",
    )


def draw_bacteria_icon(ax, x, y, color):
    for dx, dy, ang in [(-0.05, 0.02, 25), (0.05, -0.03, 25)]:
        patch = FancyBboxPatch(
            (x + dx - 0.045, y + dy - 0.09), 0.09, 0.18,
            boxstyle="round,pad=0.01,rounding_size=0.05",
            facecolor="#BFD5F2", edgecolor=color, linewidth=1.2,
            transform=ax.transAxes, clip_on=False,
        )
        t = mpl.transforms.Affine2D().rotate_deg_around(x + dx, y + dy, ang) + ax.transAxes
        patch.set_transform(t)
        ax.add_patch(patch)


def draw_euk_icon(ax, x, y, color):
    ax.add_patch(Circle(
        (x, y), 0.09, transform=ax.transAxes,
        facecolor="#F7C7C7", edgecolor=color, linewidth=1.2, clip_on=False,
    ))
    ax.add_patch(Circle(
        (x, y), 0.038, transform=ax.transAxes,
        facecolor="#F27D7D", edgecolor=color, linewidth=1.0, clip_on=False,
    ))


def draw_virus_icon(ax, x, y, color):
    ax.add_patch(Circle(
        (x, y), 0.075, transform=ax.transAxes,
        facecolor="#D8C1EC", edgecolor=color, linewidth=1.2, clip_on=False,
    ))
    for ang in np.linspace(0, 2 * np.pi, 8, endpoint=False):
        x1, y1 = x + 0.077 * np.cos(ang), y + 0.077 * np.sin(ang)
        x2, y2 = x + 0.103 * np.cos(ang), y + 0.103 * np.sin(ang)
        ax.plot([x1, x2], [y1, y2], color=color, lw=1.1, transform=ax.transAxes, clip_on=False)
        ax.add_patch(Circle(
            (x2, y2), 0.008, transform=ax.transAxes,
            facecolor="#D8C1EC", edgecolor=color, linewidth=1.0, clip_on=False,
        ))
    theta = np.linspace(0, 2 * np.pi, 7)[:-1] + np.pi / 6
    pts = np.c_[x + 0.04 * np.cos(theta), y + 0.04 * np.sin(theta)]
    ax.add_patch(Polygon(
        pts, closed=True, fill=False, edgecolor=color, linewidth=1.0,
        transform=ax.transAxes, clip_on=False,
    ))


def draw_unknown_icon(ax, x, y, color):
    ax.add_patch(Circle(
        (x, y), 0.09, transform=ax.transAxes,
        facecolor="#EEEEEE", edgecolor=color, linewidth=1.2, clip_on=False,
    ))
    ax.text(
        x, y - 0.004, "?", transform=ax.transAxes,
        ha="center", va="center", fontsize=34, fontweight="bold", color=color,
    )


for i, item in enumerate(datasets):
    ax = fig.add_subplot(gs[0, i + 1])
    vals = np.array(item["values"])
    color = item["color"]
    xmax = item["xmax"]

    ax.set_xlim(0, xmax)
    ax.set_ylim(-0.25, 3.45)
    ax.spines["top"].set_visible(False)
    ax.spines["right"].set_visible(False)
    ax.spines["left"].set_visible(False)
    ax.spines["bottom"].set_linewidth(1.2)
    ax.tick_params(axis="y", left=False, labelleft=False)
    ax.tick_params(axis="x", width=1.0, length=6, labelsize=10.5)
    ax.set_xticks(item["xticks"])

    if i == 0:
        ax.set_xticklabels([f"{x:.2f}" for x in item["xticks"]])
    elif i in (2, 3):
        ax.set_xticklabels([f"{x:.1f}" for x in item["xticks"]])
    else:
        ax.set_xticklabels([str(int(x)) for x in item["xticks"]])

    for y in ypos:
        ax.hlines(y, 0, xmax, color="#8D8D8D", lw=1.6, linestyles="dotted", zorder=1)

    for y, val in zip(ypos, vals):
        ax.hlines(y, 0, val, color=color, lw=2.1, zorder=2)
        ax.scatter(val, y, s=135, color=color, edgecolor=color, zorder=3)
        xtext = min((xmax * 0.06 if val == 0 else val + xmax * 0.05), xmax * 0.96)
        ax.text(
            xtext, y, f"{val:.2f}",
            color=color, fontsize=11.5, fontweight="bold",
            ha="left", va="center",
            bbox=dict(facecolor="white", edgecolor="none", pad=0.3),
        )

    ax.text(
        0.03, 1.18, item["title"],
        transform=ax.transAxes, color=color, fontsize=17, fontweight="bold",
        ha="left", va="center", clip_on=False,
    )
    if i == 0:
        draw_bacteria_icon(ax, 0.83, 1.18, color)
    elif i == 1:
        draw_euk_icon(ax, 0.84, 1.18, color)
    elif i == 2:
        draw_virus_icon(ax, 0.84, 1.18, color)
    else:
        draw_unknown_icon(ax, 0.80, 1.18, color)

    ax.set_xlabel(
        "Contamination-derived eukaryotic proteins (%)",
        fontsize=10.8, fontweight="bold", labelpad=6,
    )

plt.savefig("contamination_derived_eukaryote_like_proteins.png", dpi=600, bbox_inches="tight", facecolor="white")
plt.savefig("contamination_derived_eukaryote_like_proteins.svg", bbox_inches="tight", facecolor="white")
plt.savefig("contamination_derived_eukaryote_like_proteins.pdf", bbox_inches="tight", facecolor="white")
print("Saved PNG, SVG and PDF files.")