# Country Economy Analysis (Pandas EDA)

## Problem statement
Using a country-level dataset (birth rate, internet usage, and income group), this project explores:
- How internet usage varies across countries and income groups
- How birth rates differ by income group
- Whether internet usage and birth rate are related (EDA, not causation)

## Dataset
- **Rows**: 195 countries
- **Columns**: `CountryName`, `CountryCode`, `BirthRate`, `InternetUsers`, `IncomeGroup`
- **File**: `data/data.csv`

## Quantified insights (3–5)
- **Internet access varies from 0.9% to 96.5%** across countries (range in `InternetUsers`).
- **Birth rate ranges from 7.9 to 49.7** (range in `BirthRate`), showing large demographic differences across countries.
- **Median internet usage increases strongly with income group**:
  - High income: **74.1%** (IQR 65.6–84.5)
  - Low income: **4.5%** (IQR 2.2–8.5)
- **Median birth rate decreases with income group**:
  - High income: **11.3** (IQR 10.1–14.5)
  - Low income: **36.9** (IQR 34.7–41.9)
- **Internet usage vs. birth rate has a strong negative correlation overall**: Pearson \(r = -0.816\) (EDA; not causation). By income group, the relationship remains negative but weaker (e.g., **upper-middle income \(r = -0.636\)**; **low income \(r = -0.269\)**).

## Figures
1. **Distribution of Internet Users (%)**: `reports/figures/01_internet_users_distribution.png`
2. **Birth Rate by Income Group (boxplot)**: `reports/figures/02_birthrate_by_income_group.png`
3. **Internet Usage vs Birth Rate (by Income Group)**: `reports/figures/03_internet_vs_birthrate_by_income.png`
4. **Top 10 Countries by Internet Users (%)**: `reports/figures/04_top10_internet_users.png`
5. **Median metrics by income group**: `reports/figures/05_income_group_medians.png`

## Business interpretation (chart-by-chart)
### 1) Distribution of Internet Users (%)
File: `reports/figures/01_internet_users_distribution.png`
- **What it shows**: adoption is not uniform; countries cluster at higher usage but there’s a meaningful low-usage tail.
- **Business interpretation**:
  - Averages can hide under-connected markets; segmentation is required.
  - The long tail suggests infrastructure/access constraints remain material for parts of the world.

### 2) Birth Rate by Income Group (boxplot)
File: `reports/figures/02_birthrate_by_income_group.png`
- **What it shows**: clear separation in typical birth rates across income groups, with low-income countries having higher medians and higher spread.
- **Business interpretation**:
  - Income group is a strong macro-level segment for demographic demand forecasting (education, healthcare, consumer categories).
  - The spread within groups indicates additional drivers beyond income (policy, culture, urbanization).

### 3) Internet Usage vs Birth Rate (by Income Group)
File: `reports/figures/03_internet_vs_birthrate_by_income.png`
- **What it shows**: a negative relationship overall, and still negative within each income group.
- **Business interpretation**:
  - Internet penetration can be treated as a proxy indicator for development/modernization in high-level EDA.
  - Comparing “like with like” (within an income group) reduces misleading cross-group conclusions.

### 4) Top 10 Countries by Internet Users (%)
File: `reports/figures/04_top10_internet_users.png`
- **What it shows**: highest-usage countries are predominantly high income (e.g., Iceland, Bermuda, Norway, Sweden, Denmark).
- **Business interpretation**:
  - These markets may be “digital-saturated” (incremental growth is harder; competition/product maturity matters).
  - Useful for identifying benchmark markets for digital adoption.

### 5) Median Internet Users and Birth Rate by Income Group
File: `reports/figures/05_income_group_medians.png`
- **What it shows**: a consistent pattern—higher income groups have higher median internet usage and lower median birth rates.
- **Business interpretation**:
  - Supports income group as a practical first-pass segment for macro comparisons.
  - Reinforces why global averages are insufficient for making decisions.

## Project highlights
- Reproducible workflow with **relative paths** (`data/data.csv`) and a one-command **chart export** script.
- Practical EDA checks: missing values, duplicates, and basic schema validation.
- Clear segmentation by `IncomeGroup`, ranked comparisons, and correlation EDA with appropriate caveats.

## Skills demonstrated
- **Python**: pandas (wrangling/aggregation), matplotlib/seaborn (visualization)
- **EDA**: data validation, descriptive statistics (median/IQR), segmentation, correlation analysis
- **Communication**: report-style storytelling and chart interpretation for non-technical audiences

## Limitations
- **Limited feature set**: only a few variables are available; many drivers (education, healthcare access, urbanization) are not included.
- **Single snapshot**: without time-series data, the analysis cannot show trends or changes over time.
- **Data definitions/source not embedded**: the dataset would benefit from a documented source, year, and variable definitions.

## Next steps
- Add a **data dictionary** (`data/README.md`) with source, year, and definitions.
- Extend the dataset with additional indicators (e.g., GDP per capita, education, life expectancy) to reduce omitted-variable bias.
- Add simple statistical comparisons (e.g., confidence intervals or nonparametric tests) for differences across income groups.
- Publish a lightweight dashboard (optional) to make the results easier to explore.

## Data Analyst resume bullet points (copy/paste)
- Analyzed a 195-country dataset in Python (pandas) to assess how internet penetration relates to birth rates across income segments; summarized distributions and outliers with clear visual storytelling.
- Built segmented KPI summaries by income group using robust statistics (median/IQR), showing median internet usage of **74.1%** in high-income vs **4.5%** in low-income countries.
- Quantified the relationship between internet usage and birth rate with correlation analysis (overall Pearson \(r = -0.816\)), and compared patterns within income groups to avoid misleading cross-segment conclusions.
- Automated export of 5 recruiter-ready visualizations using a reusable script (`scripts/export_charts.py`) and produced a concise report (`reports/REPORT.md`) for stakeholder-friendly communication.

