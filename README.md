# International STEM Master's ROI Analysis

A data analytics project measuring the financial return on investment of
international STEM master's degrees across six countries, for two
data-related occupations.

**Research question:** Which major study-abroad destinations offer the
best financial return for international master's students in
data-related STEM fields?

---

## Quick Start

- **Just want the results?** Open `ROI_Analysis.xlsx` - every sheet is
  pre-calculated with live formulas.
- **Want the SQL pipeline?** See `/sql` - run `staging` then
  `analysis`, against the CSVs in `/data`.
- **Want the full write-up?** Keep reading for methodology, findings,
  and limitations below.

---

## Scope

- **Population:** International (non-EU/non-domestic) students
- **Degree level:** Master's
- **Countries:** United States, Canada, United Kingdom, Australia,
  Germany, Netherlands
- **Occupations:** Data Analyst, Data Scientist
- **Programs sampled:** 10 per country (60 total), popular/standard
  choices for international students rather than only top-ranked
  universities, and eligible for international students.
- **Focus:** Financial ROI only. Quality-of-life and other subjective
  factors were deliberately excluded to keep the analysis defensible
  and narrow enough to complete as a first portfolio project.

A third occupation, **BI Analyst**, was considered and dropped as
distinct wage data isn't available for all countries. Keeping it
would have meant either duplicating the Data Scientist numbers under
a different label, or mixing government and non-government sourcing 
inconsistently across occupations. Dropping it kept the two remaining
occupations methodologically consistent.

---

## Methodology

### Tuition & living cost data
Collected per-program from official university sources, converted to
total program cost in USD (not per-year figures). Summarized using
**median and IQR** rather than simple averages, since a handful of
programs in each country are meaningfully more expensive than the
rest - an average would be skewed by outliers in a way the median
isn't.

### Salary data
"Entry-level" salary is defined **per country**, using whichever
concept that country's own labor-market data actually supports, rather
than forcing one arbitrary definition (e.g., "25th percentile")
everywhere it wasn't available:

| Country | Entry-level definition | Source |
|---|---|---|
| United States | 25th percentile wage | BLS OEWS (May 2025) |
| Canada | Job Bank "Low" wage | Job Bank / Government of Canada |
| United Kingdom | Home Office "new entrant" rate | UK gov.uk Skilled Worker visa going rates (ASHE-derived) |
| Germany | Lower quartile | Entgeltatlas, Bundesagentur für Arbeit (2025) |
| Australia | Graduate/entry-level, two different sources per role | Hays Australia salary guide (Data Analyst); multi-source-aggregated recruitment guide (Data Scientist) - non-government, see Limitations |
| Netherlands | Junior (0-2 yrs) salary | Nationale Beroepengids (non-government - see Limitations) |

Tax is calculated as **federal/national tax + mandatory payroll
contributions only** (e.g., FICA in the US, CPP/EI in Canada,
National Insurance in the UK). State/provincial tax is deliberately
excluded everywhere it varies significantly by region, since programs
are spread across many regions within each country and a single
regional rate would misrepresent the country as a whole.

### ROI formula
Two complementary metrics are computed for every program x occupation
combination:

**1. Payback period (years)**
```
Basic payback      = Total tuition / Annual net salary
Realistic payback  = (Total tuition + Total living cost) / Annual net salary
```

**2. Cumulative ROI (%) at 5 and 10 years post-graduation**
```
N-year ROI = ((N x Annual net salary) - Total investment) / Total investment x 100
```

Since each country has 10 sampled programs, results are summarized as
the **median plus 25th-75th percentile (IQR)** across those programs -
not a single country-level average - to show how much the outcome
depends on which specific program a student picks.

### Employment rate - dropped
An employment-rate variable was originally planned as a multiplier on
expected earnings, but was dropped after the data proved impossible to
source consistently - the U.S. has no government study of
international-student outcomes comparable to Canada's StatCan National
Graduates Survey, and available figures mixed incompatible populations
(international vs. domestic, STEM vs. all fields). Rather than force
in inconsistent numbers, this was documented as a scope limitation.
Payback and ROI figures assume continuous employment in the target
occupation from graduation onward.

---

## Key findings

Ranked by median realistic payback period (fastest to slowest):

| Rank | Country | Realistic payback (median) |
|---|---|---|
| 1 | Germany | ~0.65-0.73 years |
| 2 | Canada | ~1.37-1.62 years |
| 3 | Netherlands | ~1.65-1.94 years |
| 4 | United Kingdom | ~1.80-2.45 years |
| 5 | United States | ~2.10-2.54 years |
| 6 | Australia | ~2.64-2.86 years |

- **Occupation matters almost as much as country.** Data Scientist
  outperforms Data Analyst on payback speed and 10-year ROI in every
  country, typically by 3-6 months of payback time and 100-200
  percentage points of 10-year ROI.
- **Germany's lead is a tuition-policy effect, not a salary effect.**
  Its entry-level pay is mid-pack; the free-tuition policy at several
  public universities is what drives the result.
