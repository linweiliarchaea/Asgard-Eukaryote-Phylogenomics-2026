#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Fig. 3d (panel d) — Topology tests (Approximately Unbiased test)

Reproduces the published panel summarizing AU tests of alternative
eukaryotic placements relative to the supported topology
((TACK, Asgard), Eukaryotes).

Supported topology and alternative constraint topologies were evaluated
with IQ-TREE (AU test). P-values below are taken from the deposited
AU output and are embedded here for figure layout only.

Data source (deposited with the manuscript):
    data/trees/AU_test_results.iqtree and/or data/trees/robustness_analyses.xlsx associated with AU topology tests

Update the path below to match your repository layout.

Dependencies:
    pip install matplotlib numpy

Outputs (current working directory):
    au_topology_test.png
    au_topology_test.svg
    au_topology_test.pdf

Usage:
    python scripts/figure_reproduction/fig3d_au_topology_test.py
"""

import math
import numpy as np
import matplotlib as mpl
import matplotlib.pyplot as plt
from matplotlib.patches import FancyBboxPatch, Circle

mpl.rcParams["font.family"] = "DejaVu Sans"
mpl.rcParams["svg.fonttype"] = "none"
mpl.rcParams["pdf.fonttype"] = 42
mpl.rcParams["axes.linewidth"] = 1.4

# ---------------------------------------------------------------------------
# AU test results (from IQ-TREE AU output / deposited summary tables)
# P = Approximately Unbiased test P-value
# Rejection strength plotted as -log10(P); dashed line = P = 0.05
# ---------------------------------------------------------------------------
supported_topology = "((TACK, Asgard),Eukaryotes)"
supported_p = 0.999

# Alternative constrained topologies and their AU P-values
alternatives = [
    ("(Heimdallarchaeia,Eukaryotes)", 6.36e-05),
    ("(Njordarchaeia,Eukaryotes)", 0.000263),
    ("(Hodarchaeales,Eukaryotes)", 0.000255),
    ("(TACK,Eukaryotes)", 0.00158),
]

labels = [x[0] for x in alternatives]
pvals = np.array([x[1] for x in alternatives], dtype=float)
strength = -np.log10(pvals)  # rejection strength
threshold_x = -math.log10(0.05)  # P = 0.05

# ---------------------------------------------------------------------------
# Figure
# ---------------------------------------------------------------------------
fig = plt.figure(figsize=(10.6, 7.2), dpi=300)
ax = fig.add_axes([0.42, 0.15, 0.38, 0.53])

fig.text(0.015, 0.94, "d", fontsize=33, fontweight="bold", va="center")
fig.text(
    0.065, 0.94, "Topology tests (Approximately Unbiased test)",
    fontsize=28, fontweight="bold", va="center",
)

# Supported topology banner
box = FancyBboxPatch(
    (0.055, 0.735), 0.90, 0.135,
    transform=fig.transFigure,
    boxstyle="round,pad=0.004,rounding_size=0.007",
    facecolor="#EEF8EF", edgecolor="#2AAA5A", linewidth=1.5,
)
fig.add_artist(box)

cx, cy, r = 0.11, 0.802, 0.037
fig.add_artist(Circle(
    (cx, cy), r, transform=fig.transFigure,
    facecolor="white", edgecolor="#08A719", linewidth=4,
))
fig.lines.append(mpl.lines.Line2D(
    [cx - 0.019, cx - 0.006, cx + 0.024],
    [cy - 0.002, cy - 0.022, cy + 0.017],
    transform=fig.transFigure, color="#08A719", linewidth=4,
    solid_capstyle="round", solid_joinstyle="round",
))
fig.text(0.165, 0.802, supported_topology, fontsize=27, fontweight="bold", va="center")
fig.text(
    0.77, 0.802, rf"$P = {supported_p:.3f}$",
    fontsize=25, fontweight="bold", style="italic", va="center",
)

# Alternative topologies: lollipop plot of -log10(P)
y = np.arange(len(labels))[::-1]
ax.set_xlim(0, 5)
ax.set_ylim(-0.4, len(labels) - 0.6)

ax.axvline(threshold_x, color="black", linewidth=2.8, linestyle=(0, (5, 4)), zorder=1)
ax.text(
    threshold_x, len(labels) - 0.52, r"$P = 0.05$",
    ha="center", va="bottom", fontsize=16, fontweight="bold", style="italic",
)

line_color = "#E34234"
for yy, xx in zip(y, strength):
    ax.hlines(yy, 0, xx, color=line_color, linewidth=3.2, zorder=2)
    ax.scatter(xx, yy, s=150, color=line_color, zorder=3)

ax.set_yticks(y)
ax.set_yticklabels(labels, fontsize=16, fontweight="bold")

for yy, p in zip(y, pvals):
    if p < 0.001:
        ptxt = f"P = {p:.2e}".replace("e-0", "e−").replace("e-", "e−")
    else:
        ptxt = f"P = {p:.6g}"
    ax.text(
        5.20, yy, ptxt, fontsize=16, fontweight="bold",
        style="italic", ha="left", va="center", clip_on=False,
    )

ax.set_xticks(np.arange(0, 6, 1))
ax.tick_params(axis="x", labelsize=16, width=2.3, length=7)
ax.tick_params(axis="y", width=0, length=0)
for tick in ax.get_xticklabels():
    tick.set_fontweight("bold")

ax.spines["top"].set_visible(False)
ax.spines["right"].set_visible(False)
ax.spines["left"].set_linewidth(2.4)
ax.spines["bottom"].set_linewidth(2.4)
ax.set_xlabel(
    r"Rejection strength for alternative topologies, $-\log_{10}(P)$",
    fontsize=16, fontweight="bold", labelpad=10,
)

plt.savefig("au_topology_test.png", dpi=600, bbox_inches="tight", facecolor="white")
plt.savefig("au_topology_test.svg", bbox_inches="tight", facecolor="white")
plt.savefig("au_topology_test.pdf", bbox_inches="tight", facecolor="white")
print("Saved: au_topology_test.png, au_topology_test.svg, au_topology_test.pdf")