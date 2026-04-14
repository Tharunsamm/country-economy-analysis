from __future__ import annotations

from pathlib import Path

import matplotlib.pyplot as plt
import pandas as pd
import seaborn as sns


def main() -> None:
    project_root = Path(__file__).resolve().parents[1]
    data_path = project_root / "data" / "data.csv"
    out_dir = project_root / "reports" / "figures"
    out_dir.mkdir(parents=True, exist_ok=True)

    df = pd.read_csv(data_path)

    # Consistent styling
    sns.set_theme(style="whitegrid", context="talk")

    # 1) Distribution of Internet Users
    plt.figure(figsize=(10, 5))
    sns.histplot(df["InternetUsers"], bins=20, kde=True, color="#2a6fbb")
    plt.title("Distribution of Internet Users (%) Across Countries")
    plt.xlabel("Internet Users (% of population)")
    plt.ylabel("Number of countries")
    plt.tight_layout()
    plt.savefig(out_dir / "01_internet_users_distribution.png", dpi=200)
    plt.close()

    # 2) BirthRate by IncomeGroup (boxplot)
    order = (
        df.groupby("IncomeGroup")["InternetUsers"]
        .median()
        .sort_values(ascending=False)
        .index
    )
    plt.figure(figsize=(12, 5))
    sns.boxplot(
        data=df,
        x="IncomeGroup",
        y="BirthRate",
        order=order,
        hue="IncomeGroup",
        palette="Set2",
        legend=False,
    )
    plt.title("Birth Rate by Income Group")
    plt.xlabel("Income group")
    plt.ylabel("Birth rate")
    plt.xticks(rotation=15, ha="right")
    plt.tight_layout()
    plt.savefig(out_dir / "02_birthrate_by_income_group.png", dpi=200)
    plt.close()

    # 3) InternetUsers vs BirthRate with hue by IncomeGroup
    g = sns.lmplot(
        data=df,
        x="InternetUsers",
        y="BirthRate",
        hue="IncomeGroup",
        height=6,
        aspect=1.4,
        scatter_kws={"alpha": 0.75, "s": 60},
        line_kws={"linewidth": 2},
    )
    g.set_axis_labels("Internet Users (% of population)", "Birth rate")
    plt.title("Internet Usage vs Birth Rate (by Income Group)")
    plt.tight_layout()
    plt.savefig(out_dir / "03_internet_vs_birthrate_by_income.png", dpi=200)
    plt.close()

    # 4) Top 10 countries by InternetUsers
    top10 = df.sort_values("InternetUsers", ascending=False).head(10)
    plt.figure(figsize=(12, 6))
    sns.barplot(data=top10, y="CountryName", x="InternetUsers", color="#2a6fbb")
    plt.title("Top 10 Countries by Internet Users (%)")
    plt.xlabel("Internet Users (% of population)")
    plt.ylabel("")
    plt.tight_layout()
    plt.savefig(out_dir / "04_top10_internet_users.png", dpi=200)
    plt.close()

    # 5) Income-group summary (median internet and birth rate)
    summary = (
        df.groupby("IncomeGroup")
        .agg(
            internet_median=("InternetUsers", "median"),
            birthrate_median=("BirthRate", "median"),
        )
        .reset_index()
    )
    summary = summary.sort_values("internet_median", ascending=False)

    fig, ax1 = plt.subplots(figsize=(12, 6))
    sns.barplot(
        data=summary,
        x="IncomeGroup",
        y="internet_median",
        ax=ax1,
        color="#2a6fbb",
    )
    ax1.set_title("Median Internet Users and Birth Rate by Income Group")
    ax1.set_xlabel("Income group")
    ax1.set_ylabel("Median Internet Users (% of population)")
    ax1.tick_params(axis="x", rotation=15)

    ax2 = ax1.twinx()
    sns.pointplot(
        data=summary,
        x="IncomeGroup",
        y="birthrate_median",
        ax=ax2,
        color="#d1495b",
        markers="o",
        linestyles="-",
    )
    ax2.set_ylabel("Median Birth Rate")
    plt.tight_layout()
    plt.savefig(out_dir / "05_income_group_medians.png", dpi=200)
    plt.close()

    print(f"Saved figures to: {out_dir}")


if __name__ == "__main__":
    main()