- **Program choice matters far more in some countries than others.**
  The spread between a country's cheapest and priciest-to-payback
  sampled program ranges from under 2 months (UK, Germany) to nearly
  10 months (Netherlands).
- **10-year ROI compounds these gaps** - Germany (~1,280-1,440%) vs.
  Australia (~250-280%) reflects a persistent cost-to-earnings
  difference, not just a head start. Read Germany's ROI% cautiously
  given its near-zero tuition denominator (see Limitations).

---

## Known data limitations (read before citing any single number)

- **Germany's near-zero tuition:** 7 of Germany's 10 sampled programs
  have $0 tuition (a real German public-university policy, not missing
  data). This makes the *basic* payback metric collapse toward zero
  and inflates 10-year ROI% into the four-digit range - mathematically
  correct, but a reflection of a near-zero denominator, not evidence
  that a German degree is "10x better." The *realistic* payback metric
  (which includes living costs) is the more meaningful comparison
  point for Germany.
- **Australia's salary figures come from two different private sources**,
  not one like the other five countries. An initial single-source
  version (SEEK Grad) showed identical pay for both roles - a red flag,
  since no other country's data did that. On investigation, Australian
  entry-level Data Scientist estimates varied wildly across sources
  (~AUD $57,000-$140,000), a wider spread than any other country here.
  The current figures (Hays for Data Analyst, an aggregated recruitment
  guide for Data Scientist) are more credible but still less certain
  than the other five countries. Government sources (ABS / Jobs and
  Skills Australia) were attempted first but wage data was suppressed
  or not yet published for these specific occupation codes.
- **Netherlands' salary and tax figures are estimates**, not
  primary-sourced - CBS publishes wage data by sector/CAO, not by
  occupation title, so no government wage-lookup tool exists like the
  other five countries have. Salary uses a private careers-guidance
  site; the tax rate is interpolated after a conflicting calculator
  was found unreliable (see `Graduate_outcomes.xlsx` notes for detail).
- **Employment rate is not modeled** (see Methodology above).
- **Salary is held flat** - no assumed post-graduation raises - across
  the payback/ROI horizon, which makes payback periods conservative
  (slightly overstated) relative to reality.
- **Opportunity cost** (income forgone while studying) is not included
  in total investment. This would push payback periods later,
  especially for two-year programs, and is a natural extension for a
  future version.

---

## Repository structure

```
├── README.md
├── data/
│   ├── tuition_data.csv
│   └── salary_data.csv
├── sql/
│   ├── staging/
│   │   └── 01_create_and_validate_staging.sql
│   └── analysis/
│       ├── 02_roi_calculations.sql
│       ├── 03_summary_median_iqr.sql
│       └── 04_rankings_window_functions.sql
├── Master_Tuition_Table.xlsx      (source data + validation notes)
├── Graduate_outcomes.xlsx         (salary/tax data + per-row sourcing)
└── ROI_Analysis.xlsx              (Excel version of the full analysis, with live formulas)
```

## How to reproduce this analysis

1. **Excel version:** open `ROI_Analysis.xlsx` - all four sheets
   (Tuition_Data, Salary_Data, ROI_Calculations, Summary) use live
   formulas, so editing the source data recalculates everything
   downstream automatically.
2. **SQL / Databricks version:**
   - Upload `data/tuition_data.csv` and `data/salary_data.csv` as
     tables named `tuition_data` and `salary_data` in a Databricks
     workspace (Catalog → Create table → Upload file)
   - Run the scripts in order: `01_create_and_validate_staging.sql` →
     `02_roi_calculations.sql` → `03_summary_median_iqr.sql` →
     `04_rankings_window_functions.sql`
   - `03` and `04` create the views (`roi_calculations`, `roi_summary`)
     used to build the dashboard
3. **Dashboard:** built in Databricks AI/BI Dashboards on top of the
   `roi_summary` view - payback comparison, investment-vs-salary
   scatter, and program-consistency (spread) charts.

---

## Tech stack / skills demonstrated

- **Data collection & validation:** multi-source aggregation from
  government labor-market and university sources, with explicit
  validation checks (duplicate detection, null checks, source-year
  consistency, primary-vs-aggregator source verification)
- **SQL:** staging validation, CTEs/views, `INNER JOIN`, conditional
  aggregation, `MEDIAN()` / `percentile_cont() WITHIN GROUP`, and
  window functions (`RANK() OVER`, `MIN() OVER`)
- **Statistical framing:** median + IQR over simple averages to
  represent within-country spread rather than a single point estimate
- **Methodology transparency:** every non-obvious decision (dropped
  variables, proxy occupation codes, private-source fallbacks) is
  documented at the point it was made, not glossed over after the fact

---

## License

MIT License - feel free to reuse the methodology or code. Note the
underlying salary and tuition figures reflect specific years' sourcing and
should be re-verified before use in any real decision-making.

